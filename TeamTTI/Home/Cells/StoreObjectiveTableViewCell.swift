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
    @IBOutlet weak var checkMarkButton: UIButton!
    @IBOutlet weak var checkMarkButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var statusView: UIView!

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
    func configure(with storeObjective: StoreObjective, isSelectionOn: Bool, isChecked: Bool) {
        completionIcon.image = storeObjective.status.iconImage
        lblTitle.text = storeObjective.objective?.title
        lblPriority.text = storeObjective.objective?.priority?.displayValue
        
        if !isSelectionOn {
            checkMarkButton.isHidden = true
            checkMarkButtonWidthConstraint.constant = 0;
        }
        else if isSelectionOn && storeObjective.objective?.priority == Priority.high && storeObjective.status != .complete {
            
            checkMarkButton.isSelected = isChecked
            checkMarkButton.isHidden = false
            checkMarkButtonWidthConstraint.constant = 30;
        }
        else{
            checkMarkButton.isSelected = false
            checkMarkButton.isHidden = true
            checkMarkButtonWidthConstraint.constant = 30;
        }
    }
    
    func configure(with storeObjective: StoreObjective) {
        
        lblTitle.text = storeObjective.objective?.title
        commentButton.isUserInteractionEnabled = false
        
        if (storeObjective.status == StoreObjectiveStatus.complete){
            lblPriority.text = "COMPLETE"
            statusView.backgroundColor = UIColor(red: 86/255, green: 178/255, blue: 170/255, alpha: 1.0)
        } else {
            lblPriority.text = "INCOMPLETE"
            statusView.backgroundColor = UIColor(red: 128/255, green: 140/255, blue: 142/255, alpha: 1.0)
        }
        
        if (storeObjective.comments != nil) {
            commentButton.isHidden = false
            checkMarkButtonWidthConstraint.constant = 20;

        } else {
            commentButton.isHidden = true
            checkMarkButtonWidthConstraint.constant = 0;
        }

    }
}
