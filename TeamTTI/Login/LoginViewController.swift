//
//  ViewController.swift
//  TeamTTI
//
//  Created by Mayur Deshmukh on 21/10/18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import UIKit
import Moya

extension Constant.Storyboard {
    struct Login {
        static let id = "Login"
    }
}

class LoginViewController: UIViewController {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
//        txtEmail.text = "juan@pulpandfiber.com"
//        txtPassword.text = "tester"
        
//        txtPassword.text = "tticanada"
//        txtEmail.text = "nick@expertel.ca" // Admin
//        txtEmail.text = "nickdm@expertel.ca" // DM
//        txtEmail.text = "nickfsr@expertel.ca" // FSR
//        txtEmail.text = "Harrison.diamond@ttigroupna.com"
//        txtEmail.text = "matthew.magee@ttigroupna.com"
        
//        txtEmail.text = "Sean@expertel.ca"
//        txtPassword.text = "tester123"

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    //MARK: Actions
    @IBAction func loginTapped(_ sender: Any) {
        self.performLogin()
    }
}

//MARK: Logic
extension LoginViewController {
    private func performLogin() {
        guard self.validate() else { return }
        
        //show progress hud
        self.showHUD(progressLabel: "")
        
        MoyaProvider<UserApi>().request(.login(email: txtEmail.text ?? "" , password: txtPassword.text ?? "")) { result in
            
            //hide progress hud
            self.dismissHUD(isAnimated: true)
            
            switch result {
            //TODO:- make generic solution for error handling
            case let .success(response) :
                
                if case 200..<400 = response.statusCode {
                    do {
                        let jsonDict =   try JSONSerialization.jsonObject(with: response.data, options: []) as! [String: Any]
                        print(jsonDict)
                        
                        if let refreshToken = jsonDict[Constant.API.Login.refreshToken] as? String {
                            SettingsManager.shared().setRefreshToken(refreshToken)
                        }
                        if let token = jsonDict[Constant.API.Login.accessToken] as? String {
                            SettingsManager.shared().setAccessToken(token)
                            self.getUserDetails()
                        }
                        
                    }
                    catch let error {
                        print(error.localizedDescription)
                        Alert.show(alertType: .parsingFailed, onViewContoller: self)
                    }
                } else {
                    print("unhandled status code\(response.statusCode)")
                    //TODO:- handle an invaild status code
                    Alert.show(alertType: .wrongStatusCode(response.statusCode), onViewContoller: self)
                    
                }
                
                
            case let .failure(error):
                print(error.localizedDescription) //MOYA error
                Alert.showMessage(onViewContoller: self, title: Bundle.main.displayName, message: error.localizedDescription)
            }
        }
    }
    
    private func getUserDetails() {
        
        //show progress hud
        self.showHUD(progressLabel: "")
        
        MoyaProvider<UserApi>(plugins: [AuthPlugin()]).request(.userDetails()) { result in
            
            //hide progress hud
            self.dismissHUD(isAnimated: true)
            
            switch result {
            //TODO:- make generic solution for error handling
            case let .success(response) :
                
                if case 200..<400 = response.statusCode {
                    do {
                        let jsonDict =   try JSONSerialization.jsonObject(with: response.data, options: []) as! [String: Any]
                        print(jsonDict)
                        
                        if let userID = jsonDict["id"] as? Int {
                            SettingsManager.shared().setUserID(userID.description)
                        }
                        if let userRole = jsonDict["role"] as? Int {
                            SettingsManager.shared().setUserRole(userRole.description)
                            RootViewControllerManager.refreshRootViewController()
                        }
                        if let regionID = jsonDict["regionID"] as? Int {
                            SettingsManager.shared().setDefaultRegionID(regionID.description)
                        }
                      //  SettingsManager.shared().setDefaultRegionID("1")
                        
                        //SEND DEVICE TOKEN TO SERVER FOR PUSH NOTIFICATIONS
                        if (UserDefaults.standard.value(forKey: "DeviceToken") != nil){
                            self.registerDeviceToken()
                        }
                        
                    }
                    catch let error {
                        print(error.localizedDescription)
                        Alert.show(alertType: .parsingFailed, onViewContoller: self)
                    }
                } else {
                    print("unhandled status code\(response.statusCode)")
                    //TODO:- handle an invaild status code
                    Alert.show(alertType: .wrongStatusCode(response.statusCode), onViewContoller: self)
                }
                
            case let .failure(error):
                print(error.localizedDescription) //MOYA error
                Alert.showMessage(onViewContoller: self, title: Bundle.main.displayName, message: error.localizedDescription)
            }
        }
    }
    
    private func registerDeviceToken() {
        
       let devicetoken = UserDefaults.standard.value(forKey: "DeviceToken")
        let deviceID = UIDevice.current.identifierForVendor?.uuidString

        //show progress hud
        self.showHUD(progressLabel: "")
        
        MoyaProvider<UserApi>(plugins: [AuthPlugin()]).request(.deviceDetails(deviceId: deviceID!, deviceToken: devicetoken as! String)) { result in
            
            //hide progress hud
            self.dismissHUD(isAnimated: true)
            
            switch result {
            //TODO:- make generic solution for error handling
            case let .success(response) :
                
                if case 200..<400 = response.statusCode {
                    do {
                        let jsonDict =   try JSONSerialization.jsonObject(with: response.data, options: []) as! [String: Any]
                        print(jsonDict)
                
                    }
                    catch let error {
                        print(error.localizedDescription)
                        Alert.show(alertType: .parsingFailed, onViewContoller: self)
                    }
                } else {
                    print("unhandled status code\(response.statusCode)")
                    //TODO:- handle an invaild status code
                    Alert.show(alertType: .wrongStatusCode(response.statusCode), onViewContoller: self)
                }
                
            case let .failure(error):
                print(error.localizedDescription) //MOYA error
                Alert.showMessage(onViewContoller: self, title: Bundle.main.displayName, message: error.localizedDescription)
            }
        }
        
    }
    
    private func validate() -> Bool {
        guard let email = txtEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines), email.isValidEmail() else {
            txtEmail.becomeFirstResponder()
            return false
        }
        guard let password = txtPassword.text, password.count > 0 else {
            txtPassword.becomeFirstResponder()
            return false
        }
        
        return true
    }
}




//MARK: UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == txtEmail {
            txtPassword.becomeFirstResponder()
        } else {
            //login
            performLogin()
        }
        
        return true
    }
}
