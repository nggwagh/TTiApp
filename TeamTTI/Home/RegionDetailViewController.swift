//
//  RegionDetailViewController.swift
//  TeamTTI
//
//  Created by Mohini Mehetre on 14/02/19.
//  Copyright © 2019 TeamTTI. All rights reserved.
//

import UIKit
import Moya
import AlamofireImage
import Optik

class RegionDetailViewController: UIViewController {
    
    @IBOutlet var tableView : UITableView!
    @IBOutlet var viewTitle : UILabel!
    
    public var status : Int = 0
    public var regionId : Int = 0
    public var statusString : String = ""
    public var regionString : String = ""
    public var objectiveCount : Int = 0

    var regionObjectivesArray = [RegionObjective]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tableView.estimatedRowHeight =   300
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.reloadData()
        
        self.getRegionObjectives(status: status, regionId: regionId)
        
        self.viewTitle.text = "\(regionString) - \(statusString) (\(objectiveCount))"
    }
    
    //MARK: - IBAction methods
    
    @IBAction func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Private methods
    
    @objc func viewAttachment(sender: UIButton) {
        let index = sender.tag
        let objective = self.regionObjectivesArray[index]
       
        let imageDownloader = AlamofireImageDownloader()
        
        let imageViewer = Optik.imageViewer(withURLs: objective.images, initialImageDisplayIndex: 0, imageDownloader: imageDownloader, activityIndicatorColor: UIColor.white, dismissButtonImage: nil, dismissButtonPosition: DismissButtonPosition.topLeading)
        
        self.present(imageViewer, animated: true, completion: nil)
    }
    
    func getRegionObjectives(status: Int, regionId: Int){
        
        //show progress hud
        self.showHUD(progressLabel: "")
        
        MoyaProvider<RegionsAPI>(plugins: [AuthPlugin()]).request(.getRegionObjectives(Status: status, RegionID: regionId)) { result in
            
            //hide progress hud
            self.dismissHUD(isAnimated: true)
            
            switch result {
            case let .success(response) :
                
                if case 200..<400 = response.statusCode {
                    do {
                        
                        let jsonDict =   try JSONSerialization.jsonObject(with: response.data, options: []) as! [[String: Any]]
                        
                        print(jsonDict)
                        
                        // OPEN DETAILS SCREEN AFTER RECEIVING OBJECTIVE LIST
                        self.regionObjectivesArray = RegionObjective.build(from: jsonDict)
                        
                        self.tableView.reloadData()
                    }
                    catch let error {
                        print(error.localizedDescription)
                        Alert.show(alertType: .parsingFailed, onViewContoller: self)
                    }
                } else {
                    print("unhandled status code\(response.statusCode)")
                    Alert.show(alertType: .wrongStatusCode(response.statusCode), onViewContoller: self)
                }
                
            case let .failure(error):
                print(error.localizedDescription) //MOYA error
                Alert.showMessage(onViewContoller: self, title: Bundle.main.displayName, message: error.localizedDescription)
            }
        }
    }
}

// MARK:- TableView DataSource. -

extension RegionDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.regionObjectivesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let regionDetailCell = tableView.dequeueReusableCell(withIdentifier: "RegionDetailCell") as! RegionDetailCell
        regionDetailCell.setUpRegionDetailCell(regionDetail: self.regionObjectivesArray[indexPath.row], target: self, action: #selector(viewAttachment(sender:)))
        regionDetailCell.attachmentButton.tag = indexPath.row
        
        if indexPath.row % 2 == 0 {
            regionDetailCell.setBackgoundColors(color: .white)
        }
        else {
            regionDetailCell.setBackgoundColors(color: .groupTableViewBackground)
        }
        return regionDetailCell
    }
    
}

// MARK:- TableView Delegate. -

extension RegionDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

