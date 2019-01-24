//
//  PlaybookTableViewController.swift
//  TeamTTI
//
//  Created by Mohini Mehetre on 17/12/18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import UIKit
import MMDrawerController

class PlaybookTableViewController: UITableViewController {

    var pullToRefreshControl   = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Refresh control add in tableview.
        pullToRefreshControl.attributedTitle = NSAttributedString(string: "")
        pullToRefreshControl.addTarget(self, action: #selector(getPlaybooks), for: .valueChanged)
        self.tableView.addSubview(pullToRefreshControl)
    }

    // MARK: - Private methods
    
    @objc func getPlaybooks() {
        pullToRefreshControl.endRefreshing()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaybookCell", for: indexPath)

        // Configure the cell...

        return cell
    }
 
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        searchController.isActive = false
        self.performSegue(withIdentifier: Constant.Storyboard.Playbook.viewPlaybookIdentifier, sender: indexPath)
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
