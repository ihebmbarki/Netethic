//
//  homeVC.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 15/3/2023.
//

import UIKit
import Foundation
import FSCalendar
import Charts

class homeVC: UIViewController, FSCalendarDataSource, FSCalendarDelegate, ChartViewDelegate {
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter
    }()
    
    var selectedChild: Child?
    var ChildInfoViewController: ChildInfoViewController?
//    var selectedStartDate: Date?
//    var selectedEndDate: Date?

    @IBOutlet weak var topView: UIView!
    private var SideBar: SideBar!
    private var sideMenuRevealWidth: CGFloat = 260
    private let paddingForRotation: CGFloat = 150
    private var isExpanded: Bool = false
    
    // Expand/Collapse the side menu by changing trailing's constant
    private var sideMenuTrailingConstraint: NSLayoutConstraint!
    
    private var revealSideMenuOnTop: Bool = true
    private var sideMenuShadowView: UIView!
    
    private var draggingIsEnabled: Bool = false
    private var panBaseLocation: CGFloat = 0.0
    
    @IBOutlet weak var BonjourLbl: UILabel!
    @IBOutlet weak var childInfoContainerView: UIView!
    @IBOutlet weak var childButton: UIButton!
    @IBOutlet weak var changeLanguageBtn: UIBarButtonItem!
    
    
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var calendarBtn: UIButton!
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var cardsCollectionView: UICollectionView!
    
    @IBOutlet weak var chartView: BarChartView!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the chart view
        chartView.xAxis.valueFormatter = DateAxisValueFormatter() // Set custom value formatter for x-axis dates
        
        // Register custom collection view cell class
        cardsCollectionView.delegate = self
        cardsCollectionView.dataSource = self
        let nib = UINib(nibName: "CardCell", bundle: nil)
        cardsCollectionView.register(nib, forCellWithReuseIdentifier: "CardCell")
        
        //Set up TopView
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = topView.bounds
        gradientLayer.colors = [UIColor(red: 0.25, green: 0.56, blue: 0.80, alpha: 1.00).cgColor, UIColor(red: 0.24, green: 0.76, blue: 0.95, alpha: 1.00).cgColor]
        topView.layer.insertSublayer(gradientLayer, at: 0)
        
        //Set up date textfield
        dateTF.layer.masksToBounds = false
//        dateTF.layer.cornerRadius = dateTF.bounds.height / 2
        dateTF.layer.shadowColor = UIColor.gray.cgColor
        dateTF.layer.shadowOpacity = 0.5
        dateTF.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        // Set up the button's action
        calendarBtn.addTarget(self, action: #selector(showDatePicker), for: .touchUpInside)

        // Instantiate child view controllers from storyboard
        ChildInfoViewController = storyboard?.instantiateViewController(withIdentifier: "ChildInfoViewController") as? ChildInfoViewController
        
        //Set up user name
        getCurrentUserData()
        //Set up child profile pic
        loadChildInfo()
        guard let selectedChild = selectedChild else { return }
        // Load child photo
        if let photo = selectedChild.photo, !photo.isEmpty {
            var photoUrl = photo
            if let range = photoUrl.range(of: "http://") {
                photoUrl.replaceSubrange(range, with: "https://")
            }
            if let url = URL(string: photoUrl) {
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if let data = data {
                        DispatchQueue.main.async {
                            let imageView = UIImageView(image: UIImage(data: data))
                            imageView.contentMode = .scaleAspectFill
                            imageView.translatesAutoresizingMaskIntoConstraints = false
                            imageView.layer.cornerRadius = 18 // half of 36
                            imageView.clipsToBounds = true
                            self.childButton.addSubview(imageView)
                            NSLayoutConstraint.activate([
                                imageView.widthAnchor.constraint(equalToConstant: 36),
                                imageView.heightAnchor.constraint(equalToConstant: 36),
                                imageView.centerXAnchor.constraint(equalTo: self.childButton.centerXAnchor),
                                imageView.centerYAnchor.constraint(equalTo: self.childButton.centerYAnchor)
                            ])
                        }
                    }
                }.resume()
            }
        }

        // Add target action to child button
        childButton.addTarget(self, action: #selector(childButtonTapped), for: .touchUpInside)
        
        // Side Menu Gestures
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        panGestureRecognizer.delegate = self
        view.addGestureRecognizer(panGestureRecognizer)
        
        // Shadow Background View
        self.sideMenuShadowView = UIView(frame: self.view.bounds)
        self.sideMenuShadowView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TapGestureRecognizer))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapGestureRecognizer)
        if self.revealSideMenuOnTop {
            view.insertSubview(self.sideMenuShadowView, at: 1)
        }
        
        // Side Menu
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        self.SideBar = storyboard.instantiateViewController(withIdentifier: "sidebarViewController") as? SideBar
        self.SideBar.defaultHighlightedCell = 0 // Default Highlighted Cell
        
        self.SideBar.delegate = self
        view.insertSubview(self.SideBar!.view, at: self.revealSideMenuOnTop ? 2 : 0)
        view.bringSubviewToFront(self.SideBar!.view)
        addChild(self.SideBar!)
        self.SideBar!.didMove(toParent: self)
        
        // Side Menu AutoLayout
        self.SideBar.view.translatesAutoresizingMaskIntoConstraints = false
        
        if self.revealSideMenuOnTop {
            self.sideMenuTrailingConstraint = self.SideBar.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -self.sideMenuRevealWidth - self.paddingForRotation)
            self.sideMenuTrailingConstraint.isActive = true
        }
        NSLayoutConstraint.activate([
            self.SideBar.view.widthAnchor.constraint(equalToConstant: self.sideMenuRevealWidth),
            self.SideBar.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.SideBar.view.topAnchor.constraint(equalTo: view.topAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateLocalizedStrings()
        updateLanguageButtonImage()
    }
    
    @IBAction func changeLanguageBtnTapped(_ sender: Any) {
        let languages = ["English", "Français"]
        let languageAlert = UIAlertController(title: "Choisir la langue", message: nil, preferredStyle: .actionSheet)

        for language in languages {
            let action = UIAlertAction(title: language, style: .default) { action in
                if action.title == "English" {
                    LanguageManager.shared.currentLanguage = "en"
                    UserDefaults.standard.set("en", forKey: "selectedLanguage")
                } else if action.title == "Français" {
                    LanguageManager.shared.currentLanguage = "fr"
                    UserDefaults.standard.set("fr", forKey: "selectedLanguage")
                }
                
                self.updateLanguageButtonImage()
                self.updateLocalizedStrings()
                self.view.setNeedsLayout() // Refresh the layout of the view
            }
            languageAlert.addAction(action)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        languageAlert.addAction(cancelAction)

        present(languageAlert, animated: true, completion: nil)
    }
    
    func updateLanguageButtonImage() {
        if let selectedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") {
            if selectedLanguage == "fr" {
                changeLanguageBtn.image = UIImage(named: "fr_white")
            } else if selectedLanguage == "en" {
                changeLanguageBtn.image = UIImage(named: "eng_white")
            }
        }
    }
    
    func updateLocalizedStrings() {
        let bundle = Bundle.main.path(forResource: LanguageManager.shared.currentLanguage, ofType: "lproj").flatMap(Bundle.init) ?? Bundle.main

        let bonjourString = NSLocalizedString("hello", tableName: nil, bundle: bundle, value: "", comment: "Bonjour greeting")
        let username = UserDefaults.standard.string(forKey: "username") ?? ""
        let localizedText = "\(bonjourString) \(username) !"

        BonjourLbl.text = localizedText
        dateTF.placeholder = NSLocalizedString("rangeDate", tableName: nil, bundle: bundle, value: "", comment: "rangeDate")
    }


    
    @objc func childButtonTapped() {
        guard let selectedChild = selectedChild else { return }
        // Add enfantsViewController as child view controller
        addChild(ChildInfoViewController!)
        ChildInfoViewController?.view.frame = childInfoContainerView.bounds
        childInfoContainerView.addSubview(ChildInfoViewController!.view)
        ChildInfoViewController?.didMove(toParent: self)
    }

    // Keep the state of the side menu (expanded or collapse) in rotation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate { _ in
            if self.revealSideMenuOnTop {
                self.sideMenuTrailingConstraint.constant = self.isExpanded ? 0 : (-self.sideMenuRevealWidth - self.paddingForRotation)
            }
        }
    }
    
    @IBAction func revealSideMenu(_ sender: Any) {
        self.sideMenuState(expanded: self.isExpanded ? false : true)
    }
    
    func getCurrentUserData() {
        guard let savedUserName = UserDefaults.standard.string(forKey: "username") else { return }
        DispatchQueue.main.async {
            APIManager.shareInstance.fetchCurrentUserData(username: savedUserName) { user in
                self.BonjourLbl.text = "Bonjour \(user.username) !"
            }
        }
    }
    
//    @objc func showDatePicker() {
//        if let calendar = calendarView.subviews.first(where: { $0 is FSCalendar }) {
//            // Calendar is already displayed, so remove it and hide the calendar view
//            calendar.removeFromSuperview()
//            calendarView.isHidden = true
//        } else {
//            // Show the calendar view and create and configure the calendar
//            calendarView.isHidden = false
//
//            let calendar = FSCalendar(frame: calendarView.bounds)
//            calendar.dataSource = self
//            calendar.delegate = self
//            calendar.allowsMultipleSelection = true;
//
//            // Add the calendar to the calendarView
//            calendarView.addSubview(calendar)
//        }
//    }
//
//    // FSCalendarDelegate method for handling date selection
//    private func calendar(_ calendar: FSCalendar, didSelect dates: [Date], at monthPosition: FSCalendarMonthPosition) {
//        guard dates.count > 1 else {
//            return
//        }
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd-MM-yyyy"
//        let startDateString = dateFormatter.string(from: dates[0])
//        let endDateString = dateFormatter.string(from: dates[1])
//        dateTF.text = "Du \(startDateString) Au \(endDateString)"
//
//        // Remove the calendar from its superview and hide the calendar view
//        calendar.removeFromSuperview()
//        calendarView.isHidden = true
//    }

    var startDateTimestamp: TimeInterval = 0
    var endDateTimestamp: TimeInterval = 0
    
    
    func loadChildInfo() {
        guard let selectedChild = selectedChild else { return }
        if (selectedChild.photo ?? "").isEmpty {
            childButton.imageView?.image = nil
            DispatchQueue.main.async {
                let imageView = UIImageView(image: UIImage(named: selectedChild.gender == "M" ? "malePic" : "femalePic"))
                imageView.contentMode = .scaleAspectFill
                imageView.translatesAutoresizingMaskIntoConstraints = false
                self.childButton.addSubview(imageView)
                NSLayoutConstraint.activate([
                    imageView.widthAnchor.constraint(equalToConstant: 36),
                    imageView.heightAnchor.constraint(equalToConstant: 36),
                    imageView.centerXAnchor.constraint(equalTo: self.childButton.centerXAnchor),
                    imageView.centerYAnchor.constraint(equalTo: self.childButton.centerYAnchor)
                ])
            }
        } else {
            if let photo = selectedChild.photo, !photo.isEmpty {
                var photoUrl = photo
                if let range = photoUrl.range(of: "http://") {
                    photoUrl.replaceSubrange(range, with: "https://")
                }
                if let url = URL(string: photoUrl) {
                    URLSession.shared.dataTask(with: url) { (data, response, error) in
                        if let data = data {
                            DispatchQueue.main.async {
                                let imageView = UIImageView(image: UIImage(data: data))
                                imageView.contentMode = .scaleAspectFill
                                imageView.translatesAutoresizingMaskIntoConstraints = false
                                imageView.layer.cornerRadius = 18 // half of 36
                                imageView.clipsToBounds = true
                                self.childButton.addSubview(imageView)
                                NSLayoutConstraint.activate([
                                    imageView.widthAnchor.constraint(equalToConstant: 36),
                                    imageView.heightAnchor.constraint(equalToConstant: 36),
                                    imageView.centerXAnchor.constraint(equalTo: self.childButton.centerXAnchor),
                                    imageView.centerYAnchor.constraint(equalTo: self.childButton.centerYAnchor)
                                ])
                            }
                        }
                    }.resume()
                }
            }
        }
    }
    
    func gotoScreen(storyBoardName: String, stbIdentifier: String) {
        let storyboard = UIStoryboard(name: storyBoardName, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: stbIdentifier) as! UINavigationController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}

extension homeVC : SideBarDelegate {
    func selectedCell(_ row: Int) {
        switch row {
        case 0:
            // Profile
            self.gotoScreen(storyBoardName: "Profile", stbIdentifier: "userProfile")
//        case 1:
//            // Autorisation d’accés
//            self.showViewController(viewController: UINavigationController.self, storyboardId: " ")
//        case 2:
//            // Nous contacter
//            self.showViewController(viewController: UINavigationController.self, storyboardId: " ")
//        case 3:
//            // Mentions légales
//            self.showViewController(viewController: MentionsLegales.self, storyboardId: " ")
//        case 4:
//            // À propos
//            self.showViewController(viewController: APropos.self, storyboardId: " ")
//        case 5:
//            //Déconnexion
//            self.showViewController(viewController: BooksViewController.self, storyboardId: " ")
        default:
            break
        }
        
        // Collapse side menu with animation
        DispatchQueue.main.async { self.sideMenuState(expanded: false) }
    }
    
    func showViewController<T: UIViewController>(viewController: T.Type, storyboardId: String) -> () {
        // Remove the previous View
        for subview in view.subviews {
            if subview.tag == 99 {
                subview.removeFromSuperview()
            }
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: storyboardId) as! T
        vc.view.tag = 99
        view.insertSubview(vc.view, at: self.revealSideMenuOnTop ? 0 : 1)
        addChild(vc)
        DispatchQueue.main.async {
            vc.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                vc.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                vc.view.topAnchor.constraint(equalTo: self.view.topAnchor),
                vc.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                vc.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
            ])
        }
        if !self.revealSideMenuOnTop {
            if isExpanded {
                vc.view.frame.origin.x = self.sideMenuRevealWidth
            }
            if self.sideMenuShadowView != nil {
                vc.view.addSubview(self.sideMenuShadowView)
            }
        }
        vc.didMove(toParent: self)
    }
    
    func sideMenuState(expanded: Bool) {
        if expanded {
            self.animateSideMenu(targetPosition: self.revealSideMenuOnTop ? 0 : self.sideMenuRevealWidth) { _ in
                self.isExpanded = true
            }
            // Animate Shadow (Fade In)
            UIView.animate(withDuration: 0.5) { self.sideMenuShadowView.alpha = 0.6 }
        }
        else {
            self.animateSideMenu(targetPosition: self.revealSideMenuOnTop ? (-self.sideMenuRevealWidth - self.paddingForRotation) : 0) { _ in
                self.isExpanded = false
            }
            // Animate Shadow (Fade Out)
            UIView.animate(withDuration: 0.5) { self.sideMenuShadowView.alpha = 0.0 }
        }
    }
    
    func animateSideMenu(targetPosition: CGFloat, completion: @escaping (Bool) -> ()) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .layoutSubviews, animations: {
            if self.revealSideMenuOnTop {
                self.sideMenuTrailingConstraint.constant = targetPosition
                self.view.layoutIfNeeded()
            }
            else {
                self.view.subviews[1].frame.origin.x = targetPosition
            }
        }, completion: completion)
    }
}

extension UIViewController {
    // With this extension you can access the MainViewController from the child view controllers.
    func revealViewController() -> homeVC? {
        var viewController: UIViewController? = self

        if viewController != nil && viewController is homeVC {
            return viewController! as? homeVC
        }
        while (!(viewController is homeVC) && viewController?.parent != nil) {
            viewController = viewController?.parent
        }
        if viewController is homeVC {
            return viewController as? homeVC
        }
        return nil
    }
}

//MARK: Gesture Recognizer Delegate
extension homeVC: UIGestureRecognizerDelegate {
    
    @objc func TapGestureRecognizer(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            if self.isExpanded {
                self.sideMenuState(expanded: false)
            }
        }
    }
    
    // Close side menu when you tap on the shadow background view
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: self.SideBar.view))! {
            return false
        }
        return true
    }
    
    // Dragging Side Menu
    @objc private func handlePanGesture(sender: UIPanGestureRecognizer) {
                
        let position: CGFloat = sender.translation(in: self.view).x
        let velocity: CGFloat = sender.velocity(in: self.view).x
        
        switch sender.state {
        case .began:
            
            // If the user tries to expand the menu more than the reveal width, then cancel the pan gesture
            if velocity > 0, self.isExpanded {
                sender.state = .cancelled
            }
            
            // If the user swipes right but the side menu hasn't expanded yet, enable dragging
            if velocity > 0, !self.isExpanded {
                self.draggingIsEnabled = true
            }
            // If user swipes left and the side menu is already expanded, enable dragging they collapsing the side menu)
            else if velocity < 0, self.isExpanded {
                self.draggingIsEnabled = true
            }
            
            if self.draggingIsEnabled {
                // If swipe is fast, Expand/Collapse the side menu with animation instead of dragging
                let velocityThreshold: CGFloat = 550
                if abs(velocity) > velocityThreshold {
                    self.sideMenuState(expanded: self.isExpanded ? false : true)
                    self.draggingIsEnabled = false
                    return
                }
                
                if self.revealSideMenuOnTop {
                    self.panBaseLocation = 0.0
                    if self.isExpanded {
                        self.panBaseLocation = self.sideMenuRevealWidth
                    }
                }
            }
            
        case .changed:
            
            // Expand/Collapse side menu while dragging
            if self.draggingIsEnabled {
                if self.revealSideMenuOnTop {
                    // Show/Hide shadow background view while dragging
                    let xLocation: CGFloat = self.panBaseLocation + position
                    let percentage = (xLocation * 150 / self.sideMenuRevealWidth) / self.sideMenuRevealWidth
                    
                    let alpha = percentage >= 0.6 ? 0.6 : percentage
                    self.sideMenuShadowView.alpha = alpha
                    
                    // Move side menu while dragging
                    if xLocation <= self.sideMenuRevealWidth {
                        self.sideMenuTrailingConstraint.constant = xLocation - self.sideMenuRevealWidth
                    }
                }
                else {
                    if let recogView = sender.view?.subviews[1] {
                        // Show/Hide shadow background view while dragging
                        let percentage = (recogView.frame.origin.x * 150 / self.sideMenuRevealWidth) / self.sideMenuRevealWidth
                        
                        let alpha = percentage >= 0.6 ? 0.6 : percentage
                        self.sideMenuShadowView.alpha = alpha
                        
                        // Move side menu while dragging
                        if recogView.frame.origin.x <= self.sideMenuRevealWidth, recogView.frame.origin.x >= 0 {
                            recogView.frame.origin.x = recogView.frame.origin.x + position
                            sender.setTranslation(CGPoint.zero, in: view)
                        }
                    }
                }
            }
        case .ended:
            self.draggingIsEnabled = false
            // If the side menu is half Open/Close, then Expand/Collapse with animationse with animation
            if self.revealSideMenuOnTop {
                let movedMoreThanHalf = self.sideMenuTrailingConstraint.constant > -(self.sideMenuRevealWidth * 0.5)
                self.sideMenuState(expanded: movedMoreThanHalf)
            }
            else {
                if let recogView = sender.view?.subviews[1] {
                    let movedMoreThanHalf = recogView.frame.origin.x > self.sideMenuRevealWidth * 0.5
                    self.sideMenuState(expanded: movedMoreThanHalf)
                }
            }
        default:
            break
        }
    }
}

extension homeVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Return the number of items in your data source
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Dequeue the cell
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as? CustomCollectionViewCell else {
            fatalError("Unable to dequeue CustomCollectionViewCell")
        }
        // Assign the description and logo based on indexPath or any other logic
        switch indexPath.item {
        case 0:
            cell.cardDesc.text = "HARCÈLEMENT ACTUEL"
            cell.cardLogo.image = UIImage(named: "HARCÈLEMENT_ACTUEL")
            
            // Call the getScore function to fetch the score
            APIManager.shareInstance.getScore { score in
                // Update the UI on the main thread
                DispatchQueue.main.async {
                    let (backgroundImage, cardTitle) = self.getBackgroundImage(for: score?.global_score)
                    
                    if let backgroundImage = backgroundImage {
                        cell.containerView.backgroundColor = UIColor(patternImage: backgroundImage)
                    } else {
                        // Handle nil background image
                        cell.containerView.backgroundColor = .white
                    }
                    
                    // Update the progress bar with the score value
                    cell.cardProgress.progress = Float(score?.global_score ?? 0) / 100.0
                    
                    // Update the cardTitle label's text based on the score
                    cell.cardTitle.text = cardTitle
                }
            }

        case 1:
            cell.cardDesc.text = "RISQUE FUTUR HARCÈLEMENT"
            cell.cardLogo.image = UIImage(named: "RISQUE_FUTUR")
            cell.containerView.backgroundColor = UIColor(patternImage: UIImage(named: "orange")!)
        case 2:
            cell.cardDesc.text = "ÉTAT MENTAL"
            cell.cardLogo.image = UIImage(named: "ETAT_MENTAL")

            // Call the fetchAndProcessMentalState function to fetch and process the mental state data
            fetchAndProcessMentalState(cell: cell)
        default:
            break
        }

        return cell
    }
    
    func fetchAndProcessMentalState(cell: CustomCollectionViewCell) {
           // Call the getMentalState function to fetch the mental state data
           APIManager.shareInstance.getMentalState(childID: selectedChild!.id, startDateTimestamp: startDateTimestamp, endDateTimestamp: endDateTimestamp) { states in
               // Update the UI on the main thread
               DispatchQueue.main.async {
                   if let states = states {
                       let countHappy = states.filter { $0.mental_state == "happy" }.count
                       let countStressed = states.filter { $0.mental_state == "stress" }.count

                       let text: String
                       let backgroundImage: UIImage?

                       if countHappy > countStressed {
                           text = "happy"
                           backgroundImage = self.getBackgroundImageST(forMentalState: "happy")
                       } else {
                           text = "stressed"
                           backgroundImage = self.getBackgroundImageST(forMentalState: "stress")
                       }

                       // Update your text label with the determined text value
                       cell.cardTitle.text = text

                       // Set the background image based on the mental state
                       cell.containerView.backgroundColor = backgroundImage != nil ? UIColor(patternImage: backgroundImage!) : .white
                   } else {
                       // Handle nil state
                       cell.cardTitle.text = "N/A"
                       cell.containerView.backgroundColor = self.getBackgroundImageST(forMentalState: nil) != nil ? UIColor(patternImage: self.getBackgroundImageST(forMentalState: nil)!) : .white
                   }
               }
           }
       }
    
    func fetchAndProcessMaxScores(completion: @escaping ([String: Int]?) -> Void) {
        // Fetch the required parameters for the API request (e.g., childID, startDateTimestamp, endDateTimestamp)
        let childID = selectedChild?.id ?? 0
        let startDateTimestamp = self.startDateTimestamp
        let endDateTimestamp = self.endDateTimestamp
        
        // Call the getMaxScoresPerDate function with the parameters
        APIManager.shareInstance.getMaxScorePerDate(childID: childID, startDateTimestamp: startDateTimestamp, endDateTimestamp: endDateTimestamp) { maxScoresData in
            // Process and handle the maxScoresData as needed
            
            // Pass the processed maxScoresData to the completion handler
            completion(maxScoresData)
            
            // Update the chart with the processed data
            self.updateChart(with: maxScoresData)
        }
    }

    func updateChart(with maxScoresData: [String: Int]?) {
        // Validate and filter out any invalid entries
        var entries = maxScoresData?.compactMap { key, value -> ChartDataEntry? in
            guard let date = dateFormatter.date(from: key) else {
                return nil
            }
            return ChartDataEntry(x: Double(date.timeIntervalSince1970), y: Double(value))
        } ?? []

        if entries.isEmpty {
            // Handle empty data entries by displaying a zero-value curve
            let zeroEntry = ChartDataEntry(x: Double(Date().timeIntervalSince1970), y: 0)
            entries.append(zeroEntry)
        }

        // Create a data set with the entries
        let dataSet = LineChartDataSet(entries: entries, label: "Max Scores per Date")
        dataSet.colors = [UIColor.systemBlue] // Set the line color

        // Configure the data set
        dataSet.drawCircleHoleEnabled = true // Disable circle hole in data points
        dataSet.valueFont = UIFont.systemFont(ofSize: 12) // Set the value label font size
        dataSet.valueTextColor = UIColor.black // Set the value label color
        dataSet.drawValuesEnabled = true // Show the value for each data point

        // Create a data object with the data set
        let data = LineChartData(dataSet: dataSet)

        // Resize the chart view to match the available space
        chartView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)

        // Configure the chart view
        chartView.data = data
        chartView.xAxis.labelPosition = .bottom // Set x-axis label position
        chartView.xAxis.valueFormatter = DateAxisValueFormatter() // Set custom value formatter for x-axis dates
        chartView.xAxis.labelTextColor = UIColor.black // Set x-axis label text color
        chartView.xAxis.drawLabelsEnabled = true // Enable drawing of x-axis labels

        // Customize the appearance of the chart
        chartView.legend.enabled = false // Hide the legend
        chartView.rightAxis.enabled = false // Hide the right axis
        chartView.leftAxis.labelTextColor = UIColor.black // Set the left axis label color
        chartView.leftAxis.axisLineColor = UIColor.black // Set the left axis line color
        chartView.leftAxis.drawGridLinesEnabled = true // Show the grid lines on the left axis
        chartView.leftAxis.gridColor = UIColor.lightGray // Set the grid lines color
        chartView.leftAxis.labelFont = UIFont.systemFont(ofSize: 12) // Set the left axis label font size
        chartView.leftAxis.labelCount = 6 // Set the number of labels on the left axis
        chartView.leftAxis.axisMinimum = 0 // Set the minimum value for the left axis
        chartView.leftAxis.axisMaximum = 1 // Set the maximum value for the left axis

        // Set the chart view's visible range
        chartView.setVisibleXRange(minXRange: 1, maxXRange: 7) // Adjust the values as needed

        // Set the title of the chart
        chartView.chartDescription.text = "Max Score Platform per Date"
        chartView.chartDescription.textAlign = .right
        chartView.chartDescription.position = CGPoint(x: chartView.bounds.width - 70, y: 16)
        chartView.chartDescription.font = .systemFont(ofSize: 14)

        // Update the chart view
        chartView.notifyDataSetChanged()
    }

    
    @objc func showDatePicker(cell: CustomCollectionViewCell) {
        let alertController = UIAlertController(title: "Sélectionnez une période", message: nil, preferredStyle: .alert)

        let startDatePicker = UIDatePicker()
        startDatePicker.datePickerMode = .date
        startDatePicker.preferredDatePickerStyle = .compact

        let endDatePicker = UIDatePicker()
        endDatePicker.datePickerMode = .date
        endDatePicker.preferredDatePickerStyle = .compact

        alertController.view.addSubview(startDatePicker)
        alertController.view.addSubview(endDatePicker)

        let spacingView = UIView() // Empty view for spacing
        spacingView.translatesAutoresizingMaskIntoConstraints = false
        alertController.view.addSubview(spacingView)

        startDatePicker.translatesAutoresizingMaskIntoConstraints = false
        endDatePicker.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            startDatePicker.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 50),
            startDatePicker.leadingAnchor.constraint(equalTo: alertController.view.leadingAnchor, constant: 20),

            endDatePicker.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 50),
            endDatePicker.trailingAnchor.constraint(equalTo: alertController.view.trailingAnchor, constant: -20)
        ]

        NSLayoutConstraint.activate(constraints)

        // Add spacing constraints
        NSLayoutConstraint.activate([
            endDatePicker.leadingAnchor.constraint(equalTo: startDatePicker.trailingAnchor, constant: 20),
            endDatePicker.widthAnchor.constraint(equalTo: startDatePicker.widthAnchor),

            spacingView.topAnchor.constraint(equalTo: startDatePicker.bottomAnchor, constant: 8),
            spacingView.leadingAnchor.constraint(equalTo: alertController.view.leadingAnchor),
            spacingView.trailingAnchor.constraint(equalTo: alertController.view.trailingAnchor),
            spacingView.bottomAnchor.constraint(equalTo: alertController.view.bottomAnchor, constant: -30)
        ])

        alertController.addAction(UIAlertAction(title: "Done", style: .default, handler: { _ in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            
            let startDateString = dateFormatter.string(from: startDatePicker.date)
            let endDateString = dateFormatter.string(from: endDatePicker.date)
            
            // Convert start and end date strings to timestamps
            if let startDate = dateFormatter.date(from: startDateString) {
                self.startDateTimestamp = startDate.timeIntervalSince1970
            }
            if let endDate = dateFormatter.date(from: endDateString) {
                self.endDateTimestamp = endDate.timeIntervalSince1970
            }
            
            self.dateTF.text = "Du \(startDateString) Au \(endDateString)"
            
            // Call the function to fetch and process the max scores data
            self.fetchAndProcessMaxScores { maxScoresData in
                // Handle the max scores data or any errors if needed
                // You can update the chart view here if necessary
            }
        }))

        present(alertController, animated: true, completion: nil)
       }

    func getBackgroundImageST(forMentalState mentalState: String?) -> UIImage? {
        if let state = mentalState {
            if state == "happy" {
                return UIImage(named: "green")
            } else if state == "stress" {
                return UIImage(named: "red")
            }
        }
        return UIImage(named: "green")
    }
    
    func getBackgroundImage(for score: Int?) -> (UIImage?, String) {
        if let scoreValue = score {
            if scoreValue < 20 {
                return (UIImage(named: "green"), "Non Harcelé")
            } else if scoreValue >= 20 && scoreValue < 50 {
                return (UIImage(named: "orange"), "Partiellement Harcelé")
            } else {
                return (UIImage(named: "red"), "Harcelé")
            }
        } else {
            return (UIImage(named: "green"), "Non Harcelé")
        }
    }

}

class DateAxisValueFormatter: NSObject, AxisValueFormatter {
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter
    }()
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let date = Date(timeIntervalSince1970: value)
        return dateFormatter.string(from: date)
    }
}
