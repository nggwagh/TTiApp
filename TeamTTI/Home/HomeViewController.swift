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
    
    
    //MARK: Instance variables
    private var storeNetworkTask: Cancellable?
    private var storeObjectiveNetworkTask: Cancellable?
    private var stores: [Store]?
    private var selectedStore: Store?
    private var storeObjectives: [StoreObjective]?
    private var isAlreadyShownSearchView = false
    
    @IBOutlet weak var navigationBar: HomeNavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.delegate = self
        // Do any additional setup after loading the view.
        
        loadStores()
        //        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func loadStores() {
        storeNetworkTask?.cancel()
        
        storeNetworkTask = MoyaProvider<StoreApi>(plugins: [AuthPlugin()]).request(.stores()) { result in
            
            switch result {
            case let .success(response):
                if case 200..<400 = response.statusCode {
                    do {
                        let jsonDict =   try JSONSerialization.jsonObject(with: response.data, options: []) as! [[String: Any]]
                        print(jsonDict)
                        
                        self.stores = Store.build(from: jsonDict)
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
        
        storeObjectiveNetworkTask?.cancel()
        
        guard let storeId = self.selectedStore?.id else { return }
        
        storeObjectiveNetworkTask = MoyaProvider<StoreApi>(plugins: [AuthPlugin()]).request(.storeObjectivesFor(storeId: storeId)) { result in
            switch result {
            case let .success(response):
                if case 200..<400 = response.statusCode {
                    do {
                        let jsonDict =   try JSONSerialization.jsonObject(with: response.data, options: []) as! [[String: Any]]
                        print(jsonDict)
                        
                        //TODO: Parse StoreObjectives
                        self.storeObjectives = StoreObjective.build(from: jsonDict)
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
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
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
            graphTableViewCell.configure(unfinished: NSNumber.init(value: 50), finished: 106, total: 156)
            return graphTableViewCell
        case 1:
            guard let storeObjective = self.storeObjectives?[indexPath.row] else { return UITableViewCell() }
            
            let storeObjectiveCell = tableView.dequeueReusableCell(withIdentifier: "StoreObjectiveTableViewCell") as! StoreObjectiveTableViewCell
            storeObjectiveCell.configure(with: storeObjective)
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
        self.performSegue(withIdentifier: Constant.Storyboard.Home.taskDetailIdentifier, sender: indexPath)
    }
    
//    {
//        let calender = DateElement.instanceFromNib() as! DateElement
//        calender.dateDelegate = self
//        calender.configure(withThemeColor: UIColor.init(named: "tti_blue"), headertextColor: UIColor.black, dueDate: Calendar.current.date(byAdding: .day, value: 2, to: Date())
//
//        )
//        self.view.addSubview(calender)
//    }
    
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
        //open calendar
    }
    
    func performSearch() {
        
        //open serach controller
        if !isAlreadyShownSearchView {
            let storeSearchViewController = StoreSearchViewController.loadFromStoryboard()
            storeSearchViewController.delegate = self
            storeSearchViewController.stores = self.stores ?? [Store]()
            self.addChildViewController(storeSearchViewController)
            self.tableView.addSubview(storeSearchViewController.view)
            storeSearchViewController.didMove(toParentViewController: self)
          //  isAlreadyShownSearchView.toggle()
        }
    }
}

//MARK:- StoreSearchViewControllerDelegate methods

extension HomeViewController: StoreSearchViewControllerDelegate {
    func selected(store: Store) {
        print(store.name)
    }
    
    func cancel() {
        isAlreadyShownSearchView = false
    }
}


extension HomeViewController: DateElementDelegate {
    func selectedDate(_ date: Date) {
        print(date)
    }
}


