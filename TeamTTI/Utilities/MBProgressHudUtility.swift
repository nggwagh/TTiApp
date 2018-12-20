//
//  MBProgressHudUtility.swift
//  TeamTTI
//
//  Created by Mohini Mehetre on 20/12/18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import UIKit
import MBProgressHUD

extension UIViewController {
    
    func showHUD(progressLabel:String){
        let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHUD.label.text = progressLabel
    }
    
    func dismissHUD(isAnimated:Bool) {
        DispatchQueue.main.async {
        MBProgressHUD.hide(for: self.view, animated: isAnimated)
        }
    }
}
