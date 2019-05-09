//
//  GraphTableViewCell.swift
//  TeamTTI
//
//  Created by Mayur Deshmukh on 18/11/18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import UIKit

protocol ObjectiveButtonTap {
    func currentObjectiveButtonTapped()
    func upcomingObjectiveButtonTapped()
}


class GraphTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    private var semiCircleChart: HUSemiCircleChart!
    @IBOutlet weak var currentObjectiveButton: UIButton!
    @IBOutlet weak var upcomingObjectiveButton: UIButton!
    
    var delegateRef: ObjectiveButtonTap?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setButtonBorders()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        semiCircleChart.center.x = self.contentView.center.x
    }
    
    func configure(unfinished: Int, finished: Int, total: Int, delegate: HomeViewController)  {
        self.delegateRef = delegate
        //TODO:- handle this with default value and refactor this dirtiness
        
        if (semiCircleChart != nil){
            semiCircleChart.removeFromSuperview()
        }
        
        semiCircleChart = HUSemiCircleChart(frame: CGRect.init(x: 50, y: -100, width: 250, height: 320))
        semiCircleChart.colors = NSMutableArray.init(array: [UIColor.init(named: "tti_blue")!,UIColor.init(named: "graph_unfinished_color")!])
        containerView.addSubview(semiCircleChart)
        
        //data
        let dataSource = NSMutableArray()
        dataSource.add(HUChartEntry.init(name: "Finished", value: NSNumber(integerLiteral: finished)))
        dataSource.add(HUChartEntry.init(name: "UnFinished", value: NSNumber(integerLiteral: unfinished)))
        
        semiCircleChart.data = dataSource
        
        if total > 0 {
            semiCircleChart.completedPercentage = Int32(round(Double(truncating: NSNumber(integerLiteral: finished)) / Double(truncating: NSNumber(integerLiteral: total)) * 100))
        }
        
        semiCircleChart.completedTask = Int32(truncating: NSNumber(integerLiteral: finished))
        semiCircleChart.totalTask = Int32(truncating: NSNumber(integerLiteral: total))
        semiCircleChart.title = "test" // we already fixed everything in third party code, this is
        semiCircleChart.showPortionTextType = DONT_SHOW_PORTION
    }
    
    @IBAction func handleCurrentObjectiveButtonTap(sender : UIButton) {
        sender.isSelected = true
        upcomingObjectiveButton.isSelected = false
        setButtonBorders()
        self.delegateRef?.currentObjectiveButtonTapped()
    }
    
    @IBAction func handleUpcomingObjectiveButtonTap(sender : UIButton) {
        sender.isSelected = true
        currentObjectiveButton.isSelected = false
        setButtonBorders()
        self.delegateRef?.upcomingObjectiveButtonTapped()
    }
    
    //MARK:- Private Method
    
    func setButtonBorders() {
        if currentObjectiveButton.isSelected {
            currentObjectiveButton.add(border: ViewBorder.bottom, color: UIColor.init(named: "tti_blue")!, width: 3)
            upcomingObjectiveButton.remove(border: ViewBorder.bottom)
        }
        else if upcomingObjectiveButton.isSelected {
            upcomingObjectiveButton.add(border: ViewBorder.bottom, color: UIColor.init(named: "tti_blue")!, width: 3)
            currentObjectiveButton.remove(border: ViewBorder.bottom)
        }
    }
}
