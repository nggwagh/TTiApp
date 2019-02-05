//
//  HomeViewController.swift
//  TeamTTI
//
//  Created by Mayur Deshmukh on 11/11/18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import UIKit
import Moya
import MMDrawerController

class HomeViewController: UIViewController, DateElementDelegate {
    
    //MARK:- IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scheduleView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var scheduleButton: UIButton!
    @IBOutlet weak var scheduleButtonView: UIView!
    
    //MARK:- Instance variables
    private var storeNetworkTask: Cancellable?
    private var storeObjectiveNetworkTask: Cancellable?
    private var stores: [Store]?
    private var selectedStore: Store?
    //    private var storeObjectives: [StoreObjective]? = []
    private var isAlreadyShownSearchView = false
    private var closestStores: [Store]! = []
    
    private var totalTasks : Int = 0
    private var completedTasks : Int = 0
    
    private var storeSearchViewController = StoreSearchViewController()
    
    private var selectedStoreObjectives = [StoreObjective]()
    
    private var storeObjectivesResponse = [StoreObjective]()
    
    var allStoreObjectives = [[String:AnyObject]]()
    
    @IBOutlet weak var navigationBar: HomeNavigationBar!
    
    var refreshControl   = UIRefreshControl()
    
    //MARK:- View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationBar.delegate = self
        loadStores()
        
        // Refresh control add in tableview.
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(refreshStore), for: .valueChanged)
        self.tableView.addSubview(refreshControl)
        // scheduleButton.layer.borderColor = UIColor.white.cgColor
        
        scheduleButtonView.layer.cornerRadius = 5.0
        scheduleButtonView.layer.borderWidth = 0.5
        scheduleButtonView.layer.borderColor = UIColor.white.cgColor
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        if let isTaskValueUpdated = UserDefaults.standard.value(forKey: "TaskValueUpdated") as? Bool {
            if (isTaskValueUpdated == true){
                self.refreshStore()
                UserDefaults.standard.removeObject(forKey: "TaskValueUpdated")
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == Constant.Storyboard.Home.TaskDetailSegueIdentifier {
            
            let indexPath: IndexPath = sender as! IndexPath
            let storeObjectives = self.allStoreObjectives[indexPath.section - 1]["storeObjectives"] as! [StoreObjective]
            let selectedTask = storeObjectives[indexPath.row]
            let destinationVC = segue.destination as! TaskDetailViewController
            destinationVC.tastDetails = selectedTask
        }
    }
    
    //MARK:- Private Method
    
    @objc func refreshStore() {
        
        if self.selectedStore == nil {
            return
        }
        
        //show progress hud
        self.showHUD(progressLabel: "")
        
        // Call webservice here.
        storeObjectiveNetworkTask?.cancel()
        
        guard let storeId = self.selectedStore?.id else { return }
        
        storeObjectiveNetworkTask = MoyaProvider<StoreApi>(plugins: [AuthPlugin()]).request(.storeObjectivesFor(storeId: storeId)) { result in
            
            //hide progress hud
            self.dismissHUD(isAnimated: true)
            
            self.refreshControl.endRefreshing()
            
            switch result {
            case let .success(response):
                if case 200..<400 = response.statusCode {
                    do {
                        let jsonDict =   try JSONSerialization.jsonObject(with: response.data, options: []) as! [String: Any]
                        print(jsonDict)
                        
                        self.storeObjectivesResponse = StoreObjective.build(from: jsonDict["objectives"] as! Array)
                        
                        if (self.storeObjectivesResponse.count == 0) {
                            Alert.showMessage(onViewContoller: self, title: Bundle.main.displayName, message: "No objectives available for selected store.")
                        }
                    
                        self.buildSectionArray()
                        
                        let countDictionary = jsonDict["counts"] as? [String: Any]
                        self.totalTasks = (countDictionary?["totalObjectives"] as? Int)!
                        self.completedTasks = (countDictionary?["completed"] as? Int)!
                        
                        self.reloadTableView()
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
    
    func buildSectionArray() {
        
        self.allStoreObjectives.removeAll()
        
        let highPriorityNonCompletedObjectives = storeObjectivesResponse.filter({ ($0.objective?.priority == .high && $0.status != .complete) })
        
        for obj in highPriorityNonCompletedObjectives {
            var dict = [String : AnyObject]()
            dict["headerTitle"] = "" as AnyObject
            dict["storeObjectives"] = [obj] as AnyObject
            self.allStoreObjectives.append(dict)
        }
        
        let mediumPriorityNonCompletedObjectives = storeObjectivesResponse.filter({ ($0.objective?.priority == .medium && $0.status != .complete) })
        var mediumPriorityObjectivesDict = [String : AnyObject]()
        mediumPriorityObjectivesDict["headerTitle"] = "" as AnyObject
        mediumPriorityObjectivesDict["storeObjectives"] = mediumPriorityNonCompletedObjectives as AnyObject
        self.allStoreObjectives.append(mediumPriorityObjectivesDict)
        
        let lowPriorityNonCompletedObjectives = storeObjectivesResponse.filter({ ($0.objective?.priority == .low && $0.status != .complete) })
        var lowPriorityObjectivesDict = [String : AnyObject]()
        lowPriorityObjectivesDict["headerTitle"] = "" as AnyObject
        lowPriorityObjectivesDict["storeObjectives"] = lowPriorityNonCompletedObjectives as AnyObject
        self.allStoreObjectives.append(lowPriorityObjectivesDict)
        
        
        let completedObjectives = storeObjectivesResponse.filter({ ($0.status == .complete) })
        var completedObjectivesDict = [String : AnyObject]()
        completedObjectivesDict["headerTitle"] = "" as AnyObject
        completedObjectivesDict["storeObjectives"] = completedObjectives as AnyObject
        self.allStoreObjectives.append(completedObjectivesDict)
    }
    
    func buildSectionArrayToSchedule() {
        
        self.allStoreObjectives.removeAll()
        
        let highPriorityNonCompletedObjectives = storeObjectivesResponse.filter({ ($0.objective?.priority == .high && $0.status != .complete) })
        
        let dueDatesStringArray = highPriorityNonCompletedObjectives.compactMap { Date.convertDate(from: DateFormats.yyyyMMdd_HHmmss, to: DateFormats.MMMMddyyyy, ($0.objective?.dueDate!)!) } // return array of date
        
        let uniqueDates = Array(Set(dueDatesStringArray)).sorted(by: { $0 < $1 })
        
        uniqueDates.forEach {
            let dateKey = $0
            let filterArray = highPriorityNonCompletedObjectives.filter { ((Date.convertDate(from: DateFormats.yyyyMMdd_HHmmss, to: DateFormats.MMMMddyyyy, ($0.objective?.dueDate!)!) == dateKey)) }
            var dict = [String : AnyObject]()
            dict["headerTitle"] =  "Due: \(dateKey)" as AnyObject
            dict["storeObjectives"] = filterArray as AnyObject
            self.allStoreObjectives.append(dict)
        }
        
        let mediumPriorityNonCompletedObjectives = storeObjectivesResponse.filter({ ($0.objective?.priority == .medium && $0.status != .complete) })
        
        let lowPriorityNonCompletedObjectives = storeObjectivesResponse.filter({ ($0.objective?.priority == .low && $0.status != .complete) })
        
        let completedObjectives = storeObjectivesResponse.filter({ ($0.status == .complete) })
        
        var array = [StoreObjective]()
        array.append(contentsOf: mediumPriorityNonCompletedObjectives)
        array.append(contentsOf: lowPriorityNonCompletedObjectives)
        array.append(contentsOf: completedObjectives)
        
        var objectivesDict = [String : AnyObject]()
        objectivesDict["headerTitle"] = "Other" as AnyObject
        objectivesDict["storeObjectives"] = array as AnyObject
        self.allStoreObjectives.append(objectivesDict)
    }
    
    func loadStores() {
        
        //show progress hud
        self.showHUD(progressLabel: "")
        
        storeNetworkTask?.cancel()
        
        storeNetworkTask = MoyaProvider<StoreApi>(plugins: [AuthPlugin()]).request(.stores()) { result in
            
            //hide progress hud
            self.dismissHUD(isAnimated: true)
            
            switch result {
            case let .success(response):
                if case 200..<400 = response.statusCode {
                    do {
                        let jsonDict =   try JSONSerialization.jsonObject(with: response.data, options: []) as! [[String: Any]]
                        print(jsonDict)
                        
                        //Sort array by Closest stores first
                        self.stores = Store.build(from: jsonDict).sorted(by: { (store1 : Store, store2 : Store) -> Bool in
                            return Int(store1.distanceFromCurrentLocation!) < Int(store2.distanceFromCurrentLocation!)
                        })
                        
                        if (self.stores != nil && (self.stores?.count)! > 0) {
                            //DEFAULT STORE WILL BE THE 1ST STORE FROM USER'S STORE
                            let userStores = self.stores!.filter({ ($0.userID == Int(SettingsManager.shared().getUserID()!)) })
                            
                            if (userStores.count > 0) {
                                //MAKE FRIST MY STORE AS DEFAULT STORE
                                self.selectStore(userStores[0])
                            }
                            else {
                                //MAKE FRIST STORE AS DEFAULT STORE
                                self.selectStore(self.stores![0])
                            }
                            
                            //Enable store selection
                            self.navigationBar.enableTitleButton(true)
                            self.initializeStoreSearchController()
                            
                            //START MONITORING FOR CLOSEST STORES
                            self.startMonitoringClosestStores(allStore: self.stores!)
                        }
                        else {
                            //Disable store selection
                            self.navigationBar.enableTitleButton(false)
                            Alert.showMessage(onViewContoller: self, title: Bundle.main.displayName, message: "No stores available.")
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
    
    //FUNCTION TO START MONITORING FOR CLOSEST STORE
    func startMonitoringClosestStores(allStore: [Store]) {
        
        var storesArray : [Store] = allStore
        
        storesArray.removeAll { (store : Store) -> Bool in
            store.userID == Int(SettingsManager.shared().getUserID()!)
        }
        
        if storesArray.count >= 3 {
            for i in 0...(storesArray.count - 1) {
                if (i < 3){
                    self.closestStores.append(storesArray[i])
                }
            }
        }
        
        //start monitoring for my stores
        TTILocationManager.sharedLocationManager.monitorRegions(regionsToMonitor: self.closestStores)
    }
    
    
    func selectStore(_ store: Store) {
        
        self.selectedStore = store
        
        self.setStoreDetails()
        
        self.refreshStore()
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
    func setStoreDetails(){
        self.navigationBar.setTitle((selectedStore?.name)!)
        self.navigationBar.downArrowImageView.isHidden = false;
    }
    
    func initializeStoreSearchController() {
        let storyboard =  UIStoryboard.init(name: "Home", bundle: nil)
        storeSearchViewController = storyboard.instantiateViewController(withIdentifier: "StoreSearchViewController") as! StoreSearchViewController
        storeSearchViewController.delegate = self
        storeSearchViewController.stores = self.stores ?? [Store]()
        storeSearchViewController.buildStoreSectionsArray()
        let rect = CGRect(x: self.view.bounds.origin.x, y: self.tableView.frame.origin.y, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        storeSearchViewController.view.frame = rect
    }
    
    func saveScheduledDate(selectedDate: Date, comment: String){
        
        //Show progress hud
        self.showHUD(progressLabel: "")
        
        var postArray = [[String : Any]]()
        
        for storeObj in self.selectedStoreObjectives{
            var postParaDict = [String: Any]()
            
            postParaDict["objectiveID"] = storeObj.objectiveID
            postParaDict["storeID"] = storeObj.storeId
            postParaDict["estimatedCompletionDate"] = DateFormatter.formatter_yyyyMMdd_hhmmss.string(from: selectedDate).components(separatedBy: " ")[0]
            postParaDict["comments"] = comment
            
            postArray.append(postParaDict)
        }
        
        MoyaProvider<ObjectiveApi>(plugins: [AuthPlugin()]).request( .schedule(objectiveArray: postArray as [AnyObject])){ result in
            
            // hiding progress hud
            self.dismissHUD(isAnimated: true)
            
            switch result {
                
            case let .success(response):
                print(response)
                
                if case 200..<400 = response.statusCode {
                    
                    if (response.statusCode == 200)
                    {
                        let alertContoller =  UIAlertController.init(title: "Success", message: "Objectives scheduled successfully.", preferredStyle: .alert)
                        
                        let action = UIAlertAction(title: "OK", style: .cancel) { (action) in
                            self.navigationBar.calendarButton.isSelected = false
                            
                            self.reloadTableView()
                            
                            UIView.transition(with: self.view, duration: 0.5, options: .transitionCrossDissolve, animations: {
                                self.scheduleView.isHidden = true
                            })
                            
                            self.refreshStore()
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
    
    
    func selectedDate(_ date: Date) {
        
        //GET ALL SELECTED OBJECTIVES DUE DATES IN ARRAY
        let dueDateArray = self.selectedStoreObjectives.compactMap {
            return $0.objective?.dueDate
        }
        
        // CHECK IF SELECT DATE > DUE DATE THEN SHOW COMMENT OPTION
        
        if ((dueDateArray[0].compare(date)) == .orderedDescending) {
            
            self.saveScheduledDate(selectedDate: date, comment: "")
            
        } else {
            
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
    
    //MARK: - IBAction methods
    
    @objc func handleCheckUncheckButtonTap(sender : UIButton) {
        
        sender.isSelected = !sender.isSelected;
        
        let cell = sender.superview?.superview as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        
        let storeObjectives = self.allStoreObjectives[(indexPath?.section)! - 1]["storeObjectives"] as! [StoreObjective]
        let storeObjectiveObj = storeObjectives[(indexPath?.row)!]
        
        if sender.isSelected {
            self.selectedStoreObjectives.append(storeObjectiveObj)
        }
        else{
            self.selectedStoreObjectives = (self.selectedStoreObjectives.filter({$0.objective?.id != storeObjectiveObj.objectiveID }))
        }
        
        //VALIDATING AND CHECKING IF SELECTED OBJECTIVE HAS SAME DUE DATE OR NOT
        
        //GET ALL SELECTED OBJECTIVES DUE DATES IN ARRAY
        let dueDateArray = self.selectedStoreObjectives.compactMap {
            return $0.objective?.dueDate
        }
        
        //CHECK IF ALL HAVE SAME DUE DATE
        let allItemsWithEqualDueDate = dueDateArray.dropLast().allSatisfy { $0 == dueDateArray.last }
        
        if !allItemsWithEqualDueDate {
            
            sender.isSelected = !sender.isSelected;
            
            self.selectedStoreObjectives = (self.selectedStoreObjectives.filter({$0.objective?.id != storeObjectiveObj.objectiveID }))
            
            Alert.showMessage(onViewContoller: self, title: "Error", message: "Please only select objectives in the same due date group for scheduling.")
            
            
            
        }
    }
    
    @IBAction func handleCancelButtonTap(sender : UIButton) {
        if self.navigationBar.calendarButton.isSelected {
            
            selectedStoreObjectives.removeAll()
            
            self.navigationBar.calendarButton.isSelected = false
            
            self.buildSectionArray()
            self.reloadTableView()
            
            UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.scheduleView.isHidden = true
            })
        }
    }
    
    @IBAction func handleScheduleButtonTap(sender : UIButton) {
        
        //GET ALL SELECTED OBJECTIVES DUE DATES IN ARRAY
        let dueDateArray = self.selectedStoreObjectives.compactMap {
            return $0.objective?.dueDate
        }
        
        if dueDateArray.count > 0 {
            
            let calender = DateElement.instanceFromNib() as! DateElement
            calender.dateDelegate = self
            
            // CHECK IF SELECT DATE > DUE DATE THEN SHOW COMMENT OPTION
            if ((dueDateArray[0].compare(Date())) == .orderedAscending) {
                calender.isDueDatePassed = true
            }
            
            calender.configure(withThemeColor: UIColor.init(named: "tti_blue"), headertextColor: UIColor.black, dueDate:dueDateArray[0])
            
            self.view.addSubview(calender)
            
        } else {
            
            Alert.showMessage(onViewContoller: self, title: "Error", message: "Please select the Objectives.")
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 + self.allStoreObjectives.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (section == 0) {
            if (self.storeObjectivesResponse.count > 0) {
                return 1
            }
        }
        else {
            let count = (self.allStoreObjectives[section - 1]["storeObjectives"]?.count)
            return count!
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.section == 0) {
            let  graphTableViewCell =  tableView.dequeueReusableCell(withIdentifier: "GraphTableViewCell") as! GraphTableViewCell
            graphTableViewCell.configure(unfinished: (self.totalTasks - self.completedTasks), finished: self.completedTasks, total: self.totalTasks)
            return graphTableViewCell
        }
        else {
            let storeObjectives = self.allStoreObjectives[indexPath.section - 1]["storeObjectives"] as! [StoreObjective]
            let storeObjective = storeObjectives[indexPath.row]
            
            let storeObjectiveCell = tableView.dequeueReusableCell(withIdentifier: "StoreObjectiveTableViewCell") as! StoreObjectiveTableViewCell
            
            var isChecked : Bool
            
            if (selectedStoreObjectives.contains(where: {$0.objective?.id == storeObjective.objectiveID })){
                isChecked = true
            }
            else{
                isChecked = false
            }
            
            storeObjectiveCell.configure(with: storeObjective, isSelectionOn: self.navigationBar.calendarButton.isSelected, isChecked: isChecked)
            storeObjectiveCell.checkMarkButton.tag = indexPath.row
            storeObjectiveCell.checkMarkButton.addTarget(self, action: #selector(handleCheckUncheckButtonTap(sender:)), for: UIControlEvents.touchUpInside)
            
            return storeObjectiveCell
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if (section == 0) {
            return nil
        }
        else {
            let headerTitle = self.allStoreObjectives[section - 1]["headerTitle"] as! String
            
            if !(headerTitle.isEmpty) {
                let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 28))
                
                let label = UILabel()
                label.frame = CGRect.init(x: 20, y: 0, width: headerView.frame.width, height: headerView.frame.height)
                label.text = headerTitle
                label.font = UIFont.init(name: "Avenir", size: 12.5)
                label.textColor = UIColor.init(red: 117/255.0, green: 117/255.0, blue: 117/255.0, alpha: 1.0)
                headerView.addSubview(label)
                headerView.backgroundColor = tableView.backgroundColor;
                return headerView
            }
            else{
                return nil
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        
        if (section == 0) {
            return CGFloat.leastNormalMagnitude
        }
        else {
            let headerTitle = self.allStoreObjectives[section - 1]["headerTitle"] as! String
            
            if !(headerTitle.isEmpty) {
                return 28
            }
            else{
                return CGFloat.leastNormalMagnitude
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        self.performSegue(withIdentifier: Constant.Storyboard.Home.TaskDetailSegueIdentifier, sender: indexPath)
    }
}

//MARK:- HomeNavigationBarDelegate methods
//navigation bar actions handler
extension HomeViewController: HomeNavigationBarDelegate {
    func leftMenuClicked() {
        RootViewControllerFactory.centerContainer.toggle(MMDrawerSide.left, animated: true) { status in
            //Disable tableview interaction when side menu is open
            if RootViewControllerFactory.centerContainer.openSide == MMDrawerSide.left{
                self.tableView.isUserInteractionEnabled = false
            }
            else{
                self.tableView.isUserInteractionEnabled = true
            }
        }
    }
    
    func calendarClicked() {
        
        //remove store list if already present
        if isAlreadyShownSearchView {
            storeSearchViewController.cancelSearch()
        }
        
        //Reset store selection
        self.selectedStoreObjectives.removeAll()
        
        //open calendar
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.scheduleView.isHidden = self.navigationBar.calendarButton.isSelected
        })
        self.navigationBar.calendarButton.isSelected = !self.navigationBar.calendarButton.isSelected
        
        if (self.navigationBar.calendarButton.isSelected){
            
            self.buildSectionArrayToSchedule()
            
        }else{
            self.buildSectionArray()
        }
        
        tableView.reloadData()
    }
    
    func performSearch() {
        
        //open serach controller
        if !isAlreadyShownSearchView {
            self.handleCancelButtonTap(sender: cancelButton)
            self.view.addSubview(storeSearchViewController.view)
            isAlreadyShownSearchView.toggle()
            navigationBar.setArrowImage("UpArrow")
        }
        else{
            isAlreadyShownSearchView.toggle()
            storeSearchViewController.cancelSearch()
        }
    }
}

//MARK:- StoreSearchViewControllerDelegate methods

extension HomeViewController: StoreSearchViewControllerDelegate {
    func selected(store: Store) {
        self.selectStore(store)
    }
    
    func cancel() {
        isAlreadyShownSearchView = false
        navigationBar.setArrowImage("down_arrow")
    }
}

/*
 extension HomeViewController: DateElementDelegate {
 
 func selectedDate(_ date: Date) {
 print(date)
 
 //Show progress hud
 self.showHUD(progressLabel: "")
 
 var postArray = [[String : Any]]()
 
 for storeObj in self.selectedStoreObjectives{
 var postParaDict = [String: Any]()
 
 postParaDict["objectiveID"] = storeObj.objectiveID
 postParaDict["storeID"] = storeObj.storeId
 postParaDict["estimatedCompletionDate"] = DateFormatter.formatter_yyyyMMdd_hhmmss.string(from: date).components(separatedBy: " ")[0]
 postParaDict["comments"] = ""
 
 postArray.append(postParaDict)
 }
 
 MoyaProvider<ObjectiveApi>(plugins: [AuthPlugin()]).request( .schedule(objectiveArray: postArray as [AnyObject])){ result in
 
 // hiding progress hud
 self.dismissHUD(isAnimated: true)
 
 switch result {
 
 case let .success(response):
 print(response)
 
 if case 200..<400 = response.statusCode {
 
 if (response.statusCode == 200)
 {
 let alertContoller =  UIAlertController.init(title: "Success", message: "Objectives scheduled successfully.", preferredStyle: .alert)
 
 let action = UIAlertAction(title: "OK", style: .cancel) { (action) in
 self.navigationBar.calendarButton.isSelected = false
 
 self.reloadTableView()
 
 UIView.transition(with: self.view, duration: 0.5, options: .transitionCrossDissolve, animations: {
 self.scheduleView.isHidden = true
 })
 
 self.refreshStore()
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
 }
 */

