//
//  StoreSearchViewController.swift
//  TeamTTI
//
//  Created by Deepak Sharma on 25.11.18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import UIKit
import KeychainSwift

enum Stores : Int {
    case MyStores = 0
    case ClosestStores
    case AllStores
}


protocol StoreSearchViewControllerDelegate: class {
    func selected(store: Store)
    func cancel()
}

class StoreSearchViewController: UIViewController {
    
    var stores: [Store]! {
        didSet {
            filteredStores = stores
        }
    }
    private var filteredStores: [Store]!
    private var myStores: [Store]!
    private var closestStores: [Store]! = []
    private var allStores: [Store]! = []
    
    private lazy var searchController: UISearchController = { [unowned self] in
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.tintColor = UIColor.init(named: "tti_blue")
        searchController.searchBar.backgroundImage = UIImage.init()
        searchController.searchBar.searchTextPositionAdjustment = UIOffsetMake(10, 0)
        searchController.searchBar.setSearchFieldBackgroundImage(UIImage(named: "searchBar"), for: UIControlState.normal)

        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField,
            let iconView = textField.leftView as? UIImageView {
            
            iconView.image = iconView.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            iconView.tintColor = UIColor.init(named: "tti_blue")
        }
        
        return searchController
    }()
    
    weak var delegate: StoreSearchViewControllerDelegate?
    
    @IBOutlet private weak var searchedStoreTableView: UITableView!
    @IBOutlet private weak var searchBarContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        searchController.searchBar.frame = searchBarContainer.bounds
        searchBarContainer.addSubview(searchController.searchBar)
        buildStoreSectionsArray();
        searchedStoreTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchController.searchBar.becomeFirstResponder()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchController.searchBar.becomeFirstResponder()

    }
    
    //MARK: - Private methods

    class func loadFromStoryboard() -> StoreSearchViewController {
        
       let storyboard =  UIStoryboard.init(name: "Home", bundle: nil)
       return storyboard.instantiateViewController(withIdentifier: "StoreSearchViewController") as! StoreSearchViewController
    }
    
    @IBAction func close(_ sender: Any) {
        self.cancelSearch()
    }
    
    func cancelSearch() {
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
        searchController.isActive = false
        searchController.searchBar.removeFromSuperview()
        delegate?.cancel()
        
    }
    
    private func buildStoreSectionsArray(){
        var storesArray : [Store] = stores
        
        let keychain = KeychainSwift()
        
        myStores = storesArray.filter({$0.userID == Int(keychain.get(Constant.API.User.userID)!)})
        
        storesArray.removeAll { (store : Store) -> Bool in
            store.userID == Int(keychain.get(Constant.API.User.userID)!)
        }
        
        if storesArray.count >= 3 {
            for i in 0...(storesArray.count - 1) {
                if (i < 3){
                closestStores.append(storesArray[i])
                }
                else{
                   allStores.append(storesArray[i])
                }
            }
        }
    }

    private func getHeaderTitle(ForSection section : Int) -> String {
        
        var headerTitle : String? = ""
        
        if !(searchController.searchBar.text?.isEmpty)! {
            if (filteredStores.count > 0){
                headerTitle = "Suggestions"
            }
        }
        else{
            let storeType = Stores(rawValue: section)!
            
            switch storeType {
            case .MyStores:
                if (myStores.count > 0){
                    headerTitle = "My Stores"
                }
                
            case .ClosestStores:
                if (closestStores.count > 0){
                    headerTitle = "Closest Stores to you"
                }
                
            case .AllStores:
                if (allStores.count > 0){
                    headerTitle = "All Stores"
                }
            }
        }
        
        return headerTitle!
    }
    
}

extension StoreSearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if !(searchController.searchBar.text?.isEmpty)! {
            delegate?.selected(store: filteredStores[indexPath.row])
        }
        else{
            let storeType = Stores(rawValue: indexPath.section)!
            
            switch storeType {
            case .MyStores:
                delegate?.selected(store: myStores[indexPath.row])

            case .ClosestStores:
                delegate?.selected(store: closestStores[indexPath.row])

            case .AllStores:
                delegate?.selected(store: allStores[indexPath.row])
            }
        }
        
        cancelSearch()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerTitle : String? = getHeaderTitle(ForSection: section)

        if !(headerTitle?.isEmpty)! {
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        
        let headerTitle : String? = getHeaderTitle(ForSection: section)

        if !(headerTitle?.isEmpty)! {
            return 28
        }
        else{
            return 0
        }
    }
}

extension StoreSearchViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if !(searchController.searchBar.text?.isEmpty)! {
            return 1
        }
        else{
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if !(searchController.searchBar.text?.isEmpty)! {
            return filteredStores.count
        }
        else{
            let storeType = Stores(rawValue: section)!
            
            switch storeType {
            case .MyStores:
                return myStores.count
                
            case .ClosestStores:
                return closestStores.count
                
            case .AllStores:
                return allStores.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "StoreSearchTableViewCell", for: indexPath) as! StoreSearchTableViewCell
        
        if !(searchController.searchBar.text?.isEmpty)! {
            tableViewCell.storeNameLabel.text = filteredStores[indexPath.row].name
        }
        else{
            let storeType = Stores(rawValue: indexPath.section)!
            
            switch storeType {
            case .MyStores:
                tableViewCell.storeNameLabel.text = myStores[indexPath.row].name

            case .ClosestStores:
                tableViewCell.storeNameLabel.text = closestStores[indexPath.row].name

            case .AllStores:
                tableViewCell.storeNameLabel.text = allStores[indexPath.row].name
            }
        }
    
        return tableViewCell
    }
}

extension StoreSearchViewController: UISearchControllerDelegate {
    
    func didPresentSearchController(_ searchController: UISearchController) {
        searchController.searchBar.frame = searchBarContainer.bounds
        searchController.searchBar.showsCancelButton = false
    }
}

extension StoreSearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
           filteredStores =  stores.filter { (store) -> Bool in
                return store.name.lowercased().contains(searchText.lowercased())
            }
        
        } else {
            filteredStores = stores
        }
       searchedStoreTableView.reloadData()
    }
}

extension StoreSearchViewController: UISearchBarDelegate {
    
    
    
}


