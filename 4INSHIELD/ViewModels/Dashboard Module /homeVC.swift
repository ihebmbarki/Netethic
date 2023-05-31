//
//  homeVC.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 15/3/2023.
//

import UIKit
import Foundation
import Charts

class homeVC: UIViewController, ChartViewDelegate {
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter
    }()
    
    var selectedChild: Child?
    var platforms: [Platform]?
    var ChildInfoViewController: ChildInfoViewController?
    var startDate: Date?
    var endDate: Date?

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
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var calendarBtn: UIButton!
//    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var cardsCollectionView: UICollectionView!
    @IBOutlet weak var dangerCollectionView: UICollectionView!
    
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var scoreLbl: UILabel!
    @IBOutlet weak var current_harLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set collections tags
        cardsCollectionView.tag = 1
        dangerCollectionView.tag = 2

        
        // Set initial visibility to hidden
        scoreLbl.isHidden = true

        // Register collection view cells classes
        cardsCollectionView.delegate = self
        cardsCollectionView.dataSource = self
        let nib = UINib(nibName: "CardCell", bundle: nil)
        cardsCollectionView.register(nib, forCellWithReuseIdentifier: "CardCell")
        
        dangerCollectionView.dataSource = self
        dangerCollectionView.delegate = self
        let nib2 = UINib(nibName: "DangerCardCell", bundle: nil)
        dangerCollectionView.register(nib2, forCellWithReuseIdentifier: "DangerCell")
        
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
        
        current_harLbl.text = NSLocalizedString("current_har", tableName: nil, bundle: bundle, value: "", comment: "")
        scoreLbl.text = NSLocalizedString("max_score", tableName: nil, bundle: bundle, value: "", comment: "")

        // Translate the text labels in the collection view cells
        for cell in cardsCollectionView.visibleCells {
            if let cell = cell as? CustomCollectionViewCell {
                if let indexPath = cardsCollectionView.indexPath(for: cell) {
                    switch indexPath.row {
                    case 0:
                        cell.cardDesc.text = NSLocalizedString("current_har", tableName: nil, bundle: bundle, value: "", comment: "HARCÈLEMENT ACTUEL")
//                        let (backgroundImage, cardTitle) = self.getBackgroundImage(for: score?.global_score)
//                        cell.cardTitle.text = cardTitle
                    case 1:
                        cell.cardDesc.text = NSLocalizedString("future_har", tableName: nil, bundle: bundle, value: "", comment: "RISQUE FUTUR HARCÈLEMENT")
                    case 2:
                        cell.cardDesc.text = NSLocalizedString("etat_mental", tableName: nil, bundle: bundle, value: "", comment: "ÉTAT MENTAL")
                    default:
                        break
                    }
                }
            }
        }
    }
    
    @objc func childButtonTapped() {
        guard let selectedChild = selectedChild else { return }
        
        // Add ChildInfoViewController as child view controller
        addChild(ChildInfoViewController!)
        ChildInfoViewController?.view.frame = contentView.bounds
        contentView.addSubview(ChildInfoViewController!.view)
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

    // Update platforms data and reload collection view section
       func updatePlatformsData(withPlatforms platforms: [Platform]?, in collectionView: UICollectionView) {
           self.platforms = platforms
           DispatchQueue.main.async {
               collectionView.reloadData() // Reload the entire collection view instead of specific sections
           }
       }

    // Fetch platforms data and call updatePlatformsData when data is available
    func fetchPlatformsData(for collectionView: UICollectionView) {
        APIManager.shareInstance.getPlatforms(withID: selectedChild!.id) { platforms in
            self.updatePlatformsData(withPlatforms: platforms, in: collectionView)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 1 {
            // Dequeue the cell
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as? CustomCollectionViewCell else {
                fatalError("Unable to dequeue CustomCollectionViewCell")
            }
            
            // Assign the description and logo based on indexPath or any other logic
            switch indexPath.item {
            case 0:
                cell.cardDesc.text = NSLocalizedString("current_har", comment: "HARCÈLEMENT ACTUEL")
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
                        let (_, translatedString) = self.getBackgroundImage(for: score?.global_score)
                        cell.cardTitle.text = translatedString
                    }
                }
                
            case 1:
                cell.cardDesc.text = NSLocalizedString("future_har", comment: "RISQUE FUTUR HARCÈLEMENT")
                cell.cardLogo.image = UIImage(named: "RISQUE_FUTUR")
                cell.containerView.backgroundColor = UIColor(patternImage: UIImage(named: "orange")!)
            case 2:
                cell.cardDesc.text = NSLocalizedString("etat_mental", comment: "ÉTAT MENTAL")
                cell.cardLogo.image = UIImage(named: "ETAT_MENTAL")
                
                // Call the fetchAndProcessMentalState function to fetch and process the mental state data
                fetchAndProcessMentalState(cell: cell)
            default:
                break
            }
            
            return cell
            
        } else   if collectionView.tag == 2 {
            // Dequeue the cell
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DangerCell", for: indexPath) as? DangerCollectionViewCell else {
                fatalError("Unable to dequeue DangerCollectionViewCell")
            }
            
            if let platforms = self.platforms, indexPath.item < platforms.count {
                // Configure the cell with the platform data
                let platform = platforms[indexPath.item]
                if let logoURL = platform.logo {
                    let httpsURLString = logoURL.replacingOccurrences(of: "http://", with: "https://")
                    if let httpsURL = URL(string: httpsURLString) {
                        URLSession.shared.dataTask(with: httpsURL) { data, response, error in
                            if let error = error {
                                print("Error downloading image: \(error.localizedDescription)")
                                return
                            }
                            
                            if let data = data, let image = UIImage(data: data) {
                                DispatchQueue.main.async {
                                    cell.cardLogo.image = image
                                }
                            }
                        }.resume()
                    }
                } else {
                    cell.cardLogo.image = nil
                }
            } else {
                // Handle no data available
                cell.cardTitle.text = "No Data Available"
                cell.cardLogo.image = nil
            }
            
            return cell
        }
        
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1 {
            return 3
        } else if collectionView.tag == 2 {
            // Return the count of platforms if available, otherwise 0
            return 3
        }

        return 0
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
    
    func fetchAndProcessMaxScores(startDate: Date, endDate: Date, startDateTimestamp: TimeInterval, endDateTimestamp: TimeInterval, completion: @escaping ([String: Int]?, [String]) -> Void) {
        // Fetch the required parameters for the API request (e.g., childID)
        let childID = selectedChild?.id ?? 0
        
        // Create a calendar instance to perform date calculations
        let calendar = Calendar.current
        
        // Calculate the number of days between the start and end dates
        let numberOfDays = calendar.dateComponents([.day], from: startDate, to: endDate).day ?? 0
        
        // Create an array to store the dates between the start and end dates
        var dates: [String] = []
        
        // Create a date formatter instance
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        // Iterate through the number of days and add each date to the array
        if numberOfDays >= 0 {
            for day in 0...numberOfDays {
                if let date = calendar.date(byAdding: .day, value: day, to: startDate) {
                    let dateString = dateFormatter.string(from: date)
                    dates.append(dateString)
                }
            }
        }
        
        // Call the getMaxScoresPerDate function with the parameters
        APIManager.shareInstance.getMaxScorePerDate(childID: childID, startDateTimestamp: startDateTimestamp, endDateTimestamp: endDateTimestamp) { maxScoresData in
            // Process and handle the maxScoresData as needed
            
            // Pass the processed maxScoresData and dates to the completion handler
            completion(maxScoresData, dates)
            
            // Update the chart with the processed data
            self.displayMaxScoresLineChart(maxScoresData: maxScoresData, dates: dates)
        }
    }
    
    func displayMaxScoresLineChart(maxScoresData: [String: Int]?, dates: [String]) {
        var entries: [ChartDataEntry] = []
        
        for (index, date) in dates.enumerated() {
            let score = maxScoresData?[date] ?? 0
            let entry = ChartDataEntry(x: Double(index), y: Double(score))
            entries.append(entry)
        }
        
        let dataSet = LineChartDataSet(entries: entries, label: "Max Score platform per Date")
        dataSet.mode = .linear
        dataSet.lineWidth = 2.0
        dataSet.setColor(UIColor.orange)
        dataSet.fillColor = UIColor.orange.withAlphaComponent(0.5)
        dataSet.fillAlpha = 0.5
        dataSet.drawFilledEnabled = true
        dataSet.circleRadius = 4.0
        dataSet.circleColors = [UIColor.orange]
        dataSet.drawCircleHoleEnabled = true
        dataSet.circleHoleColor = UIColor.white
        
        //Add Description
        let description = Description()
        description.text = "Max Scores per Date"
        description.textAlign = .right
        description.position = CGPoint(x: chartView.bounds.width - 80, y: 16)
        description.font = UIFont.systemFont(ofSize: 12)
        description.textColor = UIColor.black
        
        chartView.chartDescription = description
        
        let data = LineChartData(dataSet: dataSet)
        
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dates)
        chartView.xAxis.granularity = 1
        chartView.xAxis.labelCount = dates.count
        chartView.xAxis.labelFont = UIFont.systemFont(ofSize: 12)
        chartView.xAxis.labelTextColor = UIColor.black
        
        chartView.leftAxis.axisMinimum = 0
        chartView.xAxis.labelCount = dates.count // Set the label count to the number of dates
        //        chartView.xAxis.labelRotationAngle = -45 // Rotate the labels for better readability
        chartView.leftAxis.labelFont = UIFont.systemFont(ofSize: 12)
        chartView.leftAxis.labelTextColor = UIColor.black
        chartView.leftAxis.granularity = 0.2 // Set the granularity of the y-axis to 0.2
        chartView.leftAxis.axisMaximum = 1.2 // Set the maximum value of the y-axis to ensure proper spacing
        chartView.extraRightOffset = 40 // Add extra padding on the right side to prevent the dates from being cut off
        chartView.extraBottomOffset = 10 // Add extra padding at the bottom to prevent collisions with the x-axis labels
        
        chartView.rightAxis.enabled = false
        chartView.legend.enabled = false
        chartView.chartDescription.enabled = false
        
        chartView.data = data
        
        chartView.gridBackgroundColor = UIColor.clear
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.leftAxis.drawGridLinesEnabled = true
        chartView.leftAxis.gridLineDashLengths = [2.0, 2.0]
        chartView.leftAxis.gridColor = UIColor.lightGray
    }
    
    
    @objc func showDatePicker(cell: UICollectionViewCell, collectionView: UICollectionView, indexPath: IndexPath) {
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
        alertController.addAction(UIAlertAction(title: "Done", style: .default, handler: { [self] _ in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            
            let startDate = startDatePicker.date
            let endDate = endDatePicker.date
            print(startDate,endDate)
            print("start and end dates: \(startDate),\(endDate)")
            
            let startDateString = dateFormatter.string(from: startDate)
            let endDateString = dateFormatter.string(from: endDate)
            
            let startDateTimestamp = startDate.timeIntervalSince1970
            let endDateTimestamp = endDate.timeIntervalSince1970
            print("time stamps dates: \(startDateTimestamp),\(endDateTimestamp)")
            
            self.dateTF.text = "Du \(startDateString) Au \(endDateString)"
            
            self.scoreLbl.isHidden = !self.scoreLbl.isHidden // Toggle the visibility
            
            if collectionView == self.cardsCollectionView {
                // Call the function to fetch and process the max scores data
                self.fetchAndProcessMaxScores(startDate: startDate, endDate: endDate, startDateTimestamp: startDateTimestamp, endDateTimestamp: endDateTimestamp) { maxScoresData, dates in
                    print("Max Scores Data:", maxScoresData)
                    print("Dates:", dates)
                    
                }
            } else if collectionView == self.dangerCollectionView {
                // Call the function to retrieve the scores for the other collection view
                let childID = selectedChild?.id
                APIManager.shareInstance.getStatusPerDate(childID: childID!, startDateTimestamp: startDateTimestamp, endDateTimestamp: endDateTimestamp) { [self] scores in
                    // Check if scores are available
                    if let scores = scores {
                        let profile = scores[indexPath.item] // Retrieve the profile using indexPath.item
                        
                        // Access the score property from the profile
//                        let score = profile.score
                        
                        // Retrieve the cell from the collectionView using the indexPath
                        if let cell = collectionView.cellForItem(at: indexPath) as? DangerCollectionViewCell {
                            // Set the platform cards based on the score
                            let (backgroundImage, status) = setPlatformCards(for: scores[indexPath.item] )
                            
                            // Assign the image and status to the cell's container view and title label
                            DispatchQueue.main.async {
                                cell.containerView.backgroundColor = UIColor(patternImage: backgroundImage!)
                                cell.cardTitle.text = status
                            }
                        }
                    } else {
                        // Handle the case when scores is nil
                        if let cell = collectionView.cellForItem(at: indexPath) as? DangerCollectionViewCell {
                            cell.cardTitle.text = "No data"
                            cell.containerView.backgroundColor = UIColor(patternImage: UIImage(named: "green")!)
                        }
                    }
                }
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
        let bundle = Bundle.main.path(forResource: LanguageManager.shared.currentLanguage, ofType: "lproj").flatMap(Bundle.init) ?? Bundle.main
        
        if let scoreValue = score {
            if scoreValue < 20 {
                let nonHarceleLocalizedString = NSLocalizedString("non_harcele", tableName: nil, bundle: bundle, value: "", comment: "Non Harcelé")
                return (UIImage(named: "green"), nonHarceleLocalizedString)
            } else if scoreValue >= 20 && scoreValue < 50 {
                let partiellementHarceleLocalizedString = NSLocalizedString("parc_har", tableName: nil, bundle: bundle, value: "", comment: "Partiellement Harcelé")
                return (UIImage(named: "orange"), partiellementHarceleLocalizedString)
            } else {
                let harceleLocalizedString = NSLocalizedString("harcled", tableName: nil, bundle: bundle, value: "", comment: "Harcelé")
                return (UIImage(named: "red"), harceleLocalizedString)
            }
        } else {
            let nonHarceleLocalizedString = NSLocalizedString("non_harcele", tableName: nil, bundle: bundle, value: "", comment: "Non Harcelé")
            return (UIImage(named: "green"), nonHarceleLocalizedString)
        }
    }
    
    func setPlatformCards(for score : Int?) -> (UIImage?,String) {
        if let scoreValue = score {
            if scoreValue < 30 {
                return (UIImage(named: "green"),"Statut ordinaire")
            } else if scoreValue >= 30 && scoreValue < 50 {
                return (UIImage(named: "orange"),"Statut Irrégulier")
            }
            else {
                return (UIImage(named: "red"),"Statut à Risque")
            }
        } else {
            return (UIImage(named: "green"),"Statut ordinaire")
        }
    }
    
    
}
