//
//  PlannerTableViewCell.swift
//  TeamTTI
//
//  Created by Mohini Mehetre on 30/12/18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import UIKit

class PlannerTableViewCell: UITableViewCell {

    @IBOutlet weak var dateBackgroundView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weekdayLabel: UILabel!
    @IBOutlet weak var detail1Label: UILabel!
    @IBOutlet weak var detail2Label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
