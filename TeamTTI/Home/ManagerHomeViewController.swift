//
//  ManagerHomeViewController.swift
//  TeamTTI
//
//  Created by Mohini Mehetre on 06/02/19.
//  Copyright © 2019 TeamTTI. All rights reserved.
//

import UIKit
import Moya

class ManagerHomeViewController: UIViewController {
    
    let reuseIdentifier = "TaskDetailCell" // also enter this string as the cell identifier in the storyboard
    
    var regionsArray = [Region]()
    var allRegionsArray = [RegionDetail]()
    var selectedRegionArray = [RegionDetail]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectRegionBackgroundView: UIView!
    @IBOutlet weak var regionTextField: UITextField!
    
    //MARK:- View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        self.getRegionsList()
        
        /*
        //LOAD REGIONS API ONCE
        if (UserDefaults.standard.bool(forKey: "isRegionsCalled")){
            self.getRegionsDetail()
        } else{
            self.getRegionsList()
        }
        */
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        selectRegionBackgroundView.dropShadow(scale: true)
    }
    
    //MARK: - IBAction methods
    
    @IBAction func nextPageButtonClicked(_ sender: AnyObject) {
        
        guard let indexPath = collectionView.indexPathsForVisibleItems.first.flatMap({
            IndexPath(item: $0.row + 2, section: $0.section)
        }), collectionView.cellForItem(at: indexPath) != nil else {
            return
        }
        
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }
    
    //MARK:- Private Methods
    
    //PASS THIS FUNCTION REGION ARRAY (SELECTED FROM DROPDOWN) AND ACCORDINGLY SHOW REGION WISE DATA
    func prepareDataForRegions(RegionSelected: [String]){
        
        //USE THIS ARRAY TO SHOW OBJECTIVE STATUS AFTER INSERTING "" AT 0TH INDEX
        let taskArray = self.allRegionsArray.compactMap({ return $0.name })
        
        //TODO: Filter out details array based on selected regions
        
    }
    
    func getRegionsList(){
        
        //show progress hud
        self.showHUD(progressLabel: "")
        
        MoyaProvider<RegionsAPI>(plugins: [AuthPlugin()]).request(.getRegions()) { result in
            
            //hide progress hud
            self.dismissHUD(isAnimated: true)
            
            switch result {
            case let .success(response) :
                
                if case 200..<400 = response.statusCode {
                    do {
                        
                        let jsonDict =   try JSONSerialization.jsonObject(with: response.data, options: []) as! [[String: Any]]
                        
                        print(jsonDict)
                        
                        self.regionsArray = Region.build(from: jsonDict)
                        //                        SettingsManager.shared().setRegions(self.regionsArray)
                        
                        UserDefaults.standard.set(true, forKey: "isRegionsCalled")
                        UserDefaults.standard.synchronize()
                        
                        self.getRegionsDetail()
                        
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
    
    func getRegionsDetail(){
        
        //show progress hud
        self.showHUD(progressLabel: "")
        
        MoyaProvider<RegionsAPI>(plugins: [AuthPlugin()]).request(.getRegionsDetail()) { result in
            
            //hide progress hud
            self.dismissHUD(isAnimated: true)
            
            switch result {
            case let .success(response) :
                
                if case 200..<400 = response.statusCode {
                    do {
                        
                        let jsonDict =   try JSONSerialization.jsonObject(with: response.data, options: []) as! [[String: Any]]
                        
                        print(jsonDict)
                        
                        self.allRegionsArray = RegionDetail.build(from: jsonDict)
                        self.prepareDataForRegions(RegionSelected: [""])
                        if (self.allRegionsArray.count > 0) {
                            self.collectionView.reloadData()
                            self.tableView.reloadData()
                        }
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


extension ManagerHomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if self.allRegionsArray.count > 0 {
            return self.allRegionsArray.count + 1
        }
        else { return 1 }
    }
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return regionsArray.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! TaskDetailCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        if (indexPath.section == 0) {
            cell.countLabel.numberOfLines = 0
            cell.countLabel.text = self.regionsArray[indexPath.row].name
        }
        else {
            cell.countLabel.text = (self.allRegionsArray[indexPath.section - 1].count?["\(indexPath.row + 1)"])?.description
        }
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath)!")
    }
}

extension ManagerHomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allRegionsArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
        
        if (indexPath.row > 0) {
            tableViewCell.textLabel?.text = self.allRegionsArray[indexPath.row - 1].name
            tableViewCell.textLabel?.numberOfLines = 0
            tableViewCell.textLabel?.font = UIFont.init(name: "Avenir", size: 14)
            tableViewCell.textLabel?.textColor = .darkText
        }
        return tableViewCell
    }
}


extension ManagerHomeViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView == self.tableView) {
            self.collectionView.contentOffset.y = self.tableView.contentOffset.y
        }
        else if (scrollView == self.collectionView) {
            self.tableView.contentOffset.y = self.collectionView.contentOffset.y
        }
    }
}
