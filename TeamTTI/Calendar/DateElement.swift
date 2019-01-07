//
//  DateElement.swift
//  fileee
//
//  Created by Deepak Sharma on 30.03.18.
//  Copyright © 2018 fileee GmbH. All rights reserved.
//

import UIKit

protocol DateElementDelegate: class {
    func selectedDate(_ date: Date)
}

class DateElement: UIView, XibInstance, TTICalendarDelegate {
    
    //MARK:- IBOutlets
    //header view outlets
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var headerLabel: UILabel!
    //container view outlets
    @IBOutlet private weak var calenderContainerView: UIView!
    //bottom view outlets
    @IBOutlet weak var bottomView: UIStackView!
    @IBOutlet weak var OKButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var pastDueLabel: UILabel!
    
    @IBOutlet weak var pastDueHeight: NSLayoutConstraint!
    
    
    weak var dateDelegate: DateElementDelegate?
    //MARK:- variables
    var selectedDate: Date?
    public var isDueDatePassed: Bool = false
    private var calender: TTICalendar!
    
    
    func configure(withThemeColor themeColor: UIColor!, headertextColor: UIColor!, dueDate: Date!) {
        
        self.frame = UIScreen.main.bounds
        //refresh subview frame
        self.layoutIfNeeded()
        self.setNeedsLayout()
        //configure header view
        headerView.backgroundColor = themeColor
        self.updateHeaderDetails(selectedDate: selectedDate ?? Date())
        
        //configure cander view
        calender = TTICalendar.init(frame:  CGRect(x: 0, y: 0, width: self.calenderContainerView.frame.size.width, height: self.calenderContainerView.frame.size.height), withCalendarThemeColor: themeColor)
        //fix color as per design
        calender.dueDate = dueDate
        calender.weekDaysTextColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.38)
        calender.headerTextColor = UIColor.black
        //set default today date
        calender.select(selectedDate ?? Date(), scrollToDate: true)
        calender.delegate = calender
        calender.dataSource = calender
        calenderContainerView.addSubview(calender)
        calender.caldelegate = self;
        
        OKButton.layer.cornerRadius = 5; // this value vary as per your desire
        OKButton.clipsToBounds = true;
        
        calenderContainerView.dropShadow(color: .gray, opacity: 0.5, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
        
        self.setWarningMessage(isDuePassed: self.isDueDatePassed)
        
    }
    
    func updateHeaderDetails(selectedDate: Date!) {
        let headerDetails =  HeaderDetails(selectedDate: selectedDate)
    }

    func setWarningMessage(isDuePassed: Bool) {
        
        if isDuePassed {
            self.pastDueLabel.isHidden = false
            self.pastDueHeight.constant = 48
        }
        else
        {
            self.pastDueLabel.isHidden = true
            self.pastDueHeight.constant = 0
        }
    }
    
    //MARK:-IBActions
    @IBAction func ok(_ sender: Any) {
        
        selectedDate = calender.selectedDate
        dateDelegate?.selectedDate(calender.selectedDate!)

        self.removeFromSuperview()
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    //MARK:- EEECalendarDelegate
    func selectedDate(_ date: Date!) {
        self.selectedDate = date
        
        if (calender.dueDate .compare(date!) == .orderedDescending) {
            self.setWarningMessage(isDuePassed: false)
        }
        else{
            self.setWarningMessage(isDuePassed: true)
        }
        
        self.updateHeaderDetails(selectedDate: date)
    }
    
     
}


struct HeaderDetails {
    var selectedDate: Date
    let dateFormatter = DateFormatter()
    var year: String {
       self.dateFormatter.setLocalizedDateFormatFromTemplate("YYYY")
       return self.dateFormatter.string(from: self.selectedDate)
    }
    var dayMonth: String {
        self.dateFormatter.setLocalizedDateFormatFromTemplate("dd")
        return self.dateFormatter.string(from: self.selectedDate)
    }
     var month: String {
        self.dateFormatter.setLocalizedDateFormatFromTemplate("MMM")
        return self.dateFormatter.string(from: self.selectedDate)
    }
    var day: String {
        self.dateFormatter.setLocalizedDateFormatFromTemplate("EEE")
        return self.dateFormatter.string(from: self.selectedDate)
    }
}



extension UIView {
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
