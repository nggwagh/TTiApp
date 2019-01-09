//
//  Alert.swift
//  TeamTTI
//
//  Created by Deepak Sharma on 08.11.18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import Foundation
import UIKit

enum AlertTye {
    
    case wrongStatusCode(Int)
    case parsingFailed
    
    
}

struct Alert {
    
    static func show(alertType: AlertTye, onViewContoller vc: UIViewController) {
        switch alertType {
        case let .wrongStatusCode(statusCode):
            //check this as i am not sure
            if statusCode == 401 {
                self.showMessage(onViewContoller: vc, title: "Error", message: "Incorrect credentials.")
            }
        case .parsingFailed:
            self.showMessage(onViewContoller: vc, title: "Error", message: "Wrong response from server.")
        }
        
    }
    
    static func showMessage(onViewContoller vc: UIViewController, title: String? ,message: String? ) {
       let alertContoller =  UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .cancel) { (action) in
            print("You have pressed OK")
        }
        alertContoller.addAction(action)
        
        DispatchQueue.main.async {
            vc.present(alertContoller, animated: true, completion: nil)
        }
    }
}
