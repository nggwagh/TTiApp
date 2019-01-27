//
//  NewsDetailViewController.swift
//  TeamTTI
//
//  Created by Mohini Mehetre on 16/12/18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import UIKit
import AlamofireImage
import Optik

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
        
        if ((self.new?.imageURL?.count)! > 0) {
            
            self.newImageView.af_setImage(withURL: URL(string: (self.new?.imageURL?[0])!)!, placeholderImage: UIImage(named: "NewsPlaceholder")!)
        }
        
        
        
    }
   
    //MARK: - IBAction methods
    @IBAction func handleViewImageButtonTap(sender : UIButton) {

         if ((self.new?.imageURL?.count)! > 0) {
         
            let imageDownloader = AlamofireImageDownloader()
            
            guard
                let url1 = URL(string: (self.new?.imageURL?[0])!) else {
                    return
            }
            
            let imageViewer = Optik.imageViewer(withURLs: [url1], initialImageDisplayIndex: 0, imageDownloader: imageDownloader, activityIndicatorColor: UIColor.white, dismissButtonImage: nil, dismissButtonPosition: DismissButtonPosition.topLeading)
            
            self.present(imageViewer, animated: true, completion: nil)
        }
    }
}
