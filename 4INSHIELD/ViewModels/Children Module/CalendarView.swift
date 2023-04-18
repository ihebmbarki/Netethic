//
//  CalendarView.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 18/4/2023.
//

import UIKit
import Foundation
import FSCalendar

protocol CalendarViewDelegate: AnyObject {
    func calendarView(_ calendarView: CalendarView, didSelectDate date: Date)
}


class CalendarView: UIView {
    
    
    weak var delegate: CalendarViewDelegate?


    // MARK: - Properties

    public var selectedDate: Date?

    private let calendar: FSCalendar = {
        let calendar = FSCalendar(frame: .zero)
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.appearance.headerTitleColor = .black
        calendar.appearance.weekdayTextColor = .black
        calendar.appearance.todayColor = .clear
        calendar.appearance.selectionColor = UIColor(red: 0.25, green: 0.49, blue: 0.87, alpha: 1.0)
        calendar.appearance.titleSelectionColor = .white
        calendar.backgroundColor = .white
        return calendar
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupCalendar()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods

    private func setupSubviews() {
        addSubview(calendar)
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: topAnchor),
            calendar.leadingAnchor.constraint(equalTo: leadingAnchor),
            calendar.trailingAnchor.constraint(equalTo: trailingAnchor),
            calendar.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func setupCalendar() {
        calendar.delegate = self
        calendar.dataSource = self
        calendar.allowsMultipleSelection = false
    }
    
    
}

// MARK: - FSCalendarDelegate

extension CalendarView: FSCalendarDelegate {

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
        delegate?.calendarView(self, didSelectDate: date)
    }
}

// MARK: - FSCalendarDataSource

extension CalendarView: FSCalendarDataSource {

    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return true
    }
}
