//
//  NewsTableViewCell.swift
//  TeamTTI
//
//  Created by Mohini Mehetre on 15/12/18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var newsTitleLabel : UILabel!
    @IBOutlet weak var newsDateLabel : UILabel!
    @IBOutlet weak var newsImageView : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(for newsObject : News) {
        self.newsTitleLabel?.text = newsObject.title
        self.newsDateLabel?.text = newsObject.date
        self.newsImageView?.image = UIImage(named: "ttilogo")
        
        self.accessoryView = UIImageView(image: UIImage(named: "accessoryDisclosure"))
    }
}

