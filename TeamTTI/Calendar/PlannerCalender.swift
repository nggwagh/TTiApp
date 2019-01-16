//
//  PlannerCalender.swift
//  TeamTTI
//
//  Created by Mohini Mehetre on 16/01/19.
//  Copyright © 2019 TeamTTI. All rights reserved.
//

import UIKit
import FSCalendar

protocol PlannerCalenderDelegate: class {
    func selectedDate(selectedDate: Date)
}

class PlannerCalender: FSCalendar {
    
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!

    weak var plannerDelegate : PlannerCalenderDelegate?
    
    func initializeCalender(forViewController: UIViewController) {
        
        self.plannerDelegate = (forViewController as! PlannerCalenderDelegate)
        
        self.delegate = self
        self.dataSource = self
        self.setScope(FSCalendarScope.month, animated: false)
        
        self.appearance.caseOptions = .weekdayUsesSingleUpperCase
        self.appearance.caseOptions = .headerUsesUpperCase;
        self.appearance.headerTitleFont = UIFont.systemFont(ofSize: 14)
        self.appearance.weekdayFont = UIFont.systemFont(ofSize: 13)

        //Change week day title color
//        for (index, label) in self.calendarWeekdayView.weekdayLabels.enumerated() {
//            if index == 0 || index == 6 {
//                label.textColor = UIColor.red
//            } else {
//                label.textColor = UIColor.init(named: "tti_blue")
//            }
//        }
    }
}

// MARK:- FSCalendarDelegate

extension PlannerCalender: FSCalendarDelegate {
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("change page to \(self.formatter.string(from: calendar.currentPage))")
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("calendar did select date \(self.formatter.string(from: date))")
        self.plannerDelegate?.selectedDate(selectedDate: date)
    }
}

// MARK:- FSCalendarDatasource

extension PlannerCalender: FSCalendarDataSource {
    
}

extension PlannerCalender: FSCalendarDelegateAppearance{
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.layoutIfNeeded()
    }
}






