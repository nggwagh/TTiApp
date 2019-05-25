//
//  PerformanceDetailsViewController.swift
//  TeamTTI
//
//  Created by Nikhil Wagh on 5/16/19.
//  Copyright © 2019 TeamTTI. All rights reserved.
//

import UIKit
import Moya

class PerformanceDetailsViewController: UIViewController {

    //MARK: - IBOutlets

    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var storeNameLabel: UILabel?
    private var storeObjectives = [StoreObjective]()
    var storeName: String?
    var storeId: Int?
    private var objectiveNetworkTask: Cancellable?

    //MARK: - View Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.storeNameLabel?.text = self.storeName
        
        self.getStorePerformanceObjectiveList()
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    //MARK: - Private Methods
    
    func getStorePerformanceObjectiveList() {
        
        //Show progress hud
        self.showHUD(progressLabel: "")
        
        objectiveNetworkTask?.cancel()
        
        objectiveNetworkTask = MoyaProvider<StoreApi>(plugins: [AuthPlugin()]).request(.getStorePerformanceObjective(storeId: 2)) { result in
            
            // hiding progress hud
            self.dismissHUD(isAnimated: true)
            
            switch result {
                
            case let .success(response):
                print(response)
                
                if case 200..<400 = response.statusCode {
                    
                    do{
                        let jsonDict = try JSONSerialization.jsonObject(with: response.data, options: []) as! [String: Any]
                        print(jsonDict)
                        
                        self.storeObjectives = StoreObjective.build(from: jsonDict["objectives"] as! [[String : Any]])
                        
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
    
    
}




extension PerformanceDetailsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     //  return self.storeObjectives.count
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "StoreObjectiveTableViewCell", for: indexPath) as? StoreObjectiveTableViewCell {
          //  cell.configure(with: self.storeObjectives[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
}

extension PerformanceDetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    let objectiveObject = self.storeObjectives[indexPath.row]
        
        let storyboard = UIStoryboard.init(name: "Home", bundle: nil)
        
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "TaskDetailViewController") as! TaskDetailViewController
        
        destinationVC.tastDetails = objectiveObject
        
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
}
