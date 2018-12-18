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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setButtonBorders()
    }
    
    func setButtonBorders() {
        if taskButton.isSelected {
            taskButton.addBorder(side: UIViewBorderSide.Bottom, color: UIColor.init(named: "tti_blue")!, width: 3)
            submissionButton.removeBorder()
        }
        else if submissionButton.isSelected {
            submissionButton.addBorder(side: UIViewBorderSide.Bottom, color: UIColor.init(named: "tti_blue")!, width: 3)
            taskButton.removeBorder()
        }
    }
    
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
