//
//  ViewController.swift
//  TeamTTI
//
//  Created by Mayur Deshmukh on 21/10/18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import UIKit
import Moya
import KeychainSwift

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
        txtEmail.text = "juan@pulpandfiber.com"
        txtPassword.text = "tester"
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
                        let keychain = KeychainSwift()
                        if let refreshToken = jsonDict[Constant.API.Login.refreshToken] as? String {
                            keychain.set( refreshToken , forKey: Constant.API.Login.refreshToken )
                        }
                        if let token = jsonDict[Constant.API.Login.accessToken] as? String {
                            keychain.set( token , forKey: Constant.API.Login.accessToken )
                            ObjectiveDataProvider.shared.loadData(completion: { (_) in
                                RootViewControllerManager.refreshRootViewController()
                            })
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
