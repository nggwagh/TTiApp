//
//  HomeNavigationBar.swift
//  TeamTTI
//
//  Created by Deepak Sharma on 22.11.18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import UIKit
//TODO:- use IBdesignable here


protocol HomeNavigationBarDelegate: class {
    
    func leftMenuClicked()
    func calendarClicked()
    func performSearch()


}

class HomeNavigationBar: UIView {

    //MARK:- IBOutlets

    @IBOutlet private weak var leftMenuButton: UIButton!
    @IBOutlet public weak var calendarButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var titleContainerView: UIView!
    @IBOutlet private weak var downArrowImageView: UIImageView!
    @IBOutlet private weak var titleButton: UIButton!

    //MARK:- delegate

    weak var  delegate: HomeNavigationBarDelegate?
    //MARK:- IBActions

    @IBAction func leftMenu(_ sender: Any) {
        delegate?.leftMenuClicked()
    }

    @IBAction func calendar(_ sender: Any) {
        delegate?.calendarClicked()
    }

    @IBAction func search(_ sender: Any) {
        delegate?.performSearch()
    }

    func setTitle(_ title: String) {
        self.titleLabel.text = title
    }

    func setArrowImage(_ imageName: String) {
        self.downArrowImageView.image = UIImage.init(named: imageName)
    }

}
