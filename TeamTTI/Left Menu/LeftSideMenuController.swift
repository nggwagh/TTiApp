//
//  LeftSideMenuController.swift
//  TeamTTI
//
//  Created by Mohini Mehetre on 14/12/18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import UIKit
import MMDrawerController

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
        
        let role = SettingsManager.shared().getUserRole()
        
        if (role == "1")
        {
            menuItems = ["Home", "Stores", "Planner", "News", "Playbooks", "Surveys", "Logout"]
        }
        else if (role == "2")
        {
            menuItems = ["Home", "Stores", "Planner", "News", "Playbooks", "Surveys", "Store Performance", "Logout"]
        }
        else
        {
            menuItems = ["Home", "Planner", "News", "Playbooks", "Surveys", "Logout"]
        }
        
        self.menuTableView.reloadData()
        
        //WHEN RECEIVED PUSH NOTIFICATIONS
        if UserDefaults.standard.bool(forKey: "isNotification"){
            
            if UserDefaults.standard.bool(forKey: "isNews"){
                self.perform(#selector(loadNewsVC), with: nil, afterDelay: 0.5)
            } else{
                self.perform(#selector(loadSurveyVC), with: nil, afterDelay: 0.5)
            }
            
            UserDefaults.standard.set(false, forKey: "isNews")
            UserDefaults.standard.set(false, forKey: "isNotification")
            UserDefaults.standard.synchronize()
        }
    }
    
    // MARK: - Private Methods
    
    func loadHomeVC(){
        let homeStoryboard = UIStoryboard.init(name: Constant.Storyboard.Home.id, bundle: nil)
        let homeViewController = homeStoryboard.instantiateInitialViewController()
        RootViewControllerFactory.centerContainer.centerViewController = homeViewController
        RootViewControllerFactory.centerContainer.toggle(MMDrawerSide.left, animated: true, completion: nil)
    }
    
    func loadManagerHomeVC(){
        let managerHomeStoryboard = UIStoryboard.init(name: Constant.Storyboard.Home.id_manager, bundle: nil)
        let managerHomeViewController = managerHomeStoryboard.instantiateInitialViewController()
        RootViewControllerFactory.centerContainer.centerViewController = managerHomeViewController
        RootViewControllerFactory.centerContainer.toggle(MMDrawerSide.left, animated: true, completion: nil)
        
    }
    
    func loadPlannerVC(){
        let plannerStoryboard = UIStoryboard.init(name: Constant.Storyboard.Planner.id, bundle: nil)
        let plannerViewController = plannerStoryboard.instantiateInitialViewController()
        RootViewControllerFactory.centerContainer.centerViewController = plannerViewController
        RootViewControllerFactory.centerContainer.toggle(MMDrawerSide.left, animated: true, completion: nil)
    }
    
    @objc func loadNewsVC(){
        let newsStoryboard = UIStoryboard.init(name: Constant.Storyboard.News.id, bundle: nil)
        let newsViewController = newsStoryboard.instantiateInitialViewController()
        RootViewControllerFactory.centerContainer.centerViewController = newsViewController
        RootViewControllerFactory.centerContainer.toggle(MMDrawerSide.left, animated: true, completion: nil)
    }
    
    func loadPlaybookVC(){
        let playbookStoryboard = UIStoryboard.init(name: Constant.Storyboard.Playbook.id, bundle: nil)
        let playbookViewController = playbookStoryboard.instantiateInitialViewController()
        RootViewControllerFactory.centerContainer.centerViewController = playbookViewController
        RootViewControllerFactory.centerContainer.toggle(MMDrawerSide.left, animated: true, completion: nil)
    }
    
    @objc func loadSurveyVC(){
        let surveyStoryboard = UIStoryboard.init(name: Constant.Storyboard.Survey.id, bundle: nil)
        let surveyViewController = surveyStoryboard.instantiateInitialViewController()
        RootViewControllerFactory.centerContainer.centerViewController = surveyViewController
        RootViewControllerFactory.centerContainer.toggle(MMDrawerSide.left, animated: true, completion: nil)
    }
    
    @objc func loadRepPerformanceVC(){
        
        let performanceStoryboard = UIStoryboard.init(name: Constant.Storyboard.Performance.id, bundle: nil)
        let performanceViewController = performanceStoryboard.instantiateInitialViewController()
        RootViewControllerFactory.centerContainer.centerViewController = performanceViewController
        RootViewControllerFactory.centerContainer.toggle(MMDrawerSide.left, animated: true, completion: nil)
    
    }
    
    func logoutTheUser() {
        
        //clear user details from user default
        SettingsManager.shared().resetSettings()
        
        //Mohini:Location changes
//      self.removeRegionMonitoringWhenLogout()
        TTILocationManager.sharedLocationManager.locationManager.stopMonitoringSignificantLocationChanges()
        
        //Move to login screen
        RootViewControllerManager.refreshRootViewController()
        
        UserDefaults.standard.set(false, forKey: "isLogin")
        UserDefaults.standard.synchronize()
        
    }

    //STOP MONITORING REGIONS IF USER LOGOUT THE APP
    func removeRegionMonitoringWhenLogout() {
        
        for region in TTILocationManagerOld.sharedLocationManager.locationManager.monitoredRegions {
            
                TTILocationManagerOld.sharedLocationManager.locationManager.stopMonitoring(for: region)
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
        
        let role = SettingsManager.shared().getUserRole()

        switch(indexPath.row)
        {
        case 0:
            
            if (role == "1" || role == "2") {
               self.loadManagerHomeVC()
            }
            else {
                self.loadHomeVC()
            }

            break;
            
        case 1:
            
            if (role == "1" || role == "2") {
                self.loadHomeVC()
            }
            else {
                self.loadPlannerVC()
            }
           
            break;
            
        case 2:
            
             if (role == "1" || role == "2") {
                self.loadPlannerVC()
             }
             else{
                self.loadNewsVC()
             }
            
            break;
        case 3:
            
            if (role == "1" || role == "2") {
                self.loadNewsVC()
            }
            else{
                self.loadPlaybookVC()
            }
            
            break;
            
        case 4:
            
            if (role == "1" || role == "2") {
                self.loadPlaybookVC()
            }
            else{
                self.loadSurveyVC()
            }
            
            break;
            
        case 5:
            
            if (role == "1" || role == "2") {
                self.loadSurveyVC()
            }
            else{
                self.logoutTheUser()
            }
                        
            break;
            
        case 6:
            
            if (role == "1") {
                self.logoutTheUser()
            }
            else if (role == "2") {
                self.loadRepPerformanceVC()
            }
        
            break;
            
        case 7:
            
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
