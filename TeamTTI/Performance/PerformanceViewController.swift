//
//  PerformanceViewController.swift
//  TeamTTI
//
//  Created by Nikhil Wagh on 5/16/19.
//  Copyright © 2019 TeamTTI. All rights reserved.
//

import UIKit
import MMDrawerController
import Moya


class PerformanceViewController: UIViewController {

    //MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView?

    var items = [RepPerformanceItem]()
    
    var reloadSections: ((_ section: Int) -> Void)?
    
    var storeList = [StorePerformance]()
    
    private var storeNetworkTask: Cancellable?

    
    //MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let repPerformance = RepPerformanceItem.init(sectionTitle: "Stores", rowCount: 4, isCollapsible: true, isCollapsed: true)
        self.items.append(repPerformance)
        let repPerformance1 = RepPerformanceItem.init(sectionTitle: "Stores", rowCount: 5, isCollapsible: true, isCollapsed: true)
        self.items.append(repPerformance1)

       
        tableView?.register(HeaderView.nib, forHeaderFooterViewReuseIdentifier: HeaderView.identifier)

        self.reloadSections = { [weak self] (section: Int) in
            self?.tableView?.beginUpdates()
            self?.tableView?.reloadSections([section], with: .fade)
            self?.tableView?.endUpdates()
        }
        
        tableView?.estimatedRowHeight = 100
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.sectionHeaderHeight = 50
        
        self.getStorePerformanceList()
        
    }
    
    
    //MARK: - Private Methods
    
    func getStorePerformanceList(){
        
        //Show progress hud
        self.showHUD(progressLabel: "")
        
        storeNetworkTask?.cancel()
        
        storeNetworkTask = MoyaProvider<StoreApi>(plugins: [AuthPlugin()]).request(.getStorePerformanceList(regionId: SettingsManager.shared().getDefaultRegionID()!)) { result in
            
            // hiding progress hud
            self.dismissHUD(isAnimated: true)
            
            switch result {
                
            case let .success(response):
                print(response)
                
                if case 200..<400 = response.statusCode {
                    
                    do{
                        let jsonDict = try JSONSerialization.jsonObject(with: response.data, options: []) as! [[String: Any]]
                        print(jsonDict)
                        
                        self.storeList = StorePerformance.build(from: jsonDict)
                        
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
    
    @IBAction func leftMenuClicked() {
        RootViewControllerFactory.centerContainer.toggle(MMDrawerSide.left, animated: true) { status in
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "PerformanceDetailsSegueIdentifier") {
//            let item = items[(sender as! NSIndexPath).section]
            let destination = segue.destination as! PerformanceDetailsViewController
            destination.storeName = "Store name"
        }
    }
}

extension PerformanceViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let item = items[section]
        guard item.isCollapsible else {
            return item.rowCount!
        }
        
        if item.isCollapsed {
            return 0
        } else {
            return item.rowCount!
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RepPerformanceCell", for: indexPath) as? RepPerformanceCell {
            cell.item = item
            return cell
        }
        return UITableViewCell()
    }
}

extension PerformanceViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderView.identifier) as? HeaderView {
            let item = items[section]
            
            headerView.item = item
            headerView.section = section
            headerView.delegate = self
            return headerView
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "PerformanceDetailsSegueIdentifier", sender: indexPath)
    }
}

extension PerformanceViewController: HeaderViewDelegate {
    func toggleSection(header: HeaderView, section: Int) {
        let item = items[section]
        if item.isCollapsible {
            
            // Toggle collapse
            let collapsed = !item.isCollapsed
            items[section].isCollapsed = collapsed
            header.setCollapsed(collapsed: collapsed)
            
            // Adjust the number of the rows inside the section
            reloadSections?(section)
        }
    }
}
