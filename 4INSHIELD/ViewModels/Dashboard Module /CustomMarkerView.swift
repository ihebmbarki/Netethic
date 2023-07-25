//
//  CustomMarkerView.swift
//  4INSHIELD
//
//  Created by kaisensData on 25/7/2023.
//

import Foundation
import DGCharts
// Custom MarkerView class to draw the plus symbol for data points
class CustomMarkerView: MarkerView {
    private var color: UIColor
    private var font: UIFont
    
    init(color: UIColor, font: UIFont) {
        self.color = color
        self.font = font
        super.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        self.backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(context: CGContext, point: CGPoint) {
        let plusPath = UIBezierPath()
        plusPath.move(to: CGPoint(x: point.x, y: point.y - 5))
        plusPath.addLine(to: CGPoint(x: point.x, y: point.y + 5))
        plusPath.move(to: CGPoint(x: point.x - 5, y: point.y))
        plusPath.addLine(to: CGPoint(x: point.x + 5, y: point.y))
        color.setStroke()
        plusPath.lineWidth = 2.0
        plusPath.stroke()
    }
}
