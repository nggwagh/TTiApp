//
//  RegionDetailCell.swift
//  TeamTTI
//
//  Created by Mohini Mehetre on 14/02/19.
//  Copyright © 2019 TeamTTI. All rights reserved.
//

import UIKit

class RegionDetailCell: UITableViewCell {

    @IBOutlet var objectiveLabel : UILabel!
    @IBOutlet var storeLabel : UILabel!
    @IBOutlet var storeNumberLabel : UILabel!
    @IBOutlet var FSRLabel : UILabel!
    @IBOutlet var dueDateLabel : UILabel!
    @IBOutlet var estimatedDateLabel : UILabel!
    @IBOutlet var commentsLabel : UILabel!
    
    @IBOutlet var objectiveBackgroundView : UIView!
    @IBOutlet var storeBackgroundView : UIView!
    @IBOutlet var storeNumberBackgroundView : UIView!
    @IBOutlet var FSRBackgroundView : UIView!
    @IBOutlet var dueDateBackgroundView : UIView!
    @IBOutlet var estimatedDateBackgroundView : UIView!
    @IBOutlet var commentsBackgroundView : UIView!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpRegionDetailCell(regionDetail: RegionObjective) {
//        self.objectiveLabel.text = "dfdfsfds ffsdfdsfdsf fdsfsdfsdf fsdfsdfdsf fsdfsdfsdfdsf"
//        self.storeLabel.text = "dfdfsfds ffsdfdsfdsf fdsfsdfsdf fsdfsdfdsf fsdfsdfsdfdsf"
//        self.storeNumberLabel.text = "dfdfsfds ffsdfdsfdsf fdsfsdfsdf fsdfsdfdsf fsdfsdfsdfdsf"
//        self.FSRLabel.text = "dfdfsfds ffsdfdsfdsf fdsfsdfsdf fsdfsdfdsf fsdfsdfsdfdsf"
//        self.dueDateLabel.text = "dfdfsfds ffsdfdsfdsf fdsfsdfsdf fsdfsdfdsf fsdfsdfsdfdsf"
//        self.estimatedDateLabel.text = "dfdfsfds ffsdfdsfdsf fdsfsdfsdf fsdfsdfdsf fsdfsdfsdfdsf"
//        self.commentsLabel.text = "dfdfsfds ffsdfdsfdsf fdsfsdfsdf fsdfsdfdsf fsdfsdfsdfdsf dfdfsfds ffsdfdsfdsf fdsfsdfsdf fsdfsdfdsf fsdfsdfsdfdsf dfdfsfds ffsdfdsfdsf fdsfsdfsdf fsdfsdfdsf fsdfsdfsdfdsf12345"
        
        self.objectiveLabel.text = regionDetail.objective ?? " "
        self.storeLabel.text = regionDetail.store ?? " "
        self.storeNumberLabel.text = regionDetail.storeNumber.debugDescription
        self.FSRLabel.text = regionDetail.fsr ?? " "
        self.dueDateLabel.text = regionDetail.dueDate ?? " "
        self.estimatedDateLabel.text = (regionDetail.estimationCompletionDate ?? "") + "\n"
        self.commentsLabel.text = regionDetail.comment ?? " "
    }
    
    func setBackgoundColors(color: UIColor) {
        objectiveBackgroundView.backgroundColor = color
        storeBackgroundView.backgroundColor = color
        storeNumberBackgroundView.backgroundColor = color
        FSRBackgroundView.backgroundColor = color
        dueDateBackgroundView.backgroundColor = color
        estimatedDateBackgroundView.backgroundColor = color
        commentsBackgroundView.backgroundColor = color
    }
    
}
