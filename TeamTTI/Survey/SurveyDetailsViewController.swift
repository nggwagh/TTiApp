//
//  SurveyDetailsViewController.swift
//  TeamTTI
//
//  Created by Nikhil Wagh on 5/11/19.
//  Copyright © 2019 TeamTTI. All rights reserved.
//

import UIKit

class SurveyDetailsViewController: UIViewController {

    //MARK: - IBOutlets
    
    @IBOutlet weak var surveyName: UILabel!
    
    @IBOutlet weak var surveyDate: UILabel!
    
    @IBOutlet weak var surveyDetails: UILabel!
    
    var survey: Survey?

    
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.surveyName.text = self.survey?.title
        self.surveyDate.text = self.survey?.date
        self.surveyDetails.text = self.survey?.detail
        
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == Constant.Storyboard.Survey.openSurveySegueIdentifier {
            
            let destinationVC = segue.destination as! OpenSurveyViewController
            
            destinationVC.surveyURL = URL(string: (self.survey?.surveyURL)!)
        }
    }
    

    //MARK: - Action
    @IBAction func openSurveyAction(_ sender: Any) {
        
        self.performSegue(withIdentifier: Constant.Storyboard.Survey.openSurveySegueIdentifier, sender: self)

    }
}
