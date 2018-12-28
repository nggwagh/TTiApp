//
//  SubmissionViewController.swift
//  TeamTTI
//
//  Created by Mohini Mehetre on 20/12/18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import UIKit
import UITextView_Placeholder

class SubmissionViewController: UIViewController, DateElementDelegate, PhotoPickerDelegate {
    
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

    public var tastDetails : StoreObjective!

    let completionTypes : [String] = ["Complete", "Schedule", "Incomplete"]
    let reasons : [String] = ["Store Refusal", "No Inventory", "Lack of Space", "Vacant Territory", "Marketting Issue"]

    var isViewLoadedForFirstTime : Bool = true

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
        completionTypesBackgroundView.dropShadow(scale: true)
        reasonBackgroundView.dropShadow(scale: true)
        scheduledDateBackgroundView.dropShadow(scale: true)
        commentTextView.placeholder = "Type your comment here"
        commentTextView.placeholderColor = UIColor.lightGray
        completionTypeTextField.loadDropdownData(data: completionTypes, selectionHandler: #selector(SubmissionViewController.completionTypeSelected(selectedText:)), pickerDelegate: self)
        reasonTextField.loadDropdownData(data: reasons, selectionHandler: #selector(SubmissionViewController.reasonSelected(selectedText:)), pickerDelegate: self)
        self.reasonViewHeightConstraint.constant = 0;
    }
    
    func setUIValues(){
        dueDateLabel.text =  DateFormatter.convertDateToMMMMddyyyy((self.tastDetails.objective?.dueDate)!)
        scheduledDateLabel.text =  DateFormatter.convertDateToMMMMddyyyy((self.tastDetails.objective?.startDate)!)
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
