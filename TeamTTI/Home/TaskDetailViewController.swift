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
    @IBOutlet private weak var taskButton: UIButton!
    @IBOutlet private weak var submissionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        setButtonBorders()
    }
    
    // MARK: - Private Methods
    func setButtonBorders() {
        if taskButton.isSelected {
            taskButton.add(border: ViewBorder.bottom, color: UIColor.init(named: "tti_blue")!, width: 3)
            submissionButton.remove(border: ViewBorder.bottom)
        }
        else if submissionButton.isSelected {
            submissionButton.add(border: ViewBorder.bottom, color: UIColor.init(named: "tti_blue")!, width: 3)
            taskButton.remove(border: ViewBorder.bottom)
        }
    }
    
    // MARK: - IBAction Methods
    @IBAction func handleTaskButtonTap(_ sender: UIButton) {
        sender.isSelected = true
        submissionButton.isSelected = false
        setButtonBorders()
    }
    
    @IBAction func handleSubmissionButtonTap(_ sender: UIButton) {
        sender.isSelected = true
        taskButton.isSelected = false
        setButtonBorders()
    }
}
