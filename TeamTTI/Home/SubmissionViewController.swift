//
//  SubmissionViewController.swift
//  TeamTTI
//
//  Created by Mohini Mehetre on 20/12/18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import UIKit
import UITextView_Placeholder

class SubmissionViewController: UIViewController {
    
    @IBOutlet weak var completionTypesBackgroundView: UIView!
    @IBOutlet weak var scheduledDateBackgroundView: UIView!
    @IBOutlet weak var commentTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLayoutSubviews()
        completionTypesBackgroundView.dropShadow(scale: true)
        scheduledDateBackgroundView.dropShadow(scale: true)
        commentTextView.placeholder = "Type your comment here"
        commentTextView.placeholderColor = UIColor.lightGray
    }
    
    // MARK: - IBAction methods
    
    @IBAction func handleUploadPhotoButtonTap(_ sender: UIButton) {
    }
    
    // MARK: - Private methods

}
