//
//  GraphTableViewCell.swift
//  TeamTTI
//
//  Created by Mayur Deshmukh on 18/11/18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import UIKit

class GraphTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    private var semiCircleChart: HUSemiCircleChart!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        semiCircleChart = HUSemiCircleChart(frame: CGRect.init(x: 50, y: -100, width: 250, height: 320))
        semiCircleChart.colors = NSMutableArray.init(array: [UIColor.init(named: "tti_blue")!,UIColor.init(named: "graph_unfinished_color")!])
        containerView.addSubview(semiCircleChart)
        
        let centerX = NSLayoutConstraint(item: semiCircleChart, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: containerView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        containerView.addConstraint(centerX)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(unfinished: NSNumber, finished: NSNumber, total: NSNumber)  {
        //TODO:- handle this with default value and refactor this dirtiness
        
       
        //data
        let dataSource = NSMutableArray()
        dataSource.add(HUChartEntry.init(name: "Finished", value: finished))
        dataSource.add(HUChartEntry.init(name: "UnFinished", value: unfinished))

        semiCircleChart.data = dataSource
        semiCircleChart.completedPercentage = Int32(round(Double(truncating: finished) / Double(truncating: total) * 100)
)
        semiCircleChart.completedTask = Int32(truncating: finished)
        semiCircleChart.totalTask = Int32(truncating: total)
        semiCircleChart.title = "test" // we already fixed everything in third party code, this is
        semiCircleChart.showPortionTextType = DONT_SHOW_PORTION
    }

}
