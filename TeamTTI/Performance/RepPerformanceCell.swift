//
//  RepPerformanceCell.swift
//  TeamTTI
//
//  Created by Mohini Mehetre on 18/05/19.
//  Copyright © 2019 TeamTTI. All rights reserved.
//

import UIKit

class RepPerformanceCell: UITableViewCell {

    @IBOutlet weak var storeNameLabel: UILabel?
    @IBOutlet weak var objectiveCountLabel: UILabel?

    var item: RepPerformanceItem? {
        didSet {
            storeNameLabel?.text = "Mohini Store"
            objectiveCountLabel?.text = "12/15"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        storeNameLabel?.text = ""
        objectiveCountLabel?.text = ""
    }
}
