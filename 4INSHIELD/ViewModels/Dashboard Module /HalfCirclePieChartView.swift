//
//  HalfCirclePieChartView.swift
//  4INSHIELD
//
//  Created by kaisensData on 25/7/2023.
//

import UIKit
import Charts
import DGCharts


class HalfPieChartView: PieChartView {

    var dataEntries: [HalfPieChartEntry]? {
        didSet {
            setNeedsDisplay()
        }
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let center = CGPoint(x: rect.size.width / 2, y: rect.size.height)

        if let entries = dataEntries {
            let sum = entries.reduce(0) { $0 + $1.value }

            var startAngle: CGFloat = -CGFloat.pi / 2

            for entry in entries {
                let angle = 2 * CGFloat.pi * (entry.value / sum)
                let path = UIBezierPath()
                path.move(to: center)
                path.addArc(withCenter: center, radius: rect.size.width / 2, startAngle: startAngle, endAngle: startAngle + angle, clockwise: true)
                path.close()
                entry.color.setFill()
                path.fill()

                startAngle += angle
            }

            // Draw the percentage labels outside the pie chart
            startAngle = -CGFloat.pi / 2

            for entry in entries {
                let angle = 2 * CGFloat.pi * (entry.value / sum)
                let labelAngle = startAngle + angle / 2
                let radius: CGFloat = rect.size.width / 2 + 20 // Add a padding of 20 points from the circle's radius

                let labelX = center.x + radius * cos(labelAngle)
                let labelY = center.y + radius * sin(labelAngle)

                let percentage = (entry.value / sum) * 100.0
                let percentageText = String(format: "%.1f%%", percentage)

                let percentageLabel = UILabel()
                percentageLabel.text = percentageText
                percentageLabel.textColor = .black
                percentageLabel.font = UIFont.systemFont(ofSize: 18)
                percentageLabel.textAlignment = .right
                percentageLabel.frame = CGRect(x: labelX - 60, y: labelY - 3, width: 60, height: 30)
                addSubview(percentageLabel)

                startAngle += angle
            }
        }
    }
}

struct HalfPieChartEntry {
    let value: CGFloat
    let color: UIColor
}
