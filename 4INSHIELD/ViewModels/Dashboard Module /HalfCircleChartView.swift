


import UIKit
import Charts
import DGCharts


class HalfCircleChartAlertViewController: UIViewController {

    let halfPieChartView = HalfPieChartView()


    override func viewDidLoad() {
        super.viewDidLoad()
        halfPieChartView.noDataText = ""
        setupChartExplanation()

              let titleLabel = UILabel()
              titleLabel.text = "Moyenne général de l'humeur"
              titleLabel.textColor = .black
              titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
              titleLabel.textAlignment = .center
              view.addSubview(titleLabel)

              // Add constraints for the title label
              titleLabel.translatesAutoresizingMaskIntoConstraints = false
              NSLayoutConstraint.activate([
                  titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 198),
                  titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                  titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
              ])
        // Add the half pie chart view to the view
        halfPieChartView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(halfPieChartView)

        // Add constraints for the half pie chart view to position it in the center
        NSLayoutConstraint.activate([
            halfPieChartView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            halfPieChartView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            halfPieChartView.widthAnchor.constraint(equalToConstant: 200),
            halfPieChartView.heightAnchor.constraint(equalToConstant: 200)
        ])

        // Set up the data entries for the half pie chart
        let entries = [
                  HalfPieChartEntry(value: 52.0, color: .red),
                  HalfPieChartEntry(value: 49.0, color: .green)
              ]
              halfPieChartView.dataEntries = entries
    }
 
    private func setupChartExplanation() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .center
        view.addSubview(stackView)

        let stressedLabel = UILabel()
        stressedLabel.text = "Stressed"
        stressedLabel.textColor = .black
        stressedLabel.font = UIFont.systemFont(ofSize: 12)
        stressedLabel.textAlignment = .left
        stackView.addArrangedSubview(stressedLabel)

        let stressedColorView = UIView()
        stressedColorView.backgroundColor = .red
        stressedColorView.layer.cornerRadius = 6 // To make the small square view rounded
        stackView.addArrangedSubview(stressedColorView)

        let joyfulLabel = UILabel()
        joyfulLabel.text = "Joyful"
        joyfulLabel.textColor = .black
        joyfulLabel.font = UIFont.systemFont(ofSize: 12)
        joyfulLabel.textAlignment = .left
        stackView.addArrangedSubview(joyfulLabel)

        let joyfulColorView = UIView()
        joyfulColorView.backgroundColor = .green
        joyfulColorView.layer.cornerRadius = 6 // To make the small square view rounded
        stackView.addArrangedSubview(joyfulColorView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        

        // Add constraints to center the stack view in the main view
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            stressedLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            joyfulLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            stressedColorView.widthAnchor.constraint(equalToConstant: 12),
            joyfulColorView.widthAnchor.constraint(equalToConstant: 12),
            stressedColorView.heightAnchor.constraint(equalToConstant: 12),
            joyfulColorView.heightAnchor.constraint(equalToConstant: 12),
            
            stressedColorView.leadingAnchor.constraint(equalTo: stressedLabel.trailingAnchor, constant: 8),
            joyfulColorView.leadingAnchor.constraint(equalTo: joyfulLabel.trailingAnchor, constant: 8)
        ])
    }


    
  
}

 


