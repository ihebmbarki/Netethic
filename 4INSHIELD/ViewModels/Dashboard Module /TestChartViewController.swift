//
//  TestChartViewController.swift
//  4INSHIELD
//
//  Created by kaisensData on 26/7/2023.
//

import UIKit
import Charts
import DGCharts

class TestChartViewController: UIViewController {
    @IBOutlet weak var pieChart: PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pieChart.holeColor = .white
        pieChart.holeRadiusPercent = 0.5
        pieChart.rotationEnabled = false
        pieChart.highlightPerTapEnabled = true
        pieChart.maxAngle = 180 // Half chart
        pieChart.rotationAngle = 180 // Rotate to make the half on the upper side
        pieChart.centerTextOffset = CGPoint(x: 0, y: -20)
        pieChart.isUserInteractionEnabled = false
        pieChart.drawEntryLabelsEnabled = false
        
        let l = pieChart.legend
        l.horizontalAlignment = .center
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        l.xEntrySpace = 7
        l.yEntrySpace = 0
        l.yOffset = 0
        
        pieChart.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
        
        // Do any additional setup after loading the view.
        self.setDataCount(2, range: 100)
        
    }
    
    
    func setDataCount(_ count: Int, range: UInt32) {
        let entries = (0..<count).map { (i) -> PieChartDataEntry in
            // IMPORTANT: In a PieChart, no values (Entry) should have the same xIndex (even if from different DataSets), since no values can be drawn above each other.
            return PieChartDataEntry(value: Double(47.62),
                                     label: "joyeux")
        }
        
        let set = PieChartDataSet(entries: entries, label: "")
        set.sliceSpace = 3
        set.selectionShift = 5
        set.colors = [UIColor(named: "SuccessColorChart")!, UIColor(named: "FailureColorChart")!]
        
        let data = PieChartData(dataSet: set)
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 2
        pFormatter.multiplier = 2
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        
        data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 17)!)
        data.setValueTextColor(.black)
        
        pieChart.data = data
        
        pieChart.setNeedsDisplay()
    }
}
