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

class HomeViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scheduleView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    
    //MARK: Instance variables
    private var storeNetworkTask: Cancellable?
    private var storeObjectiveNetworkTask: Cancellable?
    private var stores: [Store]?
    private var selectedStore: Store?
    private var storeObjectives: [StoreObjective]?
    private var isAlreadyShownSearchView = false
    
    private var totalTasks : Int = 10
    private var completedTasks : Int = 0
    
    private var storeSearchViewController = StoreSearchViewController()
    
    private var selectedStoreObjectives = [StoreObjective]()
    
    @IBOutlet weak var navigationBar: HomeNavigationBar!
    
    var refreshControl   = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationBar.delegate = self
        loadStores()
        
        // Refresh control add in tableview.
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(refreshStore), for: .valueChanged)
//        let refreshControlImageView : UIImageView = UIImageView(image: UIImage(named: "objective_incomplete"))
//        self.refreshControl.insertSubview(refreshControlImageView, at: 0)
        self.tableView.addSubview(refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.refreshStore()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
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
                        
                        //TODO: Parse StoreObjectives
                        self.storeObjectives = StoreObjective.build(from: jsonDict["objectives"] as! Array)
                        
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
                    //TODO:- handle an invaild status code
                    Alert.show(alertType: .wrongStatusCode(response.statusCode), onViewContoller: self)
                    
                }
                
            case let .failure(error):
                print(error.localizedDescription) //MOYA error
            }
        }
        
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
                        
                        self.stores = Store.build(from: jsonDict).sorted(by: { (store1 : Store, store2 : Store) -> Bool in
                            return Int(store1.distanceFromCurrentLocation!) < Int(store2.distanceFromCurrentLocation!)
                        })
                        
                        if self.selectedStore == nil, let closestStore = self.stores?.closest {
                            self.selectStore(closestStore)
                        }
                    }
                    catch let error {
                        print(error.localizedDescription)
                        Alert.show(alertType: .parsingFailed, onViewContoller: self)
                    }
                } else {
                    print("unhandled status code\(response.statusCode)")
                    //TODO:- handle an invaild status code
                    Alert.show(alertType: .wrongStatusCode(response.statusCode), onViewContoller: self)
                    
                }
                
            case let .failure(error):
                print(error.localizedDescription) //MOYA error
            }
        }
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
    }
    
    //MARK: - IBAction methods
    @objc func handleCheckUncheckButtonTap(sender : UIButton) {
        sender.isSelected = !sender.isSelected;
        
        let storeObjectiveObj = (self.storeObjectives?[sender.tag])!
        
        if sender.isSelected {
            self.selectedStoreObjectives.append(storeObjectiveObj)
        }
        else{
            self.selectedStoreObjectives = (self.selectedStoreObjectives.filter({$0.objective?.id != storeObjectiveObj.id }))

        }
    }
    
    @IBAction func handleCancelButtonTap(sender : UIButton) {
        if self.navigationBar.calendarButton.isSelected {
            
            self.navigationBar.calendarButton.isSelected = false
            
            self.reloadTableView()
            
            UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.scheduleView.isHidden = true
            })
        }
    }
    
    @IBAction func handleScheduleButtonTap(sender : UIButton) {
        let calender = DateElement.instanceFromNib() as! DateElement
        calender.dateDelegate = self
        calender.configure(withThemeColor: UIColor.init(named: "tti_blue"), headertextColor: UIColor.black, dueDate: Calendar.current.date(byAdding: .day, value: 2, to: Date())
            
        )
        self.view.addSubview(calender)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == Constant.Storyboard.Home.TaskDetailSegueIdentifier {
            
            let row: Int = sender as! Int
            
            let selectedTask = self.storeObjectives?[row]
            
            let destinationVC = segue.destination as! TaskDetailViewController
            
            destinationVC.tastDetails = selectedTask
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return self.storeObjectives?.count ?? 0
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let  graphTableViewCell =  tableView.dequeueReusableCell(withIdentifier: "GraphTableViewCell") as! GraphTableViewCell
            graphTableViewCell.configure(unfinished: (self.totalTasks - self.completedTasks), finished: self.completedTasks, total: self.totalTasks)
            return graphTableViewCell
        case 1:
            guard let storeObjective = self.storeObjectives?[indexPath.row] else { return UITableViewCell() }
            
            let storeObjectiveCell = tableView.dequeueReusableCell(withIdentifier: "StoreObjectiveTableViewCell") as! StoreObjectiveTableViewCell
            storeObjectiveCell.configure(with: storeObjective, isSelectionOn: self.navigationBar.calendarButton.isSelected)
            storeObjectiveCell.checkMarkButton.tag = indexPath.row
            storeObjectiveCell.checkMarkButton.addTarget(self, action: #selector(handleCheckUncheckButtonTap(sender:)), for: UIControlEvents.touchUpInside)
            
            return storeObjectiveCell
        default:
            return UITableViewCell()
        }
    }
    
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        self.performSegue(withIdentifier: Constant.Storyboard.Home.TaskDetailSegueIdentifier, sender: indexPath.row)
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

        self.selectedStoreObjectives = (self.storeObjectives?.filter({$0.objective?.priority == Priority.high }))!
        
        //open calendar
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.scheduleView.isHidden = self.navigationBar.calendarButton.isSelected
        })
        self.navigationBar.calendarButton.isSelected = !self.navigationBar.calendarButton.isSelected
        tableView.reloadData()
    }
    
    func performSearch() {
        
        //open serach controller
        if !isAlreadyShownSearchView {
            self.handleCancelButtonTap(sender: cancelButton)
            storeSearchViewController = StoreSearchViewController.loadFromStoryboard()
            storeSearchViewController.delegate = self
            storeSearchViewController.stores = self.stores ?? [Store]()
            self.addChildViewController(storeSearchViewController)
            self.tableView.addSubview(storeSearchViewController.view)
            storeSearchViewController.didMove(toParentViewController: self)
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
                break
            }
        }
    }
}


