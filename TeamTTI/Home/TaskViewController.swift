//
//  TaskViewController.swift
//  TeamTTI
//
//  Created by Mohini Mehetre on 19/12/18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController, DateElementDelegate {

    @IBOutlet weak var scheduledDateBackgroundView: UIView!
    @IBOutlet weak var taskDetailPosterImageView: UIImageView!
    @IBOutlet weak var taskPriorityLabel: UILabel!
    @IBOutlet weak var taskDetailLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var scheduledDateLabel: UILabel!
    @IBOutlet weak var playBookNameLabel: UILabel!
    @IBOutlet weak var taskImageView1: UIImageView!
    @IBOutlet weak var taskImageView2: UIImageView!
    @IBOutlet weak var taskImageView3: UIImageView!
    
    public var tastDetails : StoreObjective!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUIValues()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scheduledDateBackgroundView.dropShadow(scale: true)
    }
    
    // MARK: - Private Methods
    
    func setUIValues(){
        taskPriorityLabel.text = self.tastDetails.objective?.priority.displayValue
        taskDetailLabel.text = self.tastDetails.objective?.description
        dueDateLabel.text =  DateFormatter.convertDateToMMMMddyyyy((self.tastDetails.objective?.dueDate)!)
        scheduledDateLabel.text =  DateFormatter.convertDateToMMMMddyyyy((self.tastDetails.objective?.startDate)!)
    }
    
    // MARK: - IBAction Methods
    
    @IBAction func viewPlaybookButtonTapped(_ sender: UIButton) {
        let playbookStoryboard = UIStoryboard.init(name: Constant.Storyboard.Playbook.id, bundle: nil)
        let viewPlaybookViewController = playbookStoryboard.instantiateViewController(withIdentifier: Constant.Storyboard.Playbook.playbookDetailViewController)
        self.navigationController?.pushViewController(viewPlaybookViewController, animated: true)
    }
    
    @IBAction func handleScheduleDateButtonTap(_ sender: UIButton) {
        let calender = DateElement.instanceFromNib() as! DateElement
        calender.dateDelegate = self
        calender.configure(withThemeColor: UIColor.init(named: "tti_blue"), headertextColor: UIColor.black, dueDate: (self.tastDetails.objective?.dueDate)!)
        calender.center = self.view.center
        self.view.addSubview(calender)
    }
    
    // MARK: - DateElementDelegate methods
    
    func selectedDate(_ date: Date){
        scheduledDateLabel.text = DateFormatter.formatter_MMMddyyyy.string(from: date)
    }
}
