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
    
    //MARK:- IBOutlets
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
    @IBOutlet weak var submitOrEditButton: UIButton!
    @IBOutlet weak var scheduleDateButton: UIButton!
    @IBOutlet weak var commentInfoLabel: UILabel!
    @IBOutlet weak var calenderImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var uploadPhoto: UIButton!

    
    //MARK:- Instance variables
    private var submitObjectiveTask: Cancellable?
    private var deletePhotoTask: Cancellable?

    public var tastDetails : StoreObjective!
    private var isViewEditable: Bool? = true
    private var isImageSet: Bool? = false
    private var isImageDeleted: Bool? = false

    let completionTypes : [String] = ["Complete", "Incomplete"]
    let reasons : [String] = ["Store Refusal", "No Inventory", "Lack of Space", "Vacant Territory", "Marketting Issue"]
    
    var isViewLoadedForFirstTime : Bool = true
    
    //MARK:- View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (self.tastDetails.images.count > 0) {
            
            taskImageView.af_setImage(withURL:self.tastDetails.images[0], placeholderImage: UIImage(named: "ImageNotFound")!)
        }
        
        
        
        // Do any additional setup after loading the view.
        setUIValues()
        
        //Overdue: Status = 4
        if (self.tastDetails.status == StoreObjectiveStatus.overdue){
            self.commentInfoLabel.isHidden = false
            self.scheduledDateLabel.textColor = UIColor.orange
            calenderImageView.image = UIImage.init(named: "OrangeCalenderIcon")
            
        }
        else{
            self.commentInfoLabel.isHidden = true
            self.scheduledDateLabel.textColor = UIColor.black
            calenderImageView.image = UIImage.init(named: "CalenderIcon")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isViewLoadedForFirstTime {
            isViewLoadedForFirstTime = false
            
            if (tastDetails.status == .complete || tastDetails.status == .incomplete) {
                submitOrEditButton.setTitle("Edit", for: UIControlState.normal)
                isViewEditable = false
            }
            setUpInitialView()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if (isViewEditable! && !isViewLoadedForFirstTime) {
            completionTypesBackgroundView.dropShadow(scale: true)
        }
    }
    
    //MARK:- Private Methods
    
    func submitObective() {
        
        self.showHUD(progressLabel: "")
        
        submitObjectiveTask?.cancel()
        
        var submitObject = [String: Any]()
        
        if self.completionTypeTextField.text == "Complete"
        {
            submitObject["status"] = 3 //Complete
            submitObject["completionType"] = ""
        }
        else
        {
            submitObject["status"] = 5 //Incomplete
            submitObject["completionType"] = self.reasonTextField.text
        }
        
        
        submitObject["comments"] = self.commentTextView.text
        submitObject["completionTypeID"] = 0 //FOR NOW COMPLETIONTYPE WILL BE 0 UNTILL API GUY COMMUNICATE
        
        /*
        //IF ESTIMATED DATE IS EMPTY SEND AS TODAYS DATE ELSE SEND SET DATE
        if scheduledDateLabel.text?.count == 0 {
            
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let todaysDate = formatter.string(from: date)
            
            print("Date:\(todaysDate)")
            
            submitObject["estimatedCompletionDate"] = todaysDate
        }
        else
        {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM dd, yyyy"
            let estimateDate = formatter.date(from: self.scheduledDateLabel.text!)
            formatter.dateFormat = "yyyy-MM-dd"
            let finalDate = formatter.string(from: estimateDate!)
            submitObject["estimatedCompletionDate"] = finalDate
        }
        */
        
        submitObjectiveTask = MoyaProvider<ObjectiveApi>(plugins: [AuthPlugin()]).request(.submitObjective(storeID: self.tastDetails.storeId, objectiveID: self.tastDetails.objectiveID, submitJson: submitObject)){ result in
            
            // hiding progress hud
            self.dismissHUD(isAnimated: true)
            
            switch result {
                
            case let .success(response):
                print(response)
                
                if case 200..<400 = response.statusCode {
                    
                    if (response.statusCode == 200)
                    {
                        let alertContoller =  UIAlertController.init(title: "Success", message: "Objective Submitted successfully.", preferredStyle: .alert)
                        
                        let action = UIAlertAction(title: "OK", style: .cancel) { (action) in
                            
                            //Store the flag to indate the task value is updated
                            UserDefaults.standard.set(true, forKey: "TaskValueUpdated")
                            UserDefaults.standard.synchronize()
                            
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
                Alert.showMessage(onViewContoller: self, title: Bundle.main.displayName, message: error.localizedDescription)
                break
            }
            
            
        }
    }
    
    func uploadImage(image : UIImage){
        self.showHUD(progressLabel: "")
        
        submitObjectiveTask?.cancel()
        
        submitObjectiveTask = MoyaProvider<ObjectiveApi>(plugins: [AuthPlugin()]).request(.uploadStoreObjectiveImage(image: image, storeID: self.tastDetails.storeId, objectiveID: self.tastDetails.objectiveID)){ result in
            
            // hiding progress hud
            self.dismissHUD(isAnimated: true)
            
            switch result {
                
            case let .success(response):
                print(response)
                
                if case 200..<400 = response.statusCode {
                    
                    if (response.statusCode == 200)
                    {
                        self.submitObective()
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
                Alert.showMessage(onViewContoller: self, title: Bundle.main.displayName, message: error.localizedDescription)
                break
            }
            
        }
    }
    
    // MARK: - IBAction methods
    
    @IBAction func handleUploadPhotoButtonTap(_ sender: UIButton) {
        
        if ((tastDetails.status == .complete || tastDetails.status == .incomplete) && (self.tastDetails.images.count > 0) && !self.isImageDeleted!) {
            
            let alertContoller =  UIAlertController.init(title: "Alert", message: "Would you like to delete this uploaded photo?", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "Delete", style: .default) { (action) in
                
                self.showHUD(progressLabel: "")
                
                self.deletePhotoTask?.cancel()
                
                self.deletePhotoTask = MoyaProvider<ObjectiveApi>(plugins: [AuthPlugin()]).request(.deletePhoto(photoID: String(format: "%d", self.tastDetails.imageIds[0]))){ result in
                    
                    // hiding progress hud
                    self.dismissHUD(isAnimated: true)
                    
                    switch result {
                        
                    case let .success(response):
                        print(response)
                        
                        if case 200..<400 = response.statusCode {
                            
                            if (response.statusCode == 200)
                            {
                             self.isImageDeleted = true
                             self.taskImageView.image = UIImage.init(named: "UploadImage")
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
                        Alert.showMessage(onViewContoller: self, title: Bundle.main.displayName, message: error.localizedDescription)
                        break
                    }
                }
            }

            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            }
            
            alertContoller.addAction(ok)
            alertContoller.addAction(cancel)

            self.present(alertContoller, animated: true, completion: nil)
            
        }
        else {
            _ = PhotoPickerController(buttonToPresentPopoverForiPad: sender, viewControllerToPresent: self, imagePickerDelegate: self as PhotoPickerDelegate)
        }
    }
    
    @IBAction func handleScheduleDateButtonTap(_ sender: UIButton) {
        let calender = DateElement.instanceFromNib() as! DateElement
        calender.dateDelegate = self
        
        //Overdue: Status = 4
        if (self.tastDetails.status == StoreObjectiveStatus.overdue){
            
            calender.isDueDatePassed = true
            
            calender.configure(withThemeColor: UIColor.orange, headertextColor: UIColor.black, dueDate: (self.tastDetails.objective?.dueDate)!)
        }
        else{
            
            calender.isDueDatePassed = false
            
            calender.configure(withThemeColor: UIColor.init(named: "tti_blue"), headertextColor: UIColor.black, dueDate: (self.tastDetails.objective?.dueDate)!)
        }
        
        calender.center = self.view.center
        self.view.addSubview(calender)
    }
    
    
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        
        if submitOrEditButton.title(for: UIControlState.normal) == "Edit" {
            isViewEditable = true
            setUpInitialView()
            submitOrEditButton.setTitle("Submit", for: UIControlState.normal)
            return
        }
        
        if (completionTypeTextField.text == "Incomplete"){
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
                    self.submitObective()
                })
            }
        }
        else{
            if (!isImageSet!){
                let alertContoller =  UIAlertController.init(title: "Error", message: "Please upload Photo from Camera/Gallery.", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "OK", style: .cancel) { (action) in
                }
                
                alertContoller.addAction(action)
                self.present(alertContoller, animated: true, completion: nil)
            }
            else{
                uploadImage(image: taskImageView.image!)
            }
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
        
        if  isViewEditable! {
            statusStackView.isHidden = true
            completionTypeAndStatusPartition.isHidden = true
            reasonBackgroundView.dropShadow(scale: true)
            scheduledDateBackgroundView.dropShadow(scale: true)
            completionTypeDropdownArrow.isHidden = false
            commentTextView.isUserInteractionEnabled = true
            commentTextView.placeholder = "Type your comment here"
            commentTextView.placeholderColor = UIColor.lightGray
            completionTypeTextField.isUserInteractionEnabled = true
            
            var status = ""
            if self.tastDetails.status == StoreObjectiveStatus.complete {
                status = "Complete"
            }
            else if self.tastDetails.status == StoreObjectiveStatus.incomplete{
                status = "Incomplete"
            }
            
            completionTypeTextField.loadDropdownData(data: completionTypes, selectionHandler: #selector(SubmissionViewController.completionTypeSelected(selectedText:)), pickerDelegate: self, initialText: status)
            self.completionTypeSelected(selectedText: status)
            
            reasonTextField.loadDropdownData(data: reasons, selectionHandler: #selector(SubmissionViewController.reasonSelected(selectedText:)), pickerDelegate: self, initialText: "")
            scheduleDateButton.isUserInteractionEnabled = true
            uploadPhoto.isUserInteractionEnabled = true
        }
        else
        {
            statusStackView.isHidden = false
            completionTypeDropdownArrow.isHidden = true
            completionTypeAndStatusPartition.isHidden = false
            completionTypeTextField.isUserInteractionEnabled = false
            commentTextView.isUserInteractionEnabled = false
            completionTypesBackgroundView.removeShadow()
            commentTextView.text = tastDetails.comments
            scheduleDateButton.isUserInteractionEnabled = false
            uploadPhoto.isUserInteractionEnabled = false

            switch self.tastDetails.status {
                
            case .open:
                self.statusLabel?.text = "Open"
            case .schedule:
                self.statusLabel?.text = "Schedule"
            case .complete:
                self.statusLabel?.text = "Complete"
            case .overdue:
                self.statusLabel?.text = "Overdue"
            case .incomplete:
                self.statusLabel?.text = "Incomplete"
            }
            
            
            if self.tastDetails.status == StoreObjectiveStatus.complete {
                
                completionTypeTextField.text = "Complete"
            }
            else {
                
                completionTypeTextField.text = "Incomplete"
            }
            self.reasonViewHeightConstraint.constant = 0;
        }
        
    }
    
    func setUIValues(){
        
        dueDateLabel.text = Date.convertDate(from: DateFormats.yyyyMMdd_hhmmss, to: DateFormats.MMMMddyyyy, ((self.tastDetails.objective?.dueDate)!))
        
        /*
        if self.tastDetails.estimatedCompletionDate != nil {
            
            scheduledDateLabel.text =  Date.convertDate(from: DateFormats.yyyyMMdd_hhmmss, to: DateFormats.MMMMddyyyy, ((self.tastDetails.estimatedCompletionDate)!))
        }
        else
        {
            scheduledDateLabel.text = ""
        }
       */
    }
    
    // MARK: - DateElementDelegate methods
    
    func selectedDate(_ date: Date){
        scheduledDateLabel.text = DateFormatter.formatter_MMMMddyyyy.string(from: date)
    }
    
    // MARK: - PhotoPickerDelegate methods
    
    func photoPicker(picker: PhotoPickerController, didSelectImage image: UIImage){
        
        isImageSet = true
        
        taskImageView.image = image
    }
}

extension UITextField {

    func loadDropdownData(data: [String], selectionHandler : Selector, pickerDelegate:UIViewController, initialText: String) {
        self.inputView = PickerViewUtility(pickerData: data, dropdownField: self, onSelect: selectionHandler, forDelegate: pickerDelegate, initialText: initialText)
    }
}
