//
//  SubmissionViewController.swift
//  TeamTTI
//
//  Created by Mohini Mehetre on 20/12/18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import UIKit
import UITextView_Placeholder

class SubmissionViewController: UIViewController {
    
    @IBOutlet weak var completionTypesBackgroundView: UIView!
    @IBOutlet weak var scheduledDateBackgroundView: UIView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var completionTypeTextField: UITextField!

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
    
    // MARK: - Picker View  methods
    
    @objc func completionTypeSelected(selectedText: String) {
        
    }
    
    // MARK: - Private methods

}

extension UITextField {
    func loadDropdownData(data: [String]) {
        self.inputView = PickerViewUtility(pickerData: data, dropdownField: self)
    }
    
    func loadDropdownData(data: [String], selectionHandler : Selector, pickerDelegate:UIViewController) {
        self.inputView = PickerViewUtility(pickerData: data, dropdownField: self, onSelect: selectionHandler, forDelegate: pickerDelegate)
    }
}
