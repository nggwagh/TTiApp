//
//  ResetPasswordViewController.swift
//  TeamTTI
//
//  Created by Mohini Mehetre on 09/01/19.
//  Copyright © 2019 TeamTTI. All rights reserved.
//

import UIKit
import Moya

class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        txtEmail.text = "juan@pulpandfiber.com"
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetPasswordButtonTapped(_ sender: UIButton) {
        self.performResetPassword()
    }
    
}

//MARK: Logic
extension ResetPasswordViewController {
    private func performResetPassword() {
        guard self.validate() else { return }
        
        //show progress hud
        self.showHUD(progressLabel: "")
        
        MoyaProvider<UserApi>().request(.resetPassword(email: txtEmail.text ?? "")) { result in
            
            //hide progress hud
            self.dismissHUD(isAnimated: true)
            
            switch result {
            //TODO:- make generic solution for error handling
            case let .success(response) :
                
                if case 200..<400 = response.statusCode {
                    do {
                        let responseString =  String(decoding: response.data, as: UTF8.self)
                        
                        if(responseString == "true"){
                            let alertContoller =  UIAlertController.init(title: "Reset Password", message: "A password reset message was sent to your email address. Please click the link in that message to reset your password.", preferredStyle: .alert)
                            
                            let action = UIAlertAction(title: "OK", style: .cancel) { (action) in
                                self.dismiss(animated: true, completion: nil)
                            }
                            alertContoller.addAction(action)
                            
                            DispatchQueue.main.async {
                                self.present(alertContoller, animated: true, completion: nil)
                            }
                        }
                        else{
                            Alert.showMessage(onViewContoller: self, title: "Reset Password", message: "Something is wrong. Please try again.")

                        }
                        print(responseString)
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
        return true
    }
}
