//
//  HeaderView.swift
//  TableViewWithMultipleCellTypes
//
//  Created by Stanislav Ostrovskiy on 5/21/17.
//  Copyright © 2017 Stanislav Ostrovskiy. All rights reserved.
//

import UIKit

protocol HeaderViewDelegate: class {
    func toggleSection(header: HeaderView, section: Int)
}

class HeaderView: UITableViewHeaderFooterView {

    var item: RepPerformanceItem? {
        didSet {
            guard let item = item else {
                return
            }
            nameLabel?.text = "Mohini Store (1)"
            objectiveCountLabel?.text = "12/15"
            setCollapsed(collapsed: item.isCollapsed)
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var objectiveCountLabel: UILabel?
    @IBOutlet weak var arrowImage: UIImageView?
    var section: Int = 0
    
    weak var delegate: HeaderViewDelegate?
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapHeader)))
    }
    
    @objc private func didTapHeader() {
        delegate?.toggleSection(header: self, section: section)
    }

    func setCollapsed(collapsed: Bool) {
        arrowImage?.rotate(collapsed ? 0.0 : .pi)
        if (!collapsed) {
            nameLabel?.font = UIFont.boldSystemFont(ofSize: 15.5)
            objectiveCountLabel?.font = UIFont.boldSystemFont(ofSize: 15.5)
        }
        else {
            nameLabel?.font = UIFont.systemFont(ofSize: 16.0)
            objectiveCountLabel?.font = UIFont.systemFont(ofSize: 16.0)
        }
    }
}


extension UIView {
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        
        self.layer.add(animation, forKey: nil)
    }
}
