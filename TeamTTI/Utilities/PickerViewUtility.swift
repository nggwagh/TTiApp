//
//  PickerViewUtility.swift
//  TeamTTI
//
//  Created by Mohini Mehetre on 21/12/18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import CoreFoundation

class PickerViewUtility: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var pickerData : [String]!
    var pickerTextField : UITextField!
    var selectionHandler : Selector!
    var pickerDelegate : UIViewController!
    
    init(pickerData: [String], dropdownField: UITextField, initialText : String) {
        super.init(frame: CGRect.zero)
        
        self.pickerData = pickerData
        self.pickerTextField = dropdownField
        
        self.delegate = self
        self.dataSource = self
        
        DispatchQueue.main.async{
            self.pickerTextField.text = initialText
            self.pickerTextField.isUserInteractionEnabled = true
        }
    }
    
    convenience init(pickerData: [String], dropdownField: UITextField, onSelect selectionHandler : Selector, forDelegate delegate : UIViewController, initialText : String) {
        self.init(pickerData: pickerData, dropdownField: dropdownField, initialText: initialText)
        self.selectionHandler = selectionHandler
        self.pickerDelegate = delegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Sets number of columns in picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int  {
    return 1
    }
    
    // Sets the number of rows in the picker view
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int  {
    return pickerData.count
    }
    
    // This function sets the text of the picker view to the content of the "salutations" array
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    // When user selects an option, this function will set the text of the text field to reflect
    // the selected option.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerTextField.text = pickerData[row]
        
        if self.pickerTextField.text != nil && (self.selectionHandler != nil) {
           pickerDelegate.perform(self.selectionHandler, with: pickerData[row])
        }
    }
}

