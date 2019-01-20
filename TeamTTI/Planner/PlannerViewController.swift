//
//  PlannerViewController.swift
//  TeamTTI
//
//  Created by Mohini Mehetre on 30/12/18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import UIKit
import MMDrawerController
import Moya

class PlannerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK:- IBOutlets
    @IBOutlet weak var plannerCalender: PlannerCalender!
    @IBOutlet weak var plannerCalenderBackgroundView: UIView!
    
    @IBOutlet weak var calenderButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var arrowImageView: UIImageView!
    
    var plannerDetails = [[String:AnyObject]]() // Your required result
    
    //MARK:- Instance Variable
    
    var scheduleTask: Cancellable?

    
    //MARK:- View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.getListOfSchedule()
        dateLabel.text = Date.convertDate(from: DateFormats.yyyyMMdd_hhmmss, to: DateFormats.MMMM, Date())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let isTaskValueUpdated = UserDefaults.standard.value(forKey: "TaskValueUpdated") as? Bool {
            if (isTaskValueUpdated == true){
                self.getListOfSchedule()
                UserDefaults.standard.removeObject(forKey: "TaskValueUpdated")
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    //MARK: - IBAction methods
    
    @IBAction func leftMenuClicked() {
        RootViewControllerFactory.centerContainer.toggle(MMDrawerSide.left, animated: true) { status in
            //Disable tableview interaction when side menu is open
            if RootViewControllerFactory.centerContainer.openSide == MMDrawerSide.left{
                self.view.isUserInteractionEnabled = false
            }
            else{
                self.view.isUserInteractionEnabled = true
            }
        }
    }
    
    @IBAction func calenderButtonTapped(sender: UIButton) {
        self.showCalnder(shouldShow: !sender.isSelected)
    }
    
    @IBAction func plannerCalenderBackgroundViewTapped(gesture: UIGestureRecognizer) {
        self.showCalnder(shouldShow: false)
    }
    
    //MARK: - Private methods
    
    func showCalnder(shouldShow: Bool){
        UIView.transition(with: self.view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            
            self.calenderButton.isSelected = shouldShow
            
            self.plannerCalender.isHidden = !shouldShow
            self.plannerCalenderBackgroundView.isHidden = !shouldShow
            
            if (self.calenderButton.isSelected){
                self.arrowImageView.image = UIImage(named: "up_arrow_blue")
            }
            else{
                self.arrowImageView.image = UIImage(named: "down_arrow_blue")
            }
        })
    }
    
    func getListOfSchedule() {
        
        //Show progress hud
        self.showHUD(progressLabel: "")
        
        scheduleTask?.cancel()
        
        scheduleTask = MoyaProvider<PlannerAPI>(plugins: [AuthPlugin()]).request(.getScheduleList()){ result in
            
            // hiding progress hud
            self.dismissHUD(isAnimated: true)
            
            switch result {
                
            case let .success(response):
                print(response)
                
                if case 200..<400 = response.statusCode {
                    
                    do{
                        let jsonDict = try JSONSerialization.jsonObject(with: response.data, options: []) as! [[String: Any]]
                        print(jsonDict)
                        
                        // Mapping the Json to StoreObjective Class as contains same object
                        let completedObjectives = (StoreObjective.build(from: jsonDict))
                        
                        let datesFromCurrentMonth = completedObjectives.filter { Date.isInSameMonth(date: $0.estimatedCompletionDate!)}

                        let datesStringArray = datesFromCurrentMonth.compactMap { Date.convertDate(from: DateFormats.yyyyMMdd_HHmmss, to: DateFormats.yyyyMMdd, $0.estimatedCompletionDate!) } // return array of date
                        
                        let uniqueDates = Array(Set(datesStringArray)).sorted(by: { $0 < $1 })
                        
                        uniqueDates.forEach {
                            let dateKey = $0
                            let filterArray = completedObjectives.filter { ((Date.convertDate(from: DateFormats.yyyyMMdd_HHmmss, to: DateFormats.yyyyMMdd, $0.estimatedCompletionDate!) == dateKey) && ($0.status == .schedule) ) }
                            var dict = [String : AnyObject]()
                            dict["date"] = dateKey as AnyObject
                            dict["events"] = filterArray as AnyObject
                            self.plannerDetails.append(dict)
                        }
                        print(self.plannerDetails)
                        
                        self.tableView.reloadData()
                        self.plannerCalender.initializeCalender(forViewController: self, events: self.plannerDetails)
                        
                        print("schedule: \(completedObjectives)")
                        
                    }
                    catch let error {
                        print(error.localizedDescription)
                        Alert.show(alertType: .parsingFailed, onViewContoller: self)
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
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.plannerDetails.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (self.plannerDetails[section]["events"]?.count)!
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlannerCell", for: indexPath) as! PlannerTableViewCell
        
        let events = self.plannerDetails[indexPath.section]["events"] as! [StoreObjective]
        let eventDetails = events[indexPath.row]
        let dateString = (self.plannerDetails[indexPath.section]["date"])
        // Configure the cell...
        if indexPath.row == 0{
            cell.dateBackgroundView.isHidden = false
        }
        else{
            cell.dateBackgroundView.isHidden = true
        }
        
        cell.dateLabel.text = dateString?.components(separatedBy: "-")[2]
        cell.weekdayLabel.text = Date.convertDateString(inputDateFormat: DateFormats.yyyyMMdd, outputDateFormat: DateFormats.EEE, dateString as! String)
        cell.detail1Label.text = (eventDetails.storeName)! + ": " + (eventDetails.objective?.title)!
        
        cell.detail2Label.text = Date.convertDateString(inputDateFormat: DateFormats.yyyyMMdd, outputDateFormat: DateFormats.MMMddyyyy, dateString as! String)
   //   cell.detail2Label.text = dateString as? String

        
        return cell
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let events = self.plannerDetails[indexPath.section]["events"] as! [StoreObjective]
        let eventDetails = events[indexPath.row]
        
        let storyboard = UIStoryboard.init(name: "Home", bundle: nil)
        let taskDetailsVC = storyboard.instantiateViewController(withIdentifier: "TaskDetailViewController") as! TaskDetailViewController
        taskDetailsVC.tastDetails = eventDetails
        self.navigationController?.pushViewController(taskDetailsVC, animated: true)
        
    }
    
}

extension PlannerViewController: PlannerCalenderDelegate {
    func selectedDate(selectedDate: Date) {
        self.showCalnder(shouldShow: false)
        let selectedDateString = Date.convertDate(from: DateFormats.yyyyMMdd_hhmmss, to: DateFormats.yyyyMMdd, selectedDate)
        let eventDates = self.plannerDetails.compactMap { $0["date"] }
        let hasEvent = eventDates.contains(where: {$0 as! String == selectedDateString})
        if (hasEvent) {
            let index = eventDates.firstIndex(where: {$0 as! String == selectedDateString})
            self.tableView.scrollToRow(at: IndexPath.init(row: 0, section: index!), at: UITableViewScrollPosition.top, animated: true)
        }
    }
}
