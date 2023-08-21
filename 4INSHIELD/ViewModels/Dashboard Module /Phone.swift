
//

import UIKit
import FSCalendar

class Phone: UIViewController{
    
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter
    }()
    
    @IBOutlet weak var childInfoContainerView: UIView!
    @IBOutlet weak var sideMenuBtn: UIBarButtonItem!
    
    @IBOutlet weak var carteCollectionView: UICollectionView!
    
    @IBOutlet weak var childButton: UIButton!
    
    @IBOutlet weak var DateTF: UITextField!
    @IBOutlet weak var bonjourLabel: UILabel!
    @IBOutlet weak var changeLangageButton: UIButton!
    
    @IBOutlet weak var calenderButton: UIButton!
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
    var ChildInfoViewController: ChildInfoViewController?
    let carteArray1 = ["7", "7", "4", "2"]
    let imageArray = ["phone-time-card-orange", "phone-time-card-rouge", "phone-time-card-vert", "sleep-phone-time-rouge"]
    let carteArray2 = ["DUBOIT passe beaucoup trop de temps sur son télephone", "DUBOIT ne dort pas bien", "", "Convenable"]
    
    var selectedChild: Childd?
    var startDate: Date?
    var endDate: Date?
    var typeCarte = String()
    var nbJour = Int()
    var sharedDateModel = SharedDateModel.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        print(selectedChild?.id)
        addConstant()
        dateWeek()
        setupdateTF()
        //partage date
        NotificationCenter.default.addObserver(self, selector: #selector(updateDateTF), name: Notification.Name("DatesSelected"), object: nil)
        
        calenderButton.addTarget(self, action: #selector(showDatePicker), for: .touchUpInside)
        childButton.addTarget(self, action: #selector(childButtonTapped), for: .touchUpInside)
        //Registre Cell
        self.carteCollectionView.register(UINib(nibName: "UsageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "UsageCollectionViewCell")
        
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
            let childID = UserDefaults.standard.string(forKey: "childID")!

            usagePhone()
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
        // Default Main View Controller
        //        showViewController(viewController: UINavigationController.self, storyboardId: "HomeNavID")
        ChildInfoViewController = storyboard.instantiateViewController(withIdentifier: "ChildInfoViewController") as? ChildInfoViewController
        
              //Set up child profile pic
        loadChildInfo()
        let childID = UserDefaults.standard.string(forKey: "childID")!

        guard let fullPhotoUrl = UserDefaults.standard.string(forKey: "photoUrl") else { return }

            if let url = URL(string: fullPhotoUrl) {
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if let data = data {
                        DispatchQueue.main.async {
                            let imageView = UIImageView(image: UIImage(data: data))
                            imageView.contentMode = .scaleAspectFill
                            imageView.translatesAutoresizingMaskIntoConstraints = false
                            imageView.layer.cornerRadius = 20 // half of 36
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
        // Add target action to child button
        childButton.addTarget(self, action: #selector(childButtonTapped), for: .touchUpInside)
        
    }
    deinit {
            NotificationCenter.default.removeObserver(self)
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
    func usagePhone(){
        ApiManagerAdd.shareInstance1.getPhoneUsageForChart(childID: 7, statisticsData: false) { Phoneuse in
            if let Phoneuse = Phoneuse {
                // Utilisez les données reçues dans la variable phoneUsage
                print("Usage Phone Per Day:", Phoneuse.usage_phone_per_day)
                print("Average:", Phoneuse.average)
                print("label", Phoneuse.limitExcededStatus.label)
                self.typeCarte = Phoneuse.limitExcededStatus.label
                // ... Faites ce que vous voulez avec les données
            } else {
                print("Unable to fetch phone usage data.")
            }
        }
    }
    func setupdateTF(){
        //Set up date textfield
        DateTF.layer.masksToBounds = false
        DateTF.layer.masksToBounds = false
        DateTF.layer.shadowColor = UIColor.gray.cgColor
        DateTF.layer.shadowOpacity = 0.5
        DateTF.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    @objc func updateDateTF() {
            if let startDate = sharedDateModel.startDate, let endDate = sharedDateModel.endDate {
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "fr")
                dateFormatter.dateFormat = "dd-MM-yyyy"
                dateFormatter.dateStyle = .medium
                
                let startDateString = dateFormatter.string(from: startDate)
                let endDateString = dateFormatter.string(from: endDate)
                
                DateTF.text = "Du \(startDateString) Au \(endDateString)"
      
                
            }
        }
    func addConstant(){
//        Set up first name
        guard let firstName = UserDefaults.standard.string(forKey: "firstName") else { return }
        self.bonjourLabel.text = "Bonjour \(firstName) !"
        //Set up child profile pic
        loadChildInfo()
        // Load child photo
        if let photoUrl = UserDefaults.standard.string(forKey: "photoUrl") as? String {
            print("Retrieved integer:", photoUrl)
        
        // Concaténation de l'URL de base avec la partie de l'URL de la photo
            let fullPhotoUrl = BuildConfiguration.shared.WEBERVSER_BASE_URL + photoUrl
            print("URL complète : \(fullPhotoUrl)")

            if let url = URL(string: fullPhotoUrl) {
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if let data = data {
                        DispatchQueue.main.async {
                            let imageView = UIImageView(image: UIImage(data: data))
                            imageView.contentMode = .scaleAspectFill
                            imageView.translatesAutoresizingMaskIntoConstraints = false
                            imageView.layer.cornerRadius = 20 // half of 36
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
        else {
            print("No photo url")
        }
    }
    
    func loadChildInfo() {
        guard let selectedChild = selectedChild else { return }

        if let imageName = UserDefaults.standard.string(forKey: "imageName") as? String {
            print("imageName:", imageName)
            let image = UIImage(named: imageName)
            childButton.setImage(image, for: .normal) // Set the image for the button
        }
    }
    func dateWeek() {
        // Récupérer la date actuelle (sysdate)
        let currentDate = Date()

        // Récupérer la date d'une semaine avant la date actuelle
        let calendar = Calendar.current
        if let oneWeekAgo = calendar.date(byAdding: .day, value: -7, to: currentDate) {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "fr")
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            // Formater les dates sans heure
            dateFormatter.timeStyle = .none
            dateFormatter.dateStyle = .medium
            
            let currentDateFormatted = dateFormatter.string(from: currentDate)
            let oneWeekAgoFormatted = dateFormatter.string(from: oneWeekAgo)
            
            let currentDateTimestamp = currentDate.timeIntervalSince1970
            let oneWeekAgoTimestamp = oneWeekAgo.timeIntervalSince1970
            
                print("Date actuelle: \(currentDateFormatted)")
                print("Timestamp actuel: \(currentDateTimestamp)")
                print("Date d'une semaine avant: \(oneWeekAgoFormatted)")
                print("Timestamp d'une semaine avant: \(oneWeekAgoTimestamp)")
            if LanguageManager.shared.currentLanguage == "fr" {
                dateFormatter.locale = Locale(identifier: "fr")
                self.DateTF.text = "Du \(currentDateFormatted) Au \(oneWeekAgoFormatted)"
            }
            if LanguageManager.shared.currentLanguage == "en" {
                dateFormatter.locale = Locale(identifier: "en")
                self.DateTF.text = "From \(currentDateFormatted) to \(oneWeekAgoFormatted)"
            }
       
        } else {
            print("Erreur lors de la récupération de la date d'une semaine avant.")
        }
    }
    
    @objc func showDatePicker() {
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
            let startDate = startDatePicker.date
            let endDate = endDatePicker.date
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            
            let startDateString = dateFormatter.string(from: startDate)
            let endDateString = dateFormatter.string(from: endDate)
            
            self.DateTF.text = "Du \(startDateString) Au \(endDateString)" // Update the text field
            
            // Update the sharedDateModel with the selected start and end dates
            self.sharedDateModel.startDate = startDate
            self.sharedDateModel.endDate = endDate
            
            // Post a notification to indicate that dates have been selected
            NotificationCenter.default.post(name: Notification.Name("DatesSelected"), object: nil)
        }))
        
        present(alertController, animated: true, completion: nil)
    }
  

    @objc func childButtonTapped() {
        guard let selectedChild = selectedChild else { return }
        
        // Add ChildInfoViewController as child view controller
        addChild(ChildInfoViewController!)
        
        // Add childInfoContainerView to the view hierarchy
        view.addSubview(childInfoContainerView)
        childInfoContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        // Set up constraints for childInfoContainerView
        NSLayoutConstraint.activate([
            childInfoContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            childInfoContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            childInfoContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            childInfoContainerView.heightAnchor.constraint(equalToConstant: 400)
        ])
        
        // Add ChildInfoViewController's view to the childInfoContainerView
        childInfoContainerView.addSubview(ChildInfoViewController!.view)
        ChildInfoViewController!.view.frame = childInfoContainerView.bounds
        
        // Notify ChildInfoViewController that it has been added to its parent view controller
        ChildInfoViewController!.didMove(toParent: self)
    }
    
    @IBAction func calenderButton(_ sender: Any) {
    }
    
    @IBAction func changeLangageButton(_ sender: Any) {
    }
    
    @IBAction func childButton(_ sender: Any) {
        // Add ChildInfoViewController as child view controller
        addChild(ChildInfoViewController!)
        print("clissssssss")
        // Add childInfoContainerView to the view hierarchy
        view.addSubview(childInfoContainerView)
        childInfoContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        // Set up constraints for childInfoContainerView
        NSLayoutConstraint.activate([
            childInfoContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            childInfoContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            childInfoContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            childInfoContainerView.heightAnchor.constraint(equalToConstant: 400)
        ])
        
        // Add ChildInfoViewController's view to the childInfoContainerView
        childInfoContainerView.addSubview(ChildInfoViewController!.view)
        ChildInfoViewController!.view.frame = childInfoContainerView.bounds
        
        // Notify ChildInfoViewController that it has been added to its parent view controller
        ChildInfoViewController!.didMove(toParent: self)
        
    }
    @IBAction func revealSideMenu(_ sender: Any) {
        self.sideMenuState(expanded: self.isExpanded ? false : true)
    }
    
    func gotoScreen(storyBoardName: String, stbIdentifier: String) {
        let storyboard = UIStoryboard(name: storyBoardName, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: stbIdentifier) as! UINavigationController
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
}

extension Phone : SideBarDelegate {
    func changeLangage(langue: String) {
    
    }
    
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
    func revealViewController() -> Phone? {
        var viewController: UIViewController? = self
        
        if viewController != nil && viewController is Phone {
            return viewController! as? Phone
        }
        while (!(viewController is Phone) && viewController?.parent != nil) {
            viewController = viewController?.parent
        }
        if viewController is Phone {
            return viewController as? Phone
        }
        return nil
    }
}

//MARK: Gesture Recognizer Delegate
extension Phone: UIGestureRecognizerDelegate {
    
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


extension Phone: UICollectionViewDelegate{

    
}

extension Phone: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let carteCell = carteCollectionView.dequeueReusableCell(withReuseIdentifier: "UsageCollectionViewCell", for: indexPath) as! UsageCollectionViewCell
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"

        if let startDate = SharedDateModel.shared.startDate,
           let endDate = SharedDateModel.shared.endDate {
            
            let days = startDate.calculateDaysBetweenDates(endDate: endDate)
            nbJour = days
            print("Nombre de jours entre les dates:", days)
        } else {
            print("Les dates ne sont pas disponibles dans SharedDateModel")
        }



        if indexPath.row == 0 {
            if typeCarte == "Excessive"{
                carteCell.setData(text: String(nbJour), image: "phone-time-card-rouge", phrase: " passe beaucoup trop de temps sur son téléphone.")
            }
            if typeCarte == "Normal"{
                carteCell.setData(text: "aaaaaa", image: "phone-time-card-vert", phrase: " ne passe pas trop de temps sur son téléphone.")
            }
            if typeCarte == "Abnormal"{
                carteCell.setData(text: "aaaaaa", image: "phone-time-card-orange", phrase: "a tendance à passer trop de temps sur son téléphone.")
            }
        }else{
            carteCell.setData(text: self.carteArray1[indexPath.row], image: self.imageArray[indexPath.row], phrase: self.carteArray2[indexPath.row])
        }
        return carteCell
    }
    
}

