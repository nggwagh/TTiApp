//
//  TTILocationDBManager.swift
//  TeamTTI
//
//  Created by Mohini Mehetre on 22/06/19.
//  Copyright © 2019 TeamTTI. All rights reserved.
//

import UIKit
import CoreData

protocol LocationDBProtocol {
    func moniteredStoresDeleted()
}

class TTILocationDBManager: NSObject {
    
    static var dbDelegate:LocationDBProtocol?
    
    static func save(currentLocationDetails: CurrentLocationDetails) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "TTICurrentLocation",
                                       in: managedContext)!
        
        //Check whether maximum count limit reached and show alert
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TTICurrentLocation")
        fetchRequest.includesPropertyValues = false
        
        //3
        let currentLocation = NSManagedObject(entity: entity,
                                              insertInto: managedContext)
        
        // 4
        currentLocation.setValue(currentLocationDetails.timestamp, forKeyPath: "timestamp")
        currentLocation.setValue(currentLocationDetails.currentlatitude, forKeyPath: "currentlatitude")
        currentLocation.setValue(currentLocationDetails.currentlongitude, forKeyPath: "currentlongitude")
        
        // 5
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Error while storing location details in core data: \(error.userInfo)")
        }
    }
    
    static func fetchLocations() -> [TTICurrentLocation] {
        //1
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let managedContext = appDelegate!.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<TTICurrentLocation>(entityName: "TTICurrentLocation")
        
        //3
        // Helpers
        var result = [TTICurrentLocation]()
        
        do {
            // Execute Fetch Request
            let storeMonitoring = try managedContext.fetch(fetchRequest)
            result = storeMonitoring
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return result
    }
    
    //Delete values from table
    static func deleteLocations(locations: [TTICurrentLocation], controllerRef: UIViewController) {
        
        dbDelegate = controllerRef as? LocationDBProtocol
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TTICurrentLocation")
        fetchRequest.includesPropertyValues = false // Only fetch the managedObjectID (not the full object structure)
        
        var fetchResults: [NSManagedObject] = []
        
        do {
            fetchResults = try managedContext.fetch(fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        
        do {
            for result in fetchResults {
                for location in locations {
                    if (result == location) {
                        managedContext.delete(location)
                    }
                }
            }
            dbDelegate?.moniteredStoresDeleted()
            try managedContext.save()
        } catch let error as NSError {
            controllerRef.dismissHUD(isAnimated: true)
            print("Error while deleting location details from core data: \(error.userInfo)")
        }
    }
}
