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
    
    var events : [[String : AnyObject]] = []
    
    func initializeCalender(forViewController: UIViewController, events: [[String : AnyObject]]) {
        
        self.plannerDelegate = (forViewController as! PlannerCalenderDelegate)
        self.events = events
        
        self.delegate = self
        self.dataSource = self
        self.setScope(FSCalendarScope.month, animated: false)
        
        self.appearance.caseOptions = .weekdayUsesSingleUpperCase
        self.appearance.caseOptions = .headerUsesUpperCase;
        self.appearance.headerTitleFont = UIFont.systemFont(ofSize: 14)
        self.appearance.weekdayFont = UIFont.systemFont(ofSize: 13)
        
        self.reloadData()
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
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {

        let calenderDateString = Date.convertDate(from: DateFormats.yyyyMMdd_hhmmss, to: DateFormats.yyyyMMdd, date)
        let eventDates = self.events.compactMap { $0["date"] }
        let hasEvent = eventDates.contains(where: {$0 as! String == calenderDateString})

        if (hasEvent) {
            let datePredicate = NSPredicate(format: "date like %@", "\(calenderDateString)")
            let currentEvents = self.events.filter { datePredicate.evaluate(with: $0) }
            return currentEvents[0]["events"]!.count
        }

        return 0
    }
}

extension PlannerCalender: FSCalendarDelegateAppearance{
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.layoutIfNeeded()
    }
}






