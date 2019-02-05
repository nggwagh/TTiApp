//
//  TaskDetailViewController.swift
//  TeamTTI
//
//  Created by Mohini Mehetre on 17/12/18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController {

    @IBOutlet private weak var taskDetailsContainerView: UIView!
    @IBOutlet private weak var submissionDetailsContainerView: UIView!
    @IBOutlet private weak var taskButton: UIButton!
    @IBOutlet private weak var submissionButton: UIButton!
    
    public var tastDetails : StoreObjective!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.title = self.tastDetails.objective?.title
        setButtonBorders()
    }
    
    // MARK: - Private Methods
    func setButtonBorders() {
        if taskButton.isSelected {
            taskButton.add(border: ViewBorder.bottom, color: UIColor.init(named: Constants.tti_blue)!, width: 3)
            submissionButton.remove(border: ViewBorder.bottom)
        }
        else if submissionButton.isSelected {
            submissionButton.add(border: ViewBorder.bottom, color: UIColor.init(named: Constants.tti_blue)!, width: 3)
            taskButton.remove(border: ViewBorder.bottom)
        }
    }
    
    // MARK: - IBAction Methods
    @IBAction func handleTaskButtonTap(_ sender: UIButton) {
        sender.isSelected = true
        submissionButton.isSelected = false
        setButtonBorders()
        self.submissionDetailsContainerView.isHidden = true;
        self.taskDetailsContainerView.isHidden = false;
    }
    
    @IBAction func handleSubmissionButtonTap(_ sender: UIButton) {
        sender.isSelected = true
        taskButton.isSelected = false
        setButtonBorders()
        self.taskDetailsContainerView.isHidden = true;
        self.submissionDetailsContainerView.isHidden = false;
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Constant.Storyboard.Home.TaskSegueIdentifier {
            
            let destinationVC = segue.destination as! TaskViewController
            
            destinationVC.tastDetails = self.tastDetails
        }
        else if segue.identifier == Constant.Storyboard.Home.SubmissionSegueIdentifier {
            
            let destinationVC = segue.destination as! SubmissionViewController
            
            destinationVC.tastDetails = self.tastDetails
        }
        
    }
}
