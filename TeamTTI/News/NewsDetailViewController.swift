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
        self.newImageView.af_setImage(withURL: URL(string: (self.new?.imageURL?[0])!)!, placeholderImage: UIImage(named: "NewsPlaceholder")!)
    }
   
    //MARK: - IBAction methods
    @IBAction func handleViewImageButtonTap(sender : UIButton) {

        let imageDownloader = AlamofireImageDownloader()

        guard
            let url1 = URL(string: "https://upload.wikimedia.org/wikipedia/commons/6/6a/Caesio_teres_in_Fiji_by_Nick_Hobgood.jpg"),
            let url2 = URL(string: "https://upload.wikimedia.org/wikipedia/commons/9/9b/Croissant%2C_cross_section.jpg"),
            let url3 = URL(string: "https://upload.wikimedia.org/wikipedia/en/9/9d/Link_%28Hyrule_Historia%29.png"),
            let url4 = URL(string: "https://upload.wikimedia.org/wikipedia/en/3/34/RickAstleyNeverGonnaGiveYouUp7InchSingleCover.jpg") else {
                return
        }
        
        let imageViewer = Optik.imageViewer(withURLs: [url1,url2,url3,url4], initialImageDisplayIndex: 0, imageDownloader: imageDownloader, activityIndicatorColor: UIColor.white, dismissButtonImage: nil, dismissButtonPosition: DismissButtonPosition.topLeading)

        self.present(imageViewer, animated: true, completion: nil)
    }

}
