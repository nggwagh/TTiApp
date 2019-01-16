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

    //MARK:- Instance Variable
    
    var scheduleTask: Cancellable?
    
    
    //MARK:- View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.getListOfSchedule()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        plannerCalender.initializeCalender(forViewController: self)
        dateLabel.text = Date.convertDate(from: DateFormats.yyyyMMdd_hhmmss, to: DateFormats.MMMM, Date())
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
                        
                        //Use this to show objectives
                        let completedObjectives = (Planner.build(from: jsonDict))
                        
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlannerCell", for: indexPath) as! PlannerTableViewCell
        
        // Configure the cell...
        if indexPath.row == 0{
            cell.dateBackgroundView.isHidden = false
        }
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
}

extension PlannerViewController: PlannerCalenderDelegate {
    func selectedDate(selectedDate: Date) {
        self.showCalnder(shouldShow: false)
    }
    
    
}
