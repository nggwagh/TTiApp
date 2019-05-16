//
//  PerformanceViewController.swift
//  TeamTTI
//
//  Created by Nikhil Wagh on 5/16/19.
//  Copyright © 2019 TeamTTI. All rights reserved.
//

import UIKit
import MMDrawerController
import Moya


class PerformanceViewController: UIViewController {

    //MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    //MARK: - IBAction methods
    
    @IBAction func leftMenuClicked() {
        RootViewControllerFactory.centerContainer.toggle(MMDrawerSide.left, animated: true) { status in
        }
    }
    
}
