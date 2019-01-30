//
//  TaskViewController.swift
//  TeamTTI
//
//  Created by Mohini Mehetre on 19/12/18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import UIKit
import Moya
import AlamofireImage
import Optik

class TaskViewController: UIViewController, DateElementDelegate {
    
    //MARK:- IBOutlets
    
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
    @IBOutlet weak var calenderImageView: UIImageView!
    @IBOutlet weak var scheduleDateButton: UIButton!
    
    //MARK:- Instance Variable
    
    public var tastDetails : StoreObjective!
    var imageArray = [URL]()
    
    //MARK:- View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUIValues()
        setObjectiveImages()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scheduledDateBackgroundView.dropShadow(scale: true)
    }
    
    // MARK: - Private Methods
    
    func setObjectiveImages() {
        
        print("Images array:\(self.tastDetails.descImages)")
        
        if self.tastDetails.descImages.count > 0
        {
            taskDetailPosterImageView.af_setImage(withURL:self.tastDetails.descImages[0], placeholderImage: UIImage(named: "ImageNotFound")!)
        }
        
        
        if self.tastDetails.images.count > 0
        {
            imageArray.append(self.tastDetails.images[0])
            
            taskImageView1.af_setImage(withURL: self.tastDetails.images[0], placeholderImage: UIImage(named: "ImageNotFound")!)
            
            taskImageView1.isUserInteractionEnabled = true
        }
        
        if self.tastDetails.images.count == 2
        {
            imageArray.append(self.tastDetails.images[1])
            
            taskImageView2.af_setImage(withURL: self.tastDetails.images[1], placeholderImage: UIImage(named: "ImageNotFound")!)
            
            taskImageView2.isUserInteractionEnabled = true
            
        }
        
        if self.tastDetails.images.count == 3
        {
            imageArray.append(self.tastDetails.images[2])
            
            taskImageView3.af_setImage(withURL: self.tastDetails.images[2], placeholderImage: UIImage(named: "ImageNotFound")!)
            
            taskImageView3.isUserInteractionEnabled = true
            
        }
    }
    
    
    
    func setUIValues(){
        taskPriorityLabel.text = self.tastDetails.objective?.priority.displayValue
        taskDetailLabel.text = self.tastDetails.objective?.description
        dueDateLabel.text = Date.convertDate(from: DateFormats.yyyyMMdd_hhmmss, to: DateFormats.MMMMddyyyy, ((self.tastDetails.objective?.dueDate)!))
        
        if self.tastDetails.estimatedCompletionDate != nil {
            
            scheduledDateLabel.text = Date.convertDate(from: DateFormats.yyyyMMdd_hhmmss, to: DateFormats.MMMMddyyyy, ((self.tastDetails.estimatedCompletionDate)!))
            
            ((self.tastDetails.objective?.dueDate)!.compare(((self.tastDetails.estimatedCompletionDate)!)) == .orderedDescending) ? self.handlePassOverdue(isPass: false) : self.handlePassOverdue(isPass: true)
        }
        else
        {
            scheduledDateLabel.text = ""
            
             ((self.tastDetails.objective?.dueDate)!.compare(Date()) == .orderedDescending) ? self.handlePassOverdue(isPass: false) : self.handlePassOverdue(isPass: true)
        }
        
        // Grey out the schedule date
        if (self.tastDetails.status == StoreObjectiveStatus.complete) {
            
            self.scheduleDateButton.isUserInteractionEnabled = false
            self.scheduledDateLabel.textColor = UIColor.gray
            
        }
        
        
        //set playbook name
        if let playbookUrl = self.tastDetails.objective?.playbookUrl {
            self.playBookNameLabel.text = playbookUrl[0].lastPathComponent
        }
    }
    
    func loadFullScreenImage(at index : Int) {
        let imageDownloader = AlamofireImageDownloader()
        
        let imageViewer = Optik.imageViewer(withURLs: imageArray, initialImageDisplayIndex: index, imageDownloader: imageDownloader, activityIndicatorColor: UIColor.white, dismissButtonImage: nil, dismissButtonPosition: DismissButtonPosition.topLeading)
        
        self.present(imageViewer, animated: true, completion: nil)
    }
    
    func saveScheduledDate(selectedDate: Date, comment: String){
        
        scheduledDateLabel.text = DateFormatter.formatter_MMMMddyyyy.string(from: selectedDate)

        //Show progress hud
        self.showHUD(progressLabel: "")
        
        var postParaDict = [String: Any]()
        
        postParaDict["objectiveID"] = self.tastDetails.objectiveID
        postParaDict["storeID"] = self.tastDetails.storeId
        postParaDict["estimatedCompletionDate"] = DateFormatter.formatter_yyyyMMdd_hhmmss.string(from: selectedDate).components(separatedBy: " ")[0]
        postParaDict["comments"] = comment
        
        let postArray = [postParaDict]
        
        MoyaProvider<ObjectiveApi>(plugins: [AuthPlugin()]).request( .schedule(objectiveArray: postArray as [AnyObject])){ result in
            
            // hiding progress hud
            self.dismissHUD(isAnimated: true)
            
            switch result {
                
            case let .success(response):
                print(response)
                
                if case 200..<400 = response.statusCode {
                    
                    if (response.statusCode == 200)
                    {
                        let alertContoller =  UIAlertController.init(title: "Success", message: "Objective scheduled successfully.", preferredStyle: .alert)
                        
                        let action = UIAlertAction(title: "OK", style: .cancel) { (action) in
                            print("You have pressed OK")
                            
                            //Store the flag to indate the task value is updated
                            UserDefaults.standard.set(true, forKey: "TaskValueUpdated")
                            UserDefaults.standard.synchronize()
                            
                            self.navigationController?.popToRootViewController(animated: true)
                            
                        }
                        
                        alertContoller.addAction(action)
                        self.present(alertContoller, animated: true, completion: nil)
                        
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
                Alert.showMessage(onViewContoller: self, title: Bundle.main.displayName, message: error.localizedDescription)
                break
            }
        }
    }

    func handlePassOverdue(isPass: Bool) {
        
        if isPass {
            
            self.scheduledDateLabel.textColor = UIColor.orange
            calenderImageView.image = UIImage.init(named: "OrangeCalenderIcon")
            
        } else {
            
            self.scheduledDateLabel.textColor = UIColor.black
            calenderImageView.image = UIImage.init(named: "CalenderIcon")
            
        }
    }
    
    // MARK: - IBAction Methods
    
    @IBAction func viewPlaybookButtonTapped(_ sender: UIButton) {
        let playbookStoryboard = UIStoryboard.init(name: Constant.Storyboard.Playbook.id, bundle: nil)
        let viewPlaybookViewController = playbookStoryboard.instantiateViewController(withIdentifier: Constant.Storyboard.Playbook.playbookDetailViewController) as! PlaybookDetailViewController
        
        if let playbookUrl = self.tastDetails.objective?.playbookUrl {
            viewPlaybookViewController.playbookURL = playbookUrl[0]
        }
        
        self.navigationController?.pushViewController(viewPlaybookViewController, animated: true)
    }
    
    @IBAction func viewAllPhotosButtonTapped(_ sender: UIButton) {
        
        if self.tastDetails.images.count > 0
        {
            loadFullScreenImage(at: 0)
        }
        
    }
    
    @IBAction func handleScheduleDateButtonTap(_ sender: UIButton) {
        let calender = DateElement.instanceFromNib() as! DateElement
        calender.dateDelegate = self
        
        // CHECK IF SELECT DATE > DUE DATE THEN SHOW COMMENT OPTION
        if (((self.tastDetails.objective?.dueDate)!.compare(Date())) == .orderedAscending) {
            calender.isDueDatePassed = true
        }
        
        //Overdue: Status = 4
        if (self.tastDetails.status == StoreObjectiveStatus.overdue){

            calender.configure(withThemeColor: UIColor.orange, headertextColor: UIColor.black, dueDate: (self.tastDetails.objective?.dueDate)!)
            
        } else {
            
            calender.configure(withThemeColor: UIColor.init(named: "tti_blue"), headertextColor: UIColor.black, dueDate: (self.tastDetails.objective?.dueDate)!)
        }
        
        calender.center = self.view.center
        self.view.addSubview(calender)
    }
    
    // MARK: - Gesture recognizers
    
    @IBAction func taskDetailPosterImageViewTap(_ sender: UITapGestureRecognizer) {
        
        //  loadFullScreenImage(at: 0)
        
    }
    
    @IBAction func taskDetailImageView1Tap(_ sender: UITapGestureRecognizer) {
        loadFullScreenImage(at: 0)
    }
    
    @IBAction func taskDetailImageView2Tap(_ sender: UITapGestureRecognizer) {
        loadFullScreenImage(at: 1)
    }
    
    @IBAction func taskDetailImageView3Tap(_ sender: UITapGestureRecognizer) {
        loadFullScreenImage(at: 2)
    }
    
    
    
    // MARK: - DateElementDelegate methods
    
    func selectedDate(_ date: Date){
        
        // CHECK IF SELECT DATE > DUE DATE THEN SHOW COMMENT OPTION
        
        if ((self.tastDetails.objective?.dueDate)!.compare(date) == .orderedDescending) {
            
            self.handlePassOverdue(isPass: false)

            self.saveScheduledDate(selectedDate: date, comment: "")

        } else {
            
            self.handlePassOverdue(isPass: true)

            let alertController = UIAlertController(title: "Comment", message: "Please explain why the objective is scheduled past the due date:", preferredStyle: .alert)
            
            alertController.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "Comment..."
            }
            
            let saveAction = UIAlertAction(title: "Submit", style: .default, handler: { alert -> Void in
                
                let commentTextField = alertController.textFields![0] as UITextField
                
                if (commentTextField.text?.isEmpty)! {
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    self.saveScheduledDate(selectedDate: date, comment: commentTextField.text!)
                }
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler:nil)
            
            alertController.addAction(cancelAction)
            alertController.addAction(saveAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        }
        
    }
}
