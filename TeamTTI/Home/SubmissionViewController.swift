//
//  SubmissionViewController.swift
//  TeamTTI
//
//  Created by Mohini Mehetre on 20/12/18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import UIKit
import UITextView_Placeholder
import Moya

class SubmissionViewController: UIViewController, DateElementDelegate, PhotoPickerDelegate {
    
    //MARK: IBOutlets
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var completionTypeTextField: UITextField!
    @IBOutlet weak var completionTypesBackgroundView: UIView!
    @IBOutlet weak var reasonTextField: UITextField!
    @IBOutlet weak var reasonBackgroundView: UIView!
    @IBOutlet weak var reasonViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var scheduledDateLabel: UILabel!
    @IBOutlet weak var scheduledDateBackgroundView: UIView!
    @IBOutlet weak var taskImageView: UIImageView!
    @IBOutlet weak var commentWarningView: UIView!
    @IBOutlet weak var completionTypeDropdownArrow: UIImageView!
    @IBOutlet weak var statusStackView: UIStackView!
    @IBOutlet weak var completionTypeAndStatusPartition: UIView!
    
    //MARK: Instance variables
    private var submitObjectiveTask: Cancellable?
    public var tastDetails : StoreObjective!


    let completionTypes : [String] = ["Complete", "Schedule", "Incomplete"]
    let reasons : [String] = ["Store Refusal", "No Inventory", "Lack of Space", "Vacant Territory", "Marketting Issue"]

    var isViewLoadedForFirstTime : Bool = true

    //MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUIValues()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isViewLoadedForFirstTime {
            isViewLoadedForFirstTime = false
            setUpInitialView()
        }
    }
    
    //MARK: Private Method
    
    func submitObective() {
        
        self.showHUD(progressLabel: "")
        
        submitObjectiveTask?.cancel()
        
        var submitObject = [String: Any]()
        
        if self.completionTypeTextField.text == "Complete"
        {
            submitObject["status"] = 3 //Complete
            submitObject["completionType"] = ""
        }
        else if self.completionTypeTextField.text == "Incomplete"
        {
            submitObject["status"] = 5 //Incomplete
            submitObject["completionType"] = self.reasonTextField.text
        }
        else
        {
            submitObject["status"] = 2 //Schedule
            submitObject["completionType"] = ""
        }
        
        submitObject["comments"] = self.commentTextView.text
        submitObject["completionTypeID"] = 0 //FOR NOW COMPLETIONTYPE WILL BE 0 UNTILL API GUY COMMUNICATE
        
        submitObjectiveTask = MoyaProvider<ObjectiveApi>(plugins: [AuthPlugin()]).request(.submitObjective(storeID: self.tastDetails.storeId, objectiveID: self.tastDetails.objectiveID, submitJson: submitObject)){ result in
            
            // hiding progress hud
            self.dismissHUD(isAnimated: true)
            
            switch result {
                
            case let .success(response):
                print(response)
                
                if case 200..<400 = response.statusCode {
                    
                    if (response.statusCode == 200)
                    {
                        let alertContoller =  UIAlertController.init(title: "Success", message: "Objectives Submitted successfully.", preferredStyle: .alert)
                        
                        let action = UIAlertAction(title: "OK", style: .cancel) { (action) in
                            
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                        
                        alertContoller.addAction(action)
                        self.present(alertContoller, animated: true, completion: nil)
                    }
                }
                else
                {
                    print("Status code:\(response.statusCode)")
                    Alert.show(alertType: .wrongStatusCode(response.statusCode), onViewContoller: self)
                }
                break
            case let .failure(error):
                print(error.localizedDescription)
                break
            }

            
        }
    }
    
    // MARK: - IBAction methods
    
    @IBAction func handleUploadPhotoButtonTap(_ sender: UIButton) {
       _ = PhotoPickerController(buttonToPresentPopoverForiPad: sender, viewControllerToPresent: self, imagePickerDelegate: self as PhotoPickerDelegate)
    }
    
    @IBAction func handleScheduleDateButtonTap(_ sender: UIButton) {
        let calender = DateElement.instanceFromNib() as! DateElement
        calender.dateDelegate = self
        calender.configure(withThemeColor: UIColor.init(named: "tti_blue"), headertextColor: UIColor.black, dueDate: (self.tastDetails.objective?.dueDate)!)
        calender.center = self.view.center
        self.view.addSubview(calender)
    }
    
    
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        
        if (scheduledDateLabel.text?.count != 0)
        {
            if ((self.taskImageView.image != nil) && (self.completionTypeTextField.text?.count != 0))
            {
                if (self.tastDetails.status != StoreObjectiveStatus.overdue)
                {
                    self.submitObective()
                }
                else
                {
                    if commentTextView.text!.count == 0
                    {
                        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
                            self.commentWarningView.isHidden = false
                        })
                    }
                    else
                    {
                        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
                            self.commentWarningView.isHidden = true
                        })

                        self.submitObective()
                    }
                }
            }
            else
            {
                var errorMessage: String!
                
                if (self.completionTypeTextField.text?.count == 0)
                {
                    errorMessage = "Please select Completion Type."
                }
                else
                {
                    errorMessage = "Please upload Photo from Camera/Gallery."
                }
                
                let alertContoller =  UIAlertController.init(title: "Error", message: errorMessage, preferredStyle: .alert)

                let action = UIAlertAction(title: "OK", style: .cancel) { (action) in
                }
                
                alertContoller.addAction(action)
                self.present(alertContoller, animated: true, completion: nil)
            }
        }
        else
        {
            let alertContoller =  UIAlertController.init(title: "Error", message: "Scheduled Date is empty. Please set scheduled date first.", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .cancel) { (action) in
            }
            
            alertContoller.addAction(action)
            self.present(alertContoller, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func closeCommentWarningButtonTapped(_ sender: Any) {
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.commentWarningView.isHidden = true
        })
    }
    
    // MARK: - Picker View  methods
    
    @objc func completionTypeSelected(selectedText: String) {
        
        if selectedText == "Incomplete" {
            self.reasonViewHeightConstraint.constant = 112;
            
        }
        else {
            self.reasonViewHeightConstraint.constant = 0;
        }
    }
    
    @objc func reasonSelected(selectedText: String) {
        
    }
    
    // MARK: - Private methods
    
    func setUpInitialView() {
        let editable : Bool = true
        
        if editable{
            statusStackView.isHidden = true
            completionTypeAndStatusPartition.isHidden = true
            completionTypesBackgroundView.dropShadow(scale: true)
            reasonBackgroundView.dropShadow(scale: true)
            scheduledDateBackgroundView.dropShadow(scale: true)
            completionTypeDropdownArrow.isHidden = false
            commentTextView.placeholder = "Type your comment here"
            commentTextView.placeholderColor = UIColor.lightGray
            completionTypeTextField.isUserInteractionEnabled = true
            completionTypeTextField.loadDropdownData(data: completionTypes, selectionHandler: #selector(SubmissionViewController.completionTypeSelected(selectedText:)), pickerDelegate: self)
            reasonTextField.loadDropdownData(data: reasons, selectionHandler: #selector(SubmissionViewController.reasonSelected(selectedText:)), pickerDelegate: self)
        }
        else{
            statusStackView.isHidden = false
            completionTypeDropdownArrow.isHidden = true
            completionTypeAndStatusPartition.isHidden = true
            completionTypeTextField.isUserInteractionEnabled = false
        }

        self.reasonViewHeightConstraint.constant = 0;
    }
    
    func setUIValues(){
        
        dueDateLabel.text =  DateFormatter.convertDateToMMMMddyyyy((self.tastDetails.objective?.dueDate)!)
        
        if self.tastDetails.estimatedCompletionDate != nil {
            scheduledDateLabel.text =  DateFormatter.convertDateToMMMMddyyyy((self.tastDetails.estimatedCompletionDate)!)
        }
        else
        {
            scheduledDateLabel.text = ""
        }
    }
    
    // MARK: - DateElementDelegate methods
    
    func selectedDate(_ date: Date){
        scheduledDateLabel.text = DateFormatter.formatter_MMMddyyyy.string(from: date)
    }
    
    // MARK: - PhotoPickerDelegate methods

    func photoPicker(picker: PhotoPickerController, didSelectImage image: UIImage){
        taskImageView.image = image
    }
}

extension UITextField {
    func loadDropdownData(data: [String]) {
        self.inputView = PickerViewUtility(pickerData: data, dropdownField: self)
    }
    
    func loadDropdownData(data: [String], selectionHandler : Selector, pickerDelegate:UIViewController) {
        self.inputView = PickerViewUtility(pickerData: data, dropdownField: self, onSelect: selectionHandler, forDelegate: pickerDelegate)
    }
}
