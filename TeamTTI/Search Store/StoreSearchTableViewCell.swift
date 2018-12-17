//
//  StoreSearchTableViewCell.swift
//  TeamTTI
//
//  Created by Deepak Sharma on 25.11.18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import UIKit

class StoreSearchTableViewCell: UITableViewCell {
    @IBOutlet weak var storeNameLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
