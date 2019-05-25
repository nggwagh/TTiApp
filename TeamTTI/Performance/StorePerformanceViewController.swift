//
//  StorePerformanceViewController.swift
//  TeamTTI
//
//  Created by Mohini Mehetre on 25/05/19.
//  Copyright © 2019 TeamTTI. All rights reserved.
//

import UIKit
import MMDrawerController
import Moya


class StorePerformanceViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView?
        
    var reloadSections: ((_ section: Int) -> Void)?
    
    var storeList = [StorePerformance]()
    
    private var storeNetworkTask: Cancellable?
    
    var refreshControl   = UIRefreshControl()

    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getStorePerformanceList()
        
        // Refresh control add in tableview.
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(getStorePerformanceList), for: .valueChanged)
        self.tableView!.addSubview(refreshControl)
    }
    
    
    //MARK: - Private Methods
    
    @objc func getStorePerformanceList(){
        
        //Show progress hud
        self.showHUD(progressLabel: "")
        
        storeNetworkTask?.cancel()
        
        storeNetworkTask = MoyaProvider<StoreApi>(plugins: [AuthPlugin()]).request(.getStorePerformanceList(regionId: SettingsManager.shared().getDefaultRegionID()!)) { result in
            
            // hiding progress hud
            self.dismissHUD(isAnimated: true)
            
            self.refreshControl.endRefreshing()

            
            switch result {
                
            case let .success(response):
                print(response)
                
                if case 200..<400 = response.statusCode {
                    
                    do{
                        let jsonDict = try JSONSerialization.jsonObject(with: response.data, options: []) as! [[String: Any]]
                        print(jsonDict)
                        
                        self.storeList = StorePerformance.build(from: jsonDict)
                        self.tableView?.reloadData()
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
    
    @IBAction func leftMenuClicked() {
        RootViewControllerFactory.centerContainer.toggle(MMDrawerSide.left, animated: true) { status in
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "PerformanceDetailsSegueIdentifier") {
            let permanceDetail = self.storeList[(sender as! NSIndexPath).row]
            let destination = segue.destination as! PerformanceDetailsViewController
            destination.storeName = permanceDetail.storeName
            destination.storeId = permanceDetail.id

        }
    }
}

extension StorePerformanceViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let permanceDetail = self.storeList[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RepPerformanceCell", for: indexPath) as? RepPerformanceCell {
            cell.item = permanceDetail
            return cell
        }
        return UITableViewCell()
    }
}

extension StorePerformanceViewController: UITableViewDelegate {
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "PerformanceDetailsSegueIdentifier", sender: indexPath)
    }
}
