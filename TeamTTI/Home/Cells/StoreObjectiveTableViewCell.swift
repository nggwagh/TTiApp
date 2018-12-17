//
//  ObjectiveTableViewCell.swift
//  TeamTTI
//
//  Created by Mayur Deshmukh on 18/11/18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import UIKit

class StoreObjectiveTableViewCell: UITableViewCell {

    //MARK: IBOutlets
    @IBOutlet weak var completionIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPriority: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension StoreObjectiveTableViewCell {
    func configure(with storeObjective: StoreObjective) {
        completionIcon.image = storeObjective.status.iconImage
        lblTitle.text = storeObjective.objective?.title
        lblPriority.text = storeObjective.objective?.priority.displayValue
    }
}
