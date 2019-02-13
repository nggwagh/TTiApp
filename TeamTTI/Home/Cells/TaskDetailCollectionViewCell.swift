//
//  TaskDetailCollectionViewCell.swift
//  TeamTTI
//
//  Created by Mohini Mehetre on 06/02/19.
//  Copyright © 2019 TeamTTI. All rights reserved.
//

import UIKit

class TaskDetailCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var labelWidth: NSLayoutConstraint!
    @IBOutlet weak var labelHeight: NSLayoutConstraint!
    @IBOutlet weak var lineLabel: UILabel!

    public func setLabel(size width: CGFloat, height: CGFloat) {
        self.labelWidth.constant = width
        self.labelHeight.constant = height
    }
}
