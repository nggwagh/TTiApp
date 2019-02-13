//
//  ManagerHomeViewController.swift
//  TeamTTI
//
//  Created by Mohini Mehetre on 06/02/19.
//  Copyright © 2019 TeamTTI. All rights reserved.
//

import UIKit
import Moya
import MMDrawerController

class ManagerHomeViewController: UIViewController {
    
    let reuseIdentifier = "TaskDetailCell" // also enter this string as the cell identifier in the storyboard
    
    var allRegionsArray = [Region]()
    var selectedRegionsArray = [Region]()
    var regionDetailsArray = [RegionDetail]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var regionsTableView: UITableView!
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
    
    @IBAction func leftMenuClicked() {
        RootViewControllerFactory.centerContainer.toggle(MMDrawerSide.left, animated: true) { status in
            //Disable tableview interaction when side menu is open
            if RootViewControllerFactory.centerContainer.openSide == MMDrawerSide.left{
                self.view.isUserInteractionEnabled = false
            }
            else{
                self.view.isUserInteractionEnabled = true
            }
        }
    }
    
    @IBAction func nextPageButtonClicked(_ sender: AnyObject) {
        
        guard let indexPath = collectionView.indexPathsForVisibleItems.first.flatMap({
            IndexPath(item: $0.row + 2, section: $0.section)
        }), collectionView.cellForItem(at: indexPath) != nil else {
            return
        }
        
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }
    
    //MARK:- Private Methods
    
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
                        
                        self.allRegionsArray = Region.build(from: jsonDict)
                        //                        SettingsManager.shared().setRegions(self.allRegionsArray)
                        let role = SettingsManager.shared().getUserRole()
                        
                        
                        if (role == "1") {
                            //View all for admin
                            self.selectedRegionsArray = self.allRegionsArray
                        }
                        else {
                            //View default region for manager
                            self.selectedRegionsArray = self.allRegionsArray.filter({ $0.id == SettingsManager.shared().getDefaultRegionID() })
                        }
                        
                        self.allRegionsArray.append(Region.init(id: 99, name: "View All", code: ""))
                        self.regionsTableView.reloadData()

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
                        
                        self.regionDetailsArray = RegionDetail.build(from: jsonDict)
                        if (self.regionDetailsArray.count > 0) {
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
        if (self.regionDetailsArray.count > 0 && self.selectedRegionsArray.count > 0) {
            return self.regionDetailsArray.count + 1
        }
        else { return 1 }
    }
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if (self.selectedRegionsArray.count > 0) {
            let hasViewAllOption = self.selectedRegionsArray.contains(where: { $0.id == 99 })
            if (hasViewAllOption) {
                return self.selectedRegionsArray.count - 1
            }
            else {
                return self.selectedRegionsArray.count
            }
        }
        else { return 1 }
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! TaskDetailCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        if (indexPath.section == 0) {
            if (self.selectedRegionsArray.count == 0) {
                cell.countLabel.text = ""
            }
            else {
                cell.countLabel.numberOfLines = 0
                cell.countLabel.text = self.selectedRegionsArray[indexPath.row].name
                cell.countLabel.backgroundColor = .white
                cell.countLabel.textColor = .darkText
            }
        }
        else {
            
            let count = (self.regionDetailsArray[indexPath.section - 1].count?[(self.selectedRegionsArray[indexPath.row].id?.description)!])
            cell.countLabel.text = count?.description
            
            if (count == 0) {
                cell.countLabel.textColor = .darkText
                cell.countLabel.backgroundColor = .white
            }
            else {
                cell.countLabel.textColor = .white
                cell.countLabel.backgroundColor = UIColor.init(named: "tti_blue")
            }
        }
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let count = (self.regionDetailsArray[indexPath.section - 1].count?[(self.selectedRegionsArray[indexPath.row].id?.description)!])
        
        if (count! > 0) {
            // handle tap events
            print("You selected cell count\(String(describing: count?.description))!")
        }
    }
}

extension ManagerHomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == self.tableView) {
            return self.regionDetailsArray.count + 1
        }
        else {
            return self.allRegionsArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
        
        if (tableView == self.tableView) {
            if (indexPath.row > 0) {
                tableViewCell.textLabel?.font = UIFont.init(name: "Avenir", size: 14)
                tableViewCell.textLabel?.text = self.regionDetailsArray[indexPath.row - 1].name
                tableViewCell.textLabel?.textColor = .darkText
                tableViewCell.textLabel?.numberOfLines = 0
            }
        }
        else {
            tableViewCell.textLabel?.font = UIFont.init(name: "Avenir", size: 16)
            tableViewCell.textLabel?.text = self.allRegionsArray[indexPath.row].name
            
            let isSelected = self.selectedRegionsArray.contains(where: { $0.name == self.allRegionsArray[indexPath.row].name})
            if (isSelected) {
                tableViewCell.accessoryView = UIImageView.init(image: UIImage.init(named: "objective_complete"))
                tableViewCell.textLabel?.textColor = .darkText
            }
            else {
                tableViewCell.accessoryView = nil
                tableViewCell.textLabel?.textColor = .darkGray
            }
        }
        
        return tableViewCell
    }
}

extension ManagerHomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView == self.regionsTableView) {
            let isSelected = self.selectedRegionsArray.contains(where: { $0.name == self.allRegionsArray[indexPath.row].name })
            if (isSelected) {
                let defaultRegionId = SettingsManager.shared().getDefaultRegionID()
                if (defaultRegionId == self.allRegionsArray[indexPath.row].id) {
                    Alert.showMessage(onViewContoller: self, title: Bundle.main.displayName, message: "Can not deselect this region.")
                }
                else {
                    self.selectedRegionsArray = self.selectedRegionsArray.filter({ $0.name != self.allRegionsArray[indexPath.row].name })
                    self.selectedRegionsArray = self.selectedRegionsArray.filter({ $0.id != 99 })
                }
            }
            else {
                if (self.allRegionsArray[indexPath.row].id == 99) {
                    //view all option is selected
                    self.selectedRegionsArray.removeAll()
                    self.selectedRegionsArray = self.allRegionsArray
                }
                else {
                    self.selectedRegionsArray.append(self.allRegionsArray[indexPath.row])
                }
            }
            self.regionsTableView.reloadData()
        }
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

extension ManagerHomeViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.regionsTableView.isHidden = !self.regionsTableView.isHidden;
        if (self.regionsTableView.isHidden) {
            self.collectionView.reloadData()
        }
        return false
    }
}
