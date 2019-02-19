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
    
    var allRegionsArray = [Region]()
    var selectedRegionsArray = [Region]()
    var regionDetailsArray = [RegionDetail]()

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var regionsTableView: UITableView!
    @IBOutlet weak var selectRegionBackgroundView: UIView!
    @IBOutlet weak var regionTextField: UITextField!
    @IBOutlet weak var nextPreviousRegionScrollButton: UIButton!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var tableFooterView: UIView!

    //MARK:- View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
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
        selectRegionBackgroundView.dropShadow(color: .gray, shadowOpacity: 0.5, shadowSize: 0.2)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == Constant.Storyboard.Home.RegionObjectiveDetailIdentifier {
            let indexPath: IndexPath = sender as! IndexPath
            let destinationVC = segue.destination as! RegionDetailViewController
            destinationVC.status = (self.regionDetailsArray[indexPath.section - 1].id!)
            destinationVC.regionId = (self.selectedRegionsArray[indexPath.row].id!)
            destinationVC.statusString = (self.regionDetailsArray[indexPath.section - 1].name!)
            destinationVC.regionString = (self.selectedRegionsArray[indexPath.row].name!)
            destinationVC.objectiveCount = ((self.regionDetailsArray[indexPath.section - 1].count?[(self.selectedRegionsArray[indexPath.row].id?.description)!])!)
        }
    }
    
    //MARK: - IBAction methods
    
    @IBAction func leftMenuClicked() {
        RootViewControllerFactory.centerContainer.toggle(MMDrawerSide.left, animated: true) { status in
        }
    }
    
    @IBAction func nextPageButtonClicked(_ sender: AnyObject) {
        
        let indexPaths = collectionView.indexPathsForVisibleItems.filter({ $0.section == 1 })
        var indexPath = IndexPath(row: (indexPaths.first?.row)!, section:(indexPaths.first?.section)! )

        if (self.nextPreviousRegionScrollButton.titleLabel?.text == "<--") {
            indexPath.row = (indexPath.row) - 1
            collectionView.scrollToItem(at: indexPath, at: .right, animated: true)
        }
        else if (self.nextPreviousRegionScrollButton.titleLabel?.text == "-->") {
            indexPath.row = (indexPath.row) + 1
            collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        }
    }
    
    @IBAction func submitButtonTapped(_ sender: AnyObject) {
        self.regionsTableView.isHidden = true
        self.updateRegionField()
        self.collectionView.reloadData()
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
                        self.allRegionsArray.append(Region.init(id: 99, name: "View All", code: ""))

                        //SettingsManager.shared().setRegions(self.allRegionsArray)
                        let role = SettingsManager.shared().getUserRole()
                        
                        if (role == "1") {
                            //View all for admin
                            self.selectedRegionsArray = self.allRegionsArray
                        }
                        else {
                            //View default region for manager
                            self.selectedRegionsArray = self.allRegionsArray.filter({ $0.id == SettingsManager.shared().getDefaultRegionID() })
                        }
                        
                        if (self.selectedRegionsArray.count > 0) {
                            self.updateRegionField()
                            self.regionsTableView.reloadData()
                        }
                        
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
//                            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 0.5))
                            self.tableFooterView.backgroundColor = UIColor(named: "nav_title_color")
//                            self.tableView.tableFooterView = footerView
                        }
                        else {
                            self.tableFooterView.backgroundColor = .clear

//                            self.tableView.tableFooterView = nil
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
    
    func updateRegionField() {
        let regionNames = self.selectedRegionsArray.compactMap {
            return $0.name
        }
        self.arrowImageView.image = UIImage(named: "down_arrow_blue")
        self.regionTextField.text = regionNames.joined(separator: ", ")
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
        
        let reuseIdentifier = "TaskDetailCell"
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! TaskDetailCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        if (indexPath.section == 0) {
            if (self.selectedRegionsArray.count == 0) {
                cell.countLabel.text = ""
              //  cell.lineLabel.isHidden = true
            }
            else {
                cell.countLabel.numberOfLines = 0
                cell.countLabel.text = self.selectedRegionsArray[indexPath.row].name
                cell.countLabel.backgroundColor = .white
                cell.countLabel.textColor = .darkText
                cell.setLabel(size: 70, height: 60)
             //   cell.lineLabel.isHidden = false
            }
        }
        else {
            cell.setLabel(size: 30, height: 30)
            let count = (self.regionDetailsArray[indexPath.section - 1].count?[(self.selectedRegionsArray[indexPath.row].id?.description)!])
            cell.countLabel.text = count?.description
           // cell.lineLabel.isHidden = false
            
            if (count == 0) {
                cell.countLabel.textColor = .darkText
                cell.countLabel.backgroundColor = .white
                cell.countLabel.layer.cornerRadius = 0
            }
            else {
                cell.countLabel.textColor = .white
                cell.countLabel.backgroundColor = UIColor.init(red: 86.0/255.0, green: 178.0/255.0, blue: 170.0/255.0, alpha: 1)
                cell.countLabel.layer.cornerRadius = 15
                cell.countLabel.layer.masksToBounds = true
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
            
            //PASS STATUS AND REGIONID HERE
            self.performSegue(withIdentifier: Constant.Storyboard.Home.RegionObjectiveDetailIdentifier, sender: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (self.selectedRegionsArray.count <= 3) {
            self.nextPreviousRegionScrollButton.setTitle("", for: UIControlState.normal)
        }
        else {
            if (indexPath.row == self.collectionView.numberOfItems(inSection: indexPath.section) - 1) { //it's your last cell
                //Load more data & reload your collection view
                self.nextPreviousRegionScrollButton.setTitle("<--", for: UIControlState.normal)
            }
            else if (indexPath.row == 0) {
                self.nextPreviousRegionScrollButton.setTitle("-->", for: UIControlState.normal)
            }
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
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 0.5))
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
        self.regionsTableView.isHidden = false;
        self.arrowImageView.image = UIImage(named: "up_arrow_blue")
        return false
    }
}
