//
//  PlannerViewController.swift
//  TeamTTI
//
//  Created by Mohini Mehetre on 30/12/18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import UIKit
import MMDrawerController

class PlannerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlannerCell", for: indexPath) as! PlannerTableViewCell
        
        // Configure the cell...
        if indexPath.row == 0{
            cell.dateBackgroundView.isHidden = false
        }
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
}
