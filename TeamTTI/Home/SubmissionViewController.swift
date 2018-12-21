//
//  SubmissionViewController.swift
//  TeamTTI
//
//  Created by Mohini Mehetre on 20/12/18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import UIKit
import UITextView_Placeholder

class SubmissionViewController: UIViewController, DateElementDelegate {
    
    @IBOutlet weak var completionTypesBackgroundView: UIView!
    @IBOutlet weak var scheduledDateBackgroundView: UIView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var completionTypeTextField: UITextField!
    @IBOutlet weak var scheduledDateLabel: UILabel!


    let completionTypes : [String] = ["Store Refusal", "No Inventory", "Lack of Space", "Vacant Territory", "Marketting Issue"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLayoutSubviews()
        completionTypesBackgroundView.dropShadow(scale: true)
        scheduledDateBackgroundView.dropShadow(scale: true)
        commentTextView.placeholder = "Type your comment here"
        commentTextView.placeholderColor = UIColor.lightGray
        completionTypeTextField.loadDropdownData(data: completionTypes, selectionHandler: #selector(SubmissionViewController.completionTypeSelected(selectedText:)), pickerDelegate: self)
    }
    
    // MARK: - IBAction methods
    
    @IBAction func handleUploadPhotoButtonTap(_ sender: UIButton) {
    }
    
    @IBAction func handleScheduleDateButtonTap(_ sender: UIButton) {
        let calender = DateElement.instanceFromNib() as! DateElement
        calender.dateDelegate = self
        calender.configure(withThemeColor: UIColor.init(named: "tti_blue"), headertextColor: UIColor.black, dueDate: Calendar.current.date(byAdding: .day, value: 2, to: Date())
            
        )
        calender.center = self.view.center
        self.view.addSubview(calender)
    }
    
    // MARK: - Picker View  methods
    
    @objc func completionTypeSelected(selectedText: String) {
        
    }
    
    // MARK: - Private methods
    
    // MARK: - DateElementDelegate methods
    
    func selectedDate(_ date: Date){
        scheduledDateLabel.text = DateFormatter.formatter_MMMddyyyy.string(from: date)
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
