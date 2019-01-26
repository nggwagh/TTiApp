//
//  PlaybookTableViewController.swift
//  TeamTTI
//
//  Created by Mohini Mehetre on 17/12/18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import UIKit
import MMDrawerController
import Moya

class PlaybookTableViewController: UITableViewController {

    //MARK:- Private Variable

    var pullToRefreshControl   = UIRefreshControl()
    var playbookNetworkTask: Cancellable?
    private var playbooks = [Playbook]()

    //MARK:- View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //API Call
        self.getPlaybooks()
        
        // Refresh control add in tableview.
        pullToRefreshControl.attributedTitle = NSAttributedString(string: "")
        pullToRefreshControl.addTarget(self, action: #selector(getPlaybooks), for: .valueChanged)
        self.tableView.addSubview(pullToRefreshControl)
    }

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == Constant.Storyboard.Playbook.viewPlaybookIdentifier {
            
            let row: Int = sender as! Int
            
            let playbookObject = self.playbooks[row] as Playbook

            let destinationVC = segue.destination as! PlaybookDetailViewController
            
            destinationVC.playbookURL = playbookObject.playbookURL![0]
        }
    }

    
    
    // MARK: - Private methods
    
    @objc func getPlaybooks() {
        
        //Show progress hud
        self.showHUD(progressLabel: "")
        
        playbookNetworkTask?.cancel()
        
        playbookNetworkTask = MoyaProvider<NewsApi>(plugins: [AuthPlugin()]).request(.playbooks()) { result in
            
            // hiding progress hud
            self.dismissHUD(isAnimated: true)
            
            self.pullToRefreshControl.endRefreshing()
            
            switch result {
                
            case let .success(response):
                print(response)
                
                if case 200..<400 = response.statusCode {
                    
                    do{
                        let jsonDict = try JSONSerialization.jsonObject(with: response.data, options: []) as! [[String: Any]]
                        print(jsonDict)
                        
                        self.playbooks = Playbook.build(from: jsonDict)
                        self.tableView.reloadData()
                    }
                    catch let error {
                        print(error.localizedDescription)
                        Alert.show(alertType: .parsingFailed, onViewContoller: self)
                    }
                }
                else
                {
                    print("Status code:\(response.statusCode)")
                    Alert.show(alertType: .wrongStatusCode(response.statusCode), onViewContoller: self)
                }
                
                
                break
            case let .failure(error):
                print(error.localizedDescription)
                Alert.showMessage(onViewContoller: self, title: Bundle.main.displayName, message: error.localizedDescription)
                break
            }
        }
   }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.playbooks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaybookCell", for: indexPath)

        // Configure the cell...
        let playbookObject = self.playbooks[indexPath.row] as Playbook
        
        cell.textLabel?.text = playbookObject.name
        
        return cell
    }
 
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        searchController.isActive = false
        
        self.performSegue(withIdentifier: Constant.Storyboard.Playbook.viewPlaybookIdentifier, sender: indexPath.row)
    }

    //MARK: - IBAction methods
    
    @IBAction func leftMenuClicked() {
        RootViewControllerFactory.centerContainer.toggle(MMDrawerSide.left, animated: true) { status in
            //Disable tableview interaction when side menu is open
            if RootViewControllerFactory.centerContainer.openSide == MMDrawerSide.left{
                self.view.isUserInteractionEnabled = false
            }
            else{
                self.view.isUserInteractionEnabled = true
            }
        }
    }
}
