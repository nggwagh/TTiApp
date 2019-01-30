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
    private var myStores: [Store]! = []
    private var closestStores: [Store]! = []
    private var allStores: [Store]! = []
    
    weak var delegate: StoreSearchViewControllerDelegate?
    
    @IBOutlet private weak var searchedStoreTableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // Glass Icon Customization
        if let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField,
            let glassIconView = textFieldInsideSearchBar.leftView as? UIImageView {
            
            //Magnifying glass
            glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
            glassIconView.tintColor = UIColor.init(named: "tti_blue")
        }
    }
    
    //MARK: - Private methods
    
    @IBAction func close(_ sender: Any) {
        self.cancelSearch()
    }
    
    func cancelSearch() {
        self.view.removeFromSuperview()
        delegate?.cancel()
    }
    
    func buildStoreSectionsArray(){
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
            }
        }
    }

    private func getHeaderTitle(ForSection section : Int) -> String {
        
        var headerTitle : String? = ""
        
        if !(self.searchBar.text?.isEmpty)! {
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
//                    headerTitle = "All Stores"
                }
            }
        }
        
        return headerTitle!
    }
    
}

extension StoreSearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if !(self.searchBar.text?.isEmpty)! {
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
        
        if !(self.searchBar.text?.isEmpty)! {
            return 1
        }
        else{
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if !(self.searchBar.text?.isEmpty)! {
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
        
        if !(self.searchBar.text?.isEmpty)! {
            tableViewCell.storeNameLabel.text = filteredStores[indexPath.row].name
        }
        else{
            let storeType = Stores(rawValue: indexPath.section)!
            
            switch storeType {
            case .MyStores:
                tableViewCell.storeNameLabel.text = myStores[indexPath.row].name
                tableViewCell.distanceLabel.text = String(format: "(%d/%d)",myStores[indexPath.row].completed!,myStores[indexPath.row].totalObjectives!)


            case .ClosestStores:
                tableViewCell.storeNameLabel.text = closestStores[indexPath.row].name
                tableViewCell.distanceLabel.text = String(format: "%.2f km away",closestStores[indexPath.row].distanceFromCurrentLocation!)
            case .AllStores:
                tableViewCell.storeNameLabel.text = allStores[indexPath.row].name
                tableViewCell.distanceLabel.text = String(format: "%.2f km away",allStores[indexPath.row].distanceFromCurrentLocation!)

            }
        }
    
        return tableViewCell
    }
}

extension StoreSearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchBar.text, !searchText.isEmpty {
            filteredStores =  stores.filter { (store) -> Bool in
                return (store.name.lowercased().contains(searchText.lowercased()) || String(describing: store.storeNumber).lowercased().contains(searchText.lowercased()))
            }
        } else {
            filteredStores = stores
        }
        searchedStoreTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}


