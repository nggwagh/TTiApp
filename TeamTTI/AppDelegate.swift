//
//  AppDelegate.swift
//  TeamTTI
//
//  Created by Mayur Deshmukh on 21/10/18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import UserNotifications
import Fabric
import Crashlytics
import MMDrawerController

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //Start crashlytics
        Fabric.sharedSDK().debug = true
        Fabric.with([Crashlytics.self])
        
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        TTILocationManager.sharedLocationManager.checkLocationAuthorization()
        
        registerForPushNotifications()

         // WHEN ALL IS NOT RUNNING AND RECEIVING NOTIFICATIONS
        if launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] != nil {
            
            let notification: [AnyHashable: Any]? = (launchOptions![UIApplicationLaunchOptionsKey.remoteNotification] as? [AnyHashable: Any])!
            
            self.application(application: UIApplication.shared, didReceiveRemoteNotification: notification! as [NSObject : AnyObject])
        }
        
        return true
    }
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.

    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
       
        UIApplication.shared.applicationIconBadgeNumber = 0
    //  self.checkVersionAndLogoutIfOld()

    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
        
        //Reset launchtime latitude and longitude
        SettingsManager.shared().setUserLocationLaunchTimeLatitude(0)
        SettingsManager.shared().setUserLocationLaunchTimeLongitude(0)
    }
    
    //MARK: -Global
    
    func checkVersionAndLogoutIfOld() {
        
        let dictionary = Bundle.main.infoDictionary!
        
        let newVersion = dictionary["CFBundleShortVersionString"] as! String
        let newBuild = dictionary["CFBundleVersion"] as! String
        
        if ((UserDefaults.standard.value(forKey: "version") != nil) && (UserDefaults.standard.value(forKey: "build") != nil)){
            
            let oldVersion = UserDefaults.standard.value(forKey: "version") as! String
            let oldBuild = UserDefaults.standard.value(forKey: "build") as! String
            
            if ((newVersion > oldVersion) || (newBuild > oldBuild)) {
                
                //logout
                
                //clear user details from user default
                SettingsManager.shared().resetSettings()
                
                for region in TTILocationManager.sharedLocationManager.locationManager.monitoredRegions {
                    
                    TTILocationManager.sharedLocationManager.locationManager.stopMonitoring(for: region)
                    print("Removed Region :\(region)")
                    
                }
                
                //Move to login screen
                RootViewControllerManager.refreshRootViewController()
                
                
                UserDefaults.standard.set(newVersion, forKey: "version")
                UserDefaults.standard.set(newBuild, forKey: "build")
                UserDefaults.standard.synchronize()
            }
            
        } else {
            
            //logout
            
            //clear user details from user default
            SettingsManager.shared().resetSettings()
            
            for region in TTILocationManager.sharedLocationManager.locationManager.monitoredRegions {
                
                TTILocationManager.sharedLocationManager.locationManager.stopMonitoring(for: region)
                print("Removed Region :\(region)")
                
            }
            
            //Move to login screen
            RootViewControllerManager.refreshRootViewController()
            
            
            UserDefaults.standard.set(newVersion, forKey: "version")
            UserDefaults.standard.set(newBuild, forKey: "build")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "TeamTTI")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    //MARK:- Push Notification
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            // 1. Check if permission granted
            guard granted else { return }
            // 2. Attempt registration for remote notifications on the main thread
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    @objc func whenReceivedPushNotification(payload: Any){
        
        let dictionary = payload as? [String: Any]
        
        if ((dictionary!["type"] as? String) == "news"){
            UserDefaults.standard.set(true, forKey: "isNews")
            }
        
        UserDefaults.standard.set(true, forKey: "isNotification")
        UserDefaults.standard.synchronize()
        RootViewControllerFactory.centerContainer.toggle(MMDrawerSide.left, animated: true, completion: nil)
        
    }

    
    //MARK:- Push Notification Delegate
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        // 1. Convert device token to string
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        // 2. Print device token to use for PNs payloads
        print("Device Token: \(token)")
        
        UserDefaults.standard.set(token, forKey: "DeviceToken")
        UserDefaults.standard.synchronize()
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // 1. Print out error if PNs registration not successful
        print("Failed to register for remote notifications with error: \(error)")
    }
    
   
    /*
        func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    
            print("Recived In Background/Foreground: \(userInfo)")
            self.whenReceivedPushNotification()
    
        }
   */
    
    private func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
        print("Recived In Background/Foreground: \(userInfo)")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.whenReceivedPushNotification(payload: userInfo)
        }
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        print("Recived In Background/Foreground: \(userInfo)")
        self.whenReceivedPushNotification(payload: userInfo)
    }

    
     func userNotificationCenter(_ center: UNUserNotificationCenter,  willPresent notification: UNNotification, withCompletionHandler   completionHandler: @escaping (_ options:   UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .sound])
    }

    
}

