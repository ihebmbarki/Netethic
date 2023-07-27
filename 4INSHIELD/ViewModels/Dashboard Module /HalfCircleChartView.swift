import UIKit
import Charts
import DGCharts

class HalfCircleChartAlertViewController: UIViewController {

    let containerView = UIView()
    let halfPieChartView = HalfPieChartView()

    override func viewDidLoad() {
        super.viewDidLoad()
        halfPieChartView.noDataText = ""
        setupHalfPieChartView()

        // Set up the data entries for the half pie chart
        let entries = [
            HalfPieChartEntry(value: 52.0, color: .red),
            HalfPieChartEntry(value: 49.0, color: .green)
        ]

        // Update UI on the main thread
        DispatchQueue.main.async {
            self.halfPieChartView.dataEntries = entries
        }
    }

    private func setupHalfPieChartView() {
        // Add a container view with a white background
        containerView.backgroundColor = .white
        containerView.layer.borderColor = UIColor.white.cgColor
        containerView.layer.borderWidth = 10
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)

        // Add constraints to position the container view in the center
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 362), // Add 4 more points for the border
            containerView.heightAnchor.constraint(equalToConstant: 362) // Add 4 more points for the border
        ])

        // Add the half pie chart view to the container view
        halfPieChartView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(halfPieChartView)

        // Add constraints to position the half pie chart view in the center
        NSLayoutConstraint.activate([
            halfPieChartView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            halfPieChartView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            halfPieChartView.widthAnchor.constraint(equalToConstant: 200),
            halfPieChartView.heightAnchor.constraint(equalToConstant: 100)
        ])

        // Set up the chart explanation stack view with horizontal axis
        let stackView = UIStackView()
        stackView.axis = .horizontal // Use horizontal axis
        stackView.spacing = 8
        stackView.alignment = .center
        containerView.addSubview(stackView)

        // Add stressed label and color view to the stack view
        let stressedLabel = UILabel()
        stressedLabel.text = "Stressed"
        stressedLabel.textColor = .black
        stressedLabel.font = UIFont.systemFont(ofSize: 12)
        stressedLabel.textAlignment = .right
        stackView.addArrangedSubview(stressedLabel)

        let stressedColorView = UIView()
        stressedColorView.backgroundColor = .red
        stressedColorView.layer.cornerRadius = 6 // To make the small square view rounded
        stackView.addArrangedSubview(stressedColorView)

        // Add joyful label and color view to the stack view
        let joyfulLabel = UILabel()
        joyfulLabel.text = "Joyful"
        joyfulLabel.textColor = .black
        joyfulLabel.font = UIFont.systemFont(ofSize: 12)
        joyfulLabel.textAlignment = .left
        stackView.addArrangedSubview(joyfulLabel)

        let joyfulColorView = UIView()
        joyfulColorView.backgroundColor = .systemGreen
        joyfulColorView.layer.cornerRadius = 6 // To make the small square view rounded
        stackView.addArrangedSubview(joyfulColorView)

        stackView.translatesAutoresizingMaskIntoConstraints = false

        // Add constraints to center the stack view in the container view
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: halfPieChartView.bottomAnchor, constant: 16) // Add 16 points for spacing
        ])

        // Add constraints to keep the labels and color views aligned
        NSLayoutConstraint.activate([
            stressedLabel.trailingAnchor.constraint(equalTo: stressedColorView.leadingAnchor, constant: -8),
            joyfulLabel.leadingAnchor.constraint(equalTo: joyfulColorView.trailingAnchor, constant: 8),
            stressedColorView.widthAnchor.constraint(equalToConstant: 12),
            stressedColorView.heightAnchor.constraint(equalToConstant: 12),
            joyfulColorView.widthAnchor.constraint(equalToConstant: 12),
            joyfulColorView.heightAnchor.constraint(equalToConstant: 12)
        ])
    }
}
