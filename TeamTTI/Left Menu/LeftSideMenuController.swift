//
//  LeftSideMenuController.swift
//  TeamTTI
//
//  Created by Mohini Mehetre on 14/12/18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import UIKit
import MMDrawerController
import KeychainSwift

class LeftSideMenuController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private var menuItems : [String]!
    
    @IBOutlet weak var menuTableView: UITableView!
    
    @IBOutlet weak var versionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        menuItems = [""]
        
        
        self.versionLabel.text = String(format: "App version: %@ (%@)", Bundle.main.releaseVersionNumber!,Bundle.main.buildVersionNumber!)
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        menuItems = ["Home", "Planner", "News", "Playbooks", "Logout"]
        self.menuTableView.reloadData()
    }
    
    // MARK: - Private Methods
    
    func logoutTheUser() {
        
        //clear user details from keychain
        KeychainSwift().delete(Constant.API.Login.refreshToken)
        KeychainSwift().delete(Constant.API.Login.accessToken)
        KeychainSwift().delete(Constant.API.User.userID)
        
        self.removeRegionMonitoringWhenLogout()
        
        //Move to login screen
        RootViewControllerManager.refreshRootViewController()
    }

    //STOP MONITORING REGIONS IF USER LOGOUT THE APP
    func removeRegionMonitoringWhenLogout() {
        
        for region in TTILocationManager.sharedLocationManager.locationManager.monitoredRegions {
            
                TTILocationManager.sharedLocationManager.locationManager.stopMonitoring(for: region)
               print("Removed Region :\(region)")

        }
    }
    
    // MARK: - Table view data source

     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return menuItems.count
    }

    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = menuItems[indexPath.row] as String
        cell.textLabel?.textColor = UIColor.white
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    
    // MARK: - Table view delegate

     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch(indexPath.row)
        {
        case 0:
            let homeStoryboard = UIStoryboard.init(name: Constant.Storyboard.Home.id, bundle: nil)
            let homeViewController = homeStoryboard.instantiateInitialViewController()
            RootViewControllerFactory.centerContainer.centerViewController = homeViewController
            RootViewControllerFactory.centerContainer.toggle(MMDrawerSide.left, animated: true, completion: nil)
            break;
        case 1:
            
            let plannerStoryboard = UIStoryboard.init(name: Constant.Storyboard.Planner.id, bundle: nil)
            let plannerViewController = plannerStoryboard.instantiateInitialViewController()
            RootViewControllerFactory.centerContainer.centerViewController = plannerViewController
            RootViewControllerFactory.centerContainer.toggle(MMDrawerSide.left, animated: true, completion: nil)
 
            break;
        case 2:
            let newsStoryboard = UIStoryboard.init(name: Constant.Storyboard.News.id, bundle: nil)
            let newsViewController = newsStoryboard.instantiateInitialViewController()
            RootViewControllerFactory.centerContainer.centerViewController = newsViewController
            RootViewControllerFactory.centerContainer.toggle(MMDrawerSide.left, animated: true, completion: nil)
            break;
        case 3:
            let playbookStoryboard = UIStoryboard.init(name: Constant.Storyboard.Playbook.id, bundle: nil)
            let playbookViewController = playbookStoryboard.instantiateInitialViewController()
            RootViewControllerFactory.centerContainer.centerViewController = playbookViewController
            RootViewControllerFactory.centerContainer.toggle(MMDrawerSide.left, animated: true, completion: nil)
            break;
        case 4:
            self.logoutTheUser()
            break;
        default:
            break
        }
    }
}

extension Bundle {
    
    var releaseVersionNumber: String? {
        return self.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    var buildVersionNumber: String? {
        return self.infoDictionary?["CFBundleVersion"] as? String
    }
    
}
