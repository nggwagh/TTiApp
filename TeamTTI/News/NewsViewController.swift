//
//  NewsViewController.swift
//  TeamTTI
//
//  Created by Mohini Mehetre on 15/12/18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import UIKit
import MMDrawerController
import Moya

protocol NewsSearchViewControllerDelegate: class {
    func selected(store: Store)
    func cancel()
}

class NewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    weak var delegate: NewsSearchViewControllerDelegate?
    
    //MARK: IBOutlets
    @IBOutlet private weak var searchedNewsTableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!

    //MARK: Instance variables
    private var newsNetworkTask: Cancellable?
    private var news = [News]()
    private var filteredNews = [News]()
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //Calling API function
        self.getNewsList()

        // Glass Icon Customization
        if let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField,
            let glassIconView = textFieldInsideSearchBar.leftView as? UIImageView {
            
            //Magnifying glass
            glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
            glassIconView.tintColor = UIColor.init(named: "tti_blue")
        }
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
        
        if segue.identifier == Constant.Storyboard.News.newsDetailsSegueIdentifier {
            
            let row: Int = sender as! Int
            
            let selectedNew = self.filteredNews[row]
            
            let destinationVC = segue.destination as! NewsDetailViewController
            
            destinationVC.new = selectedNew
        }
    }
    
    
    //MARK: Api call
    func getNewsList() {
        
    //Show progress hud
    self.showHUD(progressLabel: "")
        
    newsNetworkTask?.cancel()
        
        newsNetworkTask = MoyaProvider<NewsApi>(plugins: [AuthPlugin()]).request(.news()) { result in
            
            // hiding progress hud
            self.dismissHUD(isAnimated: true)
            
            switch result {
                
            case let .success(response):
                print(response)
                
                if case 200..<400 = response.statusCode {
                  
                    do{
                        let jsonDict = try JSONSerialization.jsonObject(with: response.data, options: []) as! [[String: Any]]
                        print(jsonDict)
                        
                        self.news = News.build(from: jsonDict)
                        self.filteredNews = self.news
                        self.searchedNewsTableView.reloadData()
                    }
                    catch let error {
                        print(error.localizedDescription)
                        Alert.show(alertType: .parsingFailed, onViewContoller: self)
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
        
       self.performSegue(withIdentifier: Constant.Storyboard.News.newsDetailsSegueIdentifier, sender: indexPath.row)
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

