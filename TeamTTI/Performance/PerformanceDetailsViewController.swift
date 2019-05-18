//
//  PerformanceDetailsViewController.swift
//  TeamTTI
//
//  Created by Nikhil Wagh on 5/16/19.
//  Copyright © 2019 TeamTTI. All rights reserved.
//

import UIKit

class PerformanceDetailsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var storeNameLabel: UILabel?
    private var storeObjectives = [StoreObjective]()
    var storeName: String?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.storeNameLabel?.text = self.storeName
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

extension PerformanceDetailsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
//        return self.storeObjectives.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "StoreObjectiveTableViewCell", for: indexPath) as? StoreObjectiveTableViewCell {
//            cell.configure(with: self.storeObjectives[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}

extension PerformanceDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
