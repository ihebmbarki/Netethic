//
//  CustomAlertViewController.swift
//  4INSHIELD
//
//  Created by kaisensData on 25/7/2023.
//

import UIKit
import DGCharts
import Charts
import Alamofire

class CustomAlertViewController: UIViewController {
    let parties = ["Joyeux(se)","Stressé(e)"]
    var valeur = [Double]()
    @IBOutlet weak var parentView: UIView! {
        didSet {
            parentView.backgroundColor = UIColor.black.withAlphaComponent(0.2) // Transparent background
        }
    }
    @IBOutlet weak var halfPieChartView: PieChartView!
    

    override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = UIColor.black.withAlphaComponent(0.5) // Transparent background
            
            halfPieChartView.holeColor = .white
            halfPieChartView.holeRadiusPercent = 0.5
            halfPieChartView.rotationEnabled = false
            halfPieChartView.highlightPerTapEnabled = true
            halfPieChartView.maxAngle = 180 // Half chart
            halfPieChartView.rotationAngle = 180 // Rotate to make the half on the upper side
            halfPieChartView.centerTextOffset = CGPoint(x: 0, y: -20)
            halfPieChartView.isUserInteractionEnabled = false
            halfPieChartView.drawEntryLabelsEnabled = false
            
            let l = halfPieChartView.legend
            l.horizontalAlignment = .center
            l.verticalAlignment = .bottom
            l.orientation = .horizontal
            l.drawInside = false
            l.xEntrySpace = 7
            l.yEntrySpace = 0
            l.yOffset = 0
            
            halfPieChartView.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
            
            // Do any additional setup after loading the view.
            self.setDataCount(2, range: 100)
            
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissView))
            parentView.addGestureRecognizer(tap)
        }
        
        @objc func dismissView() {
            self.dismiss(animated: true)
        }
        
        func setDataCount(_ count: Int, range: Double) {
            let entries = (0..<count).map { (i) -> PieChartDataEntry in
                // IMPORTANT: In a PieChart, no values (Entry) should have the same xIndex (even if from different DataSets), since no values can be drawn above each other.
                return PieChartDataEntry(value: valeur[i],
                                         label: parties[i % parties.count])
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
            
            halfPieChartView.data = data
            
            halfPieChartView.setNeedsDisplay()
        }
    }
