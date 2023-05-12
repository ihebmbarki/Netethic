//
//  CustomCell.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 12/5/2023.
//

import UIKit
import FSCalendar

class CustomCell: FSCalendarCell {
    // Add any custom UI elements or properties for your cell
    
    // Example: Custom label to display the date
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init!(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        // Configure and add your custom UI elements to the cell's contentView
        contentView.addSubview(dateLabel)
        
        // Add any necessary constraints for your UI elements
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Reset any values or states of your custom cell
    }
    
    // Customize the appearance of your custom cell as needed
    override func configureAppearance() {
        super.configureAppearance()
        // Customize the appearance of your cell's UI elements
        // For example, update the label's text color or background color
    }
}
