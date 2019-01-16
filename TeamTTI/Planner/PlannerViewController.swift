//
//  PlannerViewController.swift
//  TeamTTI
//
//  Created by Mohini Mehetre on 30/12/18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import UIKit
import MMDrawerController

class PlannerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var plannerCalender: PlannerCalender!
    @IBOutlet weak var plannerCalenderBackgroundView: UIView!

    @IBOutlet weak var calenderButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var arrowImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
