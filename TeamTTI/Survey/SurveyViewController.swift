//
//  SurveyViewController.swift
//  TeamTTI
//
//  Created by Nikhil Wagh on 5/7/19.
//  Copyright © 2019 TeamTTI. All rights reserved.
//

import UIKit
import MMDrawerController
import Moya


class SurveyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    weak var delegate: NewsSearchViewControllerDelegate?
    
    //MARK: IBOutlets
    @IBOutlet private weak var searchedNewsTableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    var refreshControl   = UIRefreshControl()
    
    //MARK: Instance variables
    private var surveyNetworkTask: Cancellable?
    private var surveys = [Survey]()
    private var filteredSurveys = [Survey]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //Calling API function
        self.getSurveyList()
        
        // Glass Icon Customization
        if let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField,
            let glassIconView = textFieldInsideSearchBar.leftView as? UIImageView {
            
            //Magnifying glass
            glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
            glassIconView.tintColor = UIColor.init(named: "tti_blue")
        }
        
        // Refresh control add in tableview.
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(getSurveyList), for: .valueChanged)
        self.searchedNewsTableView.addSubview(refreshControl)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == Constant.Storyboard.Survey.surveyDetailsSegueIdentifier {
            
            let row: Int = sender as! Int
            
            let selectedNew = self.filteredSurveys[row]
            
            let destinationVC = segue.destination as! SurveyDetailsViewController
            
            destinationVC.survey = selectedNew
        }
    }
    
    
    //MARK: Api call
    @objc func getSurveyList() {
        
        //Show progress hud
        self.showHUD(progressLabel: "")
        
        surveyNetworkTask?.cancel()
        
        surveyNetworkTask = MoyaProvider<NewsApi>(plugins: [AuthPlugin()]).request(.survey()) { result in
            
            // hiding progress hud
            self.dismissHUD(isAnimated: true)
            
            self.refreshControl.endRefreshing()
            
            switch result {
                
            case let .success(response):
                print(response)
                
                if case 200..<400 = response.statusCode {
                    
                    do{
                        let jsonDict = try JSONSerialization.jsonObject(with: response.data, options: []) as! [[String: Any]]
                        print(jsonDict)
                        
                        self.surveys = Survey.build(from: jsonDict)
                        self.filteredSurveys = self.surveys
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
                Alert.showMessage(onViewContoller: self, title: Bundle.main.displayName, message: error.localizedDescription)
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
        return filteredSurveys.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as! NewsTableViewCell
        
        // Configure the cell...
        let newsObject = filteredSurveys[indexPath.row] as Survey
        
        cell.newsTitleLabel?.text = newsObject.title
        cell.newsDateLabel?.text = newsObject.date
        cell.accessoryView = UIImageView(image: UIImage(named: "accessoryDisclosure"))
        cell.newsImageView?.image = UIImage(named: "SurveyImage")

        return cell
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        searchController.isActive = false
        
        self.performSegue(withIdentifier: Constant.Storyboard.Survey.surveyDetailsSegueIdentifier, sender: indexPath.row)
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
        }
    }

}

extension SurveyViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchBar.text, !searchText.isEmpty {
            filteredSurveys =  surveys.filter { (surveyObject) -> Bool in
                return surveyObject.title?.lowercased().contains(searchText.lowercased()) ?? false
            }
            
        } else {
            filteredSurveys = surveys
        }
        searchedNewsTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
