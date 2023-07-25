//
//  CustomAlertViewController.swift
//  4INSHIELD
//
//  Created by kaisensData on 25/7/2023.
//

import UIKit

class CustomAlertViewController: UIViewController {
    
    let closeButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Close", for: .normal)
            button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
            button.tintColor = .blue // Set the button color to blue
            button.setImage(UIImage(systemName: "xmark"), for: .normal) // Use the "xmark" system icon
            return button
        }()

        let pieChartViewController = HalfCircleChartAlertViewController() // Create an instance of the modified pie chart view controller

        override func viewDidLoad() {
            super.viewDidLoad()

            view.backgroundColor = UIColor.white.withAlphaComponent(0.7) // Transparent background

            // Add the pie chart view controller as a child view controller
            addChild(pieChartViewController)
            pieChartViewController.didMove(toParent: self)

            // Add the pie chart view controller's view to the alert's view
            view.addSubview(pieChartViewController.view)

            // Add the closeButton to the view
            view.addSubview(closeButton)

            // Add constraints for the closeButton to position it on the top-right corner
            closeButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
                closeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
                closeButton.widthAnchor.constraint(equalToConstant: 40),
                closeButton.heightAnchor.constraint(equalToConstant: 40)
            ])

            // Add constraints for the pie chart view
            pieChartViewController.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                pieChartViewController.view.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 16),
                pieChartViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                pieChartViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                pieChartViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
            ])
        }

        @objc func closeButtonTapped() {
            dismiss(animated: true, completion: nil)
        }
    }
