//
//  ManagerHomeViewController.swift
//  TeamTTI
//
//  Created by Mohini Mehetre on 06/02/19.
//  Copyright © 2019 TeamTTI. All rights reserved.
//

import UIKit

class ManagerHomeViewController: UIViewController {
    
    let reuseIdentifier = "TaskDetailCell" // also enter this string as the cell identifier in the storyboard
    var items = ["36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48"]
    
    let taskStatusArray = ["", "In Progress", "Not Scheduled", "Incomplete with Comment", "Scheduled Past Deadline", "Pending Approval", "Past Due", "Completed"]
    
    let regionsArray = ["West", "Central East", "Central West", "Central North", "Central South"]
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectRegionBackgroundView: UIView!
    @IBOutlet weak var regionTextField: UITextField!

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
    
}


extension ManagerHomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return taskStatusArray.count
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
            cell.countLabel.text = self.regionsArray[indexPath.row]
        }
        else {
            cell.countLabel.text = self.items[indexPath.section]
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
        return taskStatusArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
        
        tableViewCell.textLabel?.text = taskStatusArray[indexPath.row]
        tableViewCell.textLabel?.numberOfLines = 0
        tableViewCell.textLabel?.font = UIFont.init(name: "Avenir", size: 14)
        tableViewCell.textLabel?.textColor = .darkText
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
