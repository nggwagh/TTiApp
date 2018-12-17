//
//  NewsViewController.swift
//  TeamTTI
//
//  Created by Mohini Mehetre on 15/12/18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import UIKit
import MMDrawerController

protocol NewsSearchViewControllerDelegate: class {
    func selected(store: Store)
    func cancel()
}

class NewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    weak var delegate: NewsSearchViewControllerDelegate?
    
    @IBOutlet private weak var searchedNewsTableView: UITableView!
    //    @IBOutlet private weak var searchBarContainer: UIView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    private var news = [News]()
    
    private var filteredNews = [News]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        for i in 1...15 {
            let newsObj = News(title: "Branded Tent Survey", id: i, date: "Sep 25, 2018", imageURL: "imageURL")
            news.append(newsObj)
        }
        
        let newsObj = News(title: "Heated Gear", id: 16, date: "Sep 18, 2018", imageURL: "imageUrl")
        news.append(newsObj)
        
        filteredNews = news
        
        // Glass Icon Customization
        if let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField,
            let glassIconView = textFieldInsideSearchBar.leftView as? UIImageView {
            
            //Magnifying glass
            glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
            glassIconView.tintColor = UIColor.init(named: "tti_blue")
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredNews.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as! NewsTableViewCell
        
        // Configure the cell...
        let newsObject = filteredNews[indexPath.row] as News
        cell.configureCell(for: newsObject)
        return cell
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        searchController.isActive = false
        self.performSegue(withIdentifier: Constant.Storyboard.News.newsDetailsSegueIdentifier, sender: indexPath)
    }
    
    // MARK: - Private Methods
    
    @IBAction func close(_ sender: Any) {
        cancelSearch()
    }
    
    private func cancelSearch() {
        searchBar.resignFirstResponder()
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
}

extension NewsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchBar.text, !searchText.isEmpty {
            filteredNews =  news.filter { (newsObject) -> Bool in
                return newsObject.title.lowercased().contains(searchText.lowercased())
            }
            
        } else {
            filteredNews = news
        }
        searchedNewsTableView.reloadData()
    }
}

