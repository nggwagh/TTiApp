//
//  StoreSearchViewController.swift
//  TeamTTI
//
//  Created by Deepak Sharma on 25.11.18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import UIKit

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
        searchController.searchBar.frame = searchBarContainer.bounds
        searchBarContainer.addSubview(searchController.searchBar)
//        buildStoreSectionsArray();
        // Do any additional setup after loading the view.
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
        cancelSearch()
    }
    
    
    private func cancelSearch() {
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
        searchController.isActive = false
        searchController.searchBar.removeFromSuperview()
        delegate?.cancel()
        
    }
    
    private func buildStoreSectionsArray(){
        var storesArray : [Store] = stores
        
        myStores = storesArray.filter({$0.userID == 4})
        storesArray.removeAll { (store : Store) -> Bool in
            store.userID == 4
        }
        
        if storesArray.count >= 3 {
            for i in 1...storesArray.count {
                if (i <= 3){
                closestStores.append(storesArray[i])
                }
                else{
                   allStores.append(storesArray[i])
                }
            }
        }
    }

}

extension StoreSearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        delegate?.selected(store: filteredStores[indexPath.row])
        cancelSearch()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 60))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 20, y: 0, width: headerView.frame.width-10, height: headerView.frame.height-20)
        label.text = "All Stores"
        label.font = UIFont.init(name: "Avenir", size: 12.5)
        label.textColor = UIColor.init(red: 117/255.0, green: 117/255.0, blue: 117/255.0, alpha: 1.0)
        
        headerView.addSubview(label)
        
        return headerView
    }
}

extension StoreSearchViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredStores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "StoreSearchTableViewCell", for: indexPath) as! StoreSearchTableViewCell
        tableViewCell.storeNameLabel.text = filteredStores[indexPath.row].name
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


