//
//  NewsDetailViewController.swift
//  TeamTTI
//
//  Created by Mohini Mehetre on 16/12/18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import UIKit
import SDWebImage

class NewsDetailViewController: UIViewController {

    //MARK: Public variables
     var new: News?
    
    //MARK: IBOutlets
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet weak var newImageView: UIImageView!
    @IBOutlet weak var newTitle: UILabel!
    @IBOutlet weak var postBy: UILabel!
    @IBOutlet weak var newDate: UILabel!
    @IBOutlet weak var newDetails: UILabel!
    
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.newDate?.text = self.new?.date
        self.newTitle?.text = self.new?.title
        self.postBy?.text = "By Admin"
        self.newDetails?.text = self.new?.detail
        
        self.newImageView?.sd_setImage(with: URL(string: (self.new?.imageURL?[0])!), placeholderImage: UIImage(named: "NewsPlaceholder"))
        
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
