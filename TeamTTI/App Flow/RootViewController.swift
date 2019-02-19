//
//  RootViewControllerFactory.swift
//  TeamTTI
//
//  Created by Mayur Deshmukh on 04/11/18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import Foundation
import UIKit
import MMDrawerController

class RootViewControllerFactory {
    
    static var centerContainer = MMDrawerController()
    
    static func getRootViewController() -> UIViewController {
        
        if let _ = SettingsManager.shared().getUserID() {
            let role = SettingsManager.shared().getUserRole()
            if (role == "1" || role == "2") {
                let managerHomeStoryboard = UIStoryboard.init(name: Constant.Storyboard.Home.id_manager, bundle: nil)
                let homeStoryboard = UIStoryboard.init(name: Constant.Storyboard.Home.id, bundle: nil)
                let managerHomeViewController = managerHomeStoryboard.instantiateInitialViewController()
                let leftSideMenuNavitationController = homeStoryboard.instantiateViewController(withIdentifier: Constant.Storyboard.Home.leftSideMenuNavigationController) as! UINavigationController
                centerContainer = MMDrawerController(center: managerHomeViewController, leftDrawerViewController: leftSideMenuNavitationController)
                centerContainer.openDrawerGestureModeMask = .all
                centerContainer.closeDrawerGestureModeMask = .all
                centerContainer.centerHiddenInteractionMode = .none
                centerContainer.shouldStretchDrawer = false
            }
            else {
                let homeStoryboard = UIStoryboard.init(name: Constant.Storyboard.Home.id, bundle: nil)
                let homeViewController = homeStoryboard.instantiateInitialViewController()
                let leftSideMenuNavitationController = homeStoryboard.instantiateViewController(withIdentifier: Constant.Storyboard.Home.leftSideMenuNavigationController) as! UINavigationController
                centerContainer = MMDrawerController(center: homeViewController, leftDrawerViewController: leftSideMenuNavitationController)
                centerContainer.openDrawerGestureModeMask = .all
                centerContainer.closeDrawerGestureModeMask = .all
                centerContainer.centerHiddenInteractionMode = .none
                centerContainer.shouldStretchDrawer = false
            }
           
//            centerContainer.centerHiddenInteractionMode = MMDrawerOpenCenterInteractionMode.full
            return centerContainer
            
        } else {
            let loginStoryboard = UIStoryboard.init(name: Constant.Storyboard.Login.id, bundle: nil)
            return loginStoryboard.instantiateInitialViewController()!
        }
    }
}

class RootViewControllerManager {
    
    static func refreshRootViewController() {
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            if let window = appDelegate.window {
                if let _ = window.rootViewController {
                    UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromRight, animations: {
                        window.rootViewController = RootViewControllerFactory.getRootViewController()
                    })
                    return
                }
            } else {
                let window = UIWindow()
                appDelegate.window = window
                window.makeKeyAndVisible()
            }
            
            appDelegate.window?.rootViewController = RootViewControllerFactory.getRootViewController()
        }
        
    }
    
}
