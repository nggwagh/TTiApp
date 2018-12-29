//
//  TaskViewController.swift
//  TeamTTI
//
//  Created by Mohini Mehetre on 19/12/18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import UIKit
import Moya

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
        
        //Show progress hud
        self.showHUD(progressLabel: "")
        
        var postParaDict = [String: Any]()
        
        postParaDict["objectiveID"] = self.tastDetails.objectiveID
        postParaDict["storeID"] = self.tastDetails.storeId
        postParaDict["estimatedCompletionDate"] = DateFormatter.formatter_yyyyMMdd_hhmmss.string(from: date).components(separatedBy: " ")[0]
        postParaDict["comments"] = ""
        
        let postArray = [postParaDict]
        
        MoyaProvider<ObjectiveApi>(plugins: [AuthPlugin()]).request( .schedule(objectiveArray: postArray as [AnyObject])){ result in
            
            // hiding progress hud
            self.dismissHUD(isAnimated: true)
            
            switch result {
                
            case let .success(response):
                print(response)
                
                if case 200..<400 = response.statusCode {
                    
                    do{
                        let jsonDict = try JSONSerialization.jsonObject(with: response.data, options: []) as! [[String: Any]]
                        print(jsonDict)
                        
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
}
