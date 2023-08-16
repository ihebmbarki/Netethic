//
//  homeVC.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 15/3/2023.
//

import UIKit
import Foundation
import DGCharts
import AlamofireImage
import FSCalendar
import ANActivityIndicator


class homeVC: UIViewController, ChartViewDelegate {

    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter
    }()
    weak var delegateSide: SideBarDelegate?
    var selectedChild: Childd?
    var platforms: [PlatformDetail] = []
    var toxicPseudos: [String] = []
    // Declare a property to store the states array
    var state: State?
    var states: [StateData] = []
    var score: [ScoreResponse] = []
    var indicator: [IndicatorActiviteElement] = []
    var sharedImage: UIImage?
    var ChildInfoViewController: ChildInfoViewController?
    var startDate: Date?
    var endDate: Date?
    let signIn = SignIn()
    
    var days: [Double] = []

    
    @IBOutlet weak var messageRappotLabel: UILabel!
    @IBOutlet weak var loadingPersonIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var messageLineChart: UILabel!
    @IBOutlet weak var personIcon: UIImageView!
    @IBOutlet weak var loadingIndicatorCarte: UIActivityIndicatorView!
    
    @IBOutlet weak var lineChartView: LineChartView! {
        didSet {
            lineChartView.addShadowView(width: 2, height: 3, Opacidade: 0.1, radius: 15, shadowRadius: 5)
        }
    }
    @IBOutlet weak var moyenneGlabel: UILabel!
    @IBOutlet weak var rapportLabel: UILabel!
    @IBOutlet weak var nombrePersonneLabel: UILabel!
    
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var dangerLabel: UILabel!
    @IBOutlet weak var loadingPlatformIndicator: UIActivityIndicatorView!
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
    
    @IBOutlet weak var changeLanguageBtn: UIButton!
    
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var calendarBtn: UIButton!
    // @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var cardsCollectionView: UICollectionView!
    @IBOutlet weak var dangerCollectionView: UICollectionView!
    
    
    //@IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var humorChart: PieChartView!
    
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var scoreLbl: UILabel!
    @IBOutlet weak var current_harLbl: UILabel!
    
    @IBOutlet weak var toxicPersonsLbl: UILabel!
    
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView4: UIImageView!
    @IBOutlet weak var imageView5: UIImageView!
    @IBOutlet weak var personsBtn: UIButton!{
        didSet{
            personsBtn.applyGradient()
            personsBtn.layer.cornerRadius = moyenneButton.frame.height / 2
            personsBtn.clipsToBounds = true
        }
    }
    @IBOutlet weak var missingDataLbl: UILabel!
    @IBOutlet weak var personsCollectionView: UICollectionView!
    @IBOutlet weak var humorCollectionView: UICollectionView!
    
    @IBOutlet weak var viewLineChart: UIView!
    
    @IBOutlet weak var RisqueLabel: UILabel!
    @IBOutlet weak var viewChartRisque: UIView!
 
    @IBOutlet weak var moyenneGnLabel: UILabel!
    
    @IBOutlet weak var moyenneGView: UIView!
    
    @IBOutlet weak var moyenneButton: UIButton!{
        didSet{
            moyenneButton.applyGradient()
            moyenneButton.layer.cornerRadius = moyenneButton.frame.height / 2
            moyenneButton.clipsToBounds = true
        }
    }
    @IBOutlet weak var personneImage3Label: UILabel!
    @IBOutlet weak var personneImage2Label: UILabel!
    @IBOutlet weak var personneImage4Label: UILabel!
    @IBOutlet weak var personneImage1Label: UILabel!
    @IBOutlet weak var maxScoreLabel: UILabel!
    
    @IBOutlet weak var erroIndicatorLabel: UILabel!
    
    @IBOutlet weak var indicateurActivityindicator: UIActivityIndicatorView!
    @IBOutlet weak var rapportActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var indicateurCollectionView: UICollectionView!
    let pieChartView = PieChartView()
    let subSideBar = SubSideBarViewController()
    var background = String()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupDateTF()
        print(selectedChild?.id)
        loadingIndicator.startAnimating()
        loadingIndicator.isHidden = false
        loadingPlatformIndicator.startAnimating()
        loadingPlatformIndicator.isHidden = false
        loadingIndicatorCarte.startAnimating()
        loadingIndicatorCarte.isHidden = false

        missingDataLbl.isHidden = true
        messageLineChart.isHidden = true
        errorLbl.isHidden = true
        
        imageView1.isHidden = true
        personneImage1Label.isHidden = true
        imageView2.isHidden = true
        personneImage2Label.isHidden = true
        imageView3.isHidden = true
        personneImage3Label.isHidden = true
        personneImage4Label.isHidden = true
        imageView4.isHidden = true
        
        rapportActivityIndicator.startAnimating()
        dateWeek()
        //Set persons collection invisibility
        personsCollectionView.isHidden = true
        


        //Humor pie chart
        APIManager.shareInstance.getMentalState(childID:selectedChild?.id ?? 2, startDateTimestamp: 0, endDateTimestamp: 0) { [weak self] fetchedState in
            guard let self = self else { return }

            print("state:", fetchedState)
            if let states = fetchedState?.data{
                self.states = states
                DispatchQueue.main.async {
                    self.humorCollectionView.reloadData()
                }
            }
                        
            // Call the API to fetch platforms
            APIManager.shareInstance.fetchPlatforms(forPerson: selectedChild?.id ?? 2) { [weak self] platforms in
                guard let self = self else {
                    return
                }
              
                if let platforms = platforms?.platforms {
                    self.platforms = platforms
                    DispatchQueue.main.async {
                        self.dangerCollectionView.reloadData() // Reload the collection view after the platforms are fetched and populated
                    }
                }
                else{
                    loadingPlatformIndicator.stopAnimating()
                    loadingPlatformIndicator.isHidden = true
                  
                    errorLbl.isHidden = false
                    print("erreur platform")
                    if LanguageManager.shared.currentLanguage == "fr" {
                        self.errorLbl.text = " Il n'y a pas de données à afficher pour le moment. "
                    }
                    if LanguageManager.shared.currentLanguage == "en" {
                        self.errorLbl.text = " There Is No Data to Display at this Moment."
                    }
                }
            }
            
            APIManager.shareInstance.fetchToxicPersons(forPerson: selectedChild?.id ?? 2) { [self] pseudos in
                if let pseudos = pseudos {
                    // Update your toxic pseudos array
                    self.loadingPersonIndicator.stopAnimating()
                    self.loadingPersonIndicator.isHidden = true
                    self.toxicPseudos = pseudos
                    if self.toxicPseudos.count > 4 {
                        self.personneImage1Label.text = self.toxicPseudos[0]
                        self.personneImage2Label.text = self.toxicPseudos[1]
                        self.personneImage3Label.text = self.toxicPseudos[2]
                        self.personneImage4Label.text = self.toxicPseudos[3]
                    }
                    if self.toxicPseudos.count == 3 {
                        self.personneImage1Label.text = self.toxicPseudos[0]
                        self.personneImage2Label.text = self.toxicPseudos[1]
                        self.personneImage3Label.text = self.toxicPseudos[2]
                    }
                    if self.toxicPseudos.count == 2 {
                        self.personneImage1Label.text = self.toxicPseudos[0]
                        self.personneImage2Label.text = self.toxicPseudos[1]
                    }
                    if self.toxicPseudos.count == 1 {
                        self.personneImage1Label.text = self.toxicPseudos[0]
                    }
                }
            }
            
            // Call the API to fetch concerned relationship
            addConcernedRelationship()
            
            
            // Call the API to fetch the profile image URL
            let username = UserDefaults.standard.string(forKey: "username")!
            APIManager.shareInstance.fetchProfileImageURL(forUsername: username) { [weak self] imageURL in
                guard let self = self else { return }
            
                if let imageURL = imageURL {
                    URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
                        if let error = error {
                                  print("Error fetching image data: \(error.localizedDescription)")
                            return
                        }
                        
                        guard let httpResponse = response as? HTTPURLResponse else {
                            print("Invalid response")
                            return
                        }
                        
                        guard httpResponse.statusCode == 200 else {
                            print("Invalid response status code: \(httpResponse.statusCode)")
                            return
                        }
                        
                        guard let data = data, let image = UIImage(data: data) else {
                            print("Invalid image data")
                            return
                        }
                 
                        DispatchQueue.main.async {
                            // Set the retrieved image to the shared variable
                            self.sharedImage = image
                            // Set the retrieved image to the image views and apply corner radius
                            self.imageView1.image = image
                            self.imageView1.layer.cornerRadius = self.imageView1.frame.height / 2
                            self.imageView1.clipsToBounds = true
                            
                            self.imageView2.image = image
                            self.imageView2.layer.cornerRadius = self.imageView2.frame.height / 2
                            self.imageView2.clipsToBounds = true
                            
                            self.imageView3.image = image
                            self.imageView3.layer.cornerRadius = self.imageView3.frame.height / 2
                            self.imageView3.clipsToBounds = true
                            
                            self.imageView4.image = image
                            self.imageView4.layer.cornerRadius = self.imageView4.frame.height / 2
                            self.imageView4.clipsToBounds = true
                            
                            self.personsCollectionView.reloadData()
                        }
                    }.resume()
                }
            }
            
            //Set collections tags
            cardsCollectionView.tag = 1
            dangerCollectionView.tag = 2
            personsCollectionView.tag = 3
            humorCollectionView.tag = 4
            indicateurCollectionView.tag = 5
            
            
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
            
            personsCollectionView.dataSource = self
            personsCollectionView.delegate = self
            let nib3 = UINib(nibName: "ToxicPersonCell", bundle: nil)
            personsCollectionView.register(nib3, forCellWithReuseIdentifier: "ToxicPersonCell")
            
            humorCollectionView.dataSource = self
            humorCollectionView.delegate = self
            let nib4 = UINib(nibName: "humorCell", bundle: nil)
            humorCollectionView.register(nib4, forCellWithReuseIdentifier: "humorCell")
            
            indicateurCollectionView.delegate = self
            indicateurCollectionView.dataSource = self
            let nib5 = UINib(nibName: "IndicatorCollectionViewCell", bundle: nil)
            indicateurCollectionView.register(nib5, forCellWithReuseIdentifier: "IndicatorCollectionViewCell")
            //Set up TopView
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = topView.bounds
            gradientLayer.colors = [UIColor(red: 0.25, green: 0.56, blue: 0.80, alpha: 1.00).cgColor, UIColor(red: 0.24, green: 0.76, blue: 0.95, alpha: 1.00).cgColor]
            topView.layer.insertSublayer(gradientLayer, at: 0)
            
    
            
            //Set up persons button design
            personsBtn.applyGradient()
            personsBtn.layer.cornerRadius = personsBtn.frame.height / 2
            personsBtn.clipsToBounds = true
            
            // Set up the button's action
            calendarBtn.addTarget(self, action: #selector(showDatePicker), for: .touchUpInside)
            
            // Instantiate child view controllers from storyboard
            ChildInfoViewController = storyboard?.instantiateViewController(withIdentifier: "ChildInfoViewController") as? ChildInfoViewController
            
            //Set up first name
            guard let firstName = UserDefaults.standard.string(forKey: "firstName") else { return }
            self.BonjourLbl.text = "Bonjour \(firstName) !"
            //Set up child profile pic
            loadChildInfo()
            guard let selectedChild = selectedChild else { return }
            // Load child photo
            if let photo = selectedChild.user?.photo, !photo.isEmpty {
                var photoUrl = photo
            // Concaténation de l'URL de base avec la partie de l'URL de la photo
                let fullPhotoUrl = BuildConfiguration.shared.WEBERVSER_BASE_URL + photoUrl
                print("URL complète : \(fullPhotoUrl)")
                
                UserDefaults.standard.set(photoUrl, forKey: "photoUrl")

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
        
        updateLocalizedStrings()
        updateLanguageButtonImage()
    }
    
    func getMentalState(startDateT: Int, endDateT: Int) {
        // Call the getMentalState function to fetch the mental state data
        APIManager.shareInstance.getMentalState(childID: selectedChild?.id ?? 2, startDateTimestamp: startDateTimestamp, endDateTimestamp: endDateTimestamp) { [weak self] fetchedStates in
            guard let self = self else { return }
            
            print("states:", fetchedStates)
            // Store the fetched states in the property
            if let fetchedStates = fetchedStates {
                self.states = fetchedStates.data
                self.days = states.map { $0.date}
            }
            print("amal")
             print(fetchedStates?.data.count)
            print(days)
            print(fetchedStates?.statistic)
            self.state = fetchedStates
        }
    }
    
    func getScorePlateform(startDateT: Int, endDateT: Int) {
        // Call the fetchScore function to fetch the score data
        APIManager.shareInstance.fetchScorePlatform(childID: selectedChild?.id ?? 2, startDateTimestamp: startDateT, endDateTimestamp: endDateT) { [weak self] fetchedScore in
            print(fetchedScore?.result)
            print("")
            var listeDates: [Double] = []
            var listeMaxScore: [Int] = []
            for element in fetchedScore?.result ?? [] {
                listeDates.append(element.date)
                listeMaxScore.append(element.maxScore)
            }
            self?.setupLineChart(listeDates: listeDates, listeMaxScore: listeMaxScore)

        }
        
    }
    func getIndicatorActivite(startDateTimestamp: Double, endDateTimestamp: Double){
        ApiManagerAdd.shareInstance1.getIndicatorActivityData(personID: selectedChild?.id ?? 7, fromDateTimestamp: 1660645240, toDateTimestamp: 1692181240) { indicatorActivity in
            if let indicatorActivity = indicatorActivity {
                // Traitez les données indicatorActivity ici
                print(indicatorActivity)
                    self.indicator = indicatorActivity
                    DispatchQueue.main.async {
                        self.indicateurCollectionView.reloadData()
                    }
                }
                else{
//                    loadingPlatformIndicator.stopAnimating()
//                    loadingPlatformIndicator.isHidden = true
                  
                    self.erroIndicatorLabel.isHidden = false
                    print("Aucune donnée disponible ou erreur est survenue")
                    if LanguageManager.shared.currentLanguage == "fr" {
                        self.erroIndicatorLabel.text = " Il n'y a pas de données à afficher pour le moment. "
                    }
                    if LanguageManager.shared.currentLanguage == "en" {
                        self.erroIndicatorLabel.text = " There Is No Data to Display at this Moment."
                    }
                }
            }
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
    
    func addConcernedRelationship(){
        APIManager.shareInstance.fetchConcernedRelationship(forPerson: selectedChild?.id ?? 2) { [weak self] concernedRelationship in
            guard let self = self else { return }
            if let toxicCount = concernedRelationship {
                let toxicPersonsText = String(format: "%02d personnes", toxicCount)
                if LanguageManager.shared.currentLanguage == "fr" {
                    let toxicPersonsText = String(format: "%02d personnes", toxicCount)
                }
                if LanguageManager.shared.currentLanguage == "en" {
                    let toxicPersonsText = String(format: "%02d individuals", toxicCount)
                }
                if toxicCount == 0{
                    
                    loadingPersonIndicator.stopAnimating()
                    loadingPersonIndicator.isHidden = true
                    personsBtn.isHidden = true
                    missingDataLbl.isHidden = false
                    if LanguageManager.shared.currentLanguage == "fr" {
                        self.missingDataLbl.text = " Il n'y a pas de données à afficher pour le moment. "
                    }
                    if LanguageManager.shared.currentLanguage == "en" {
                        self.missingDataLbl.text = " There is No Data to Display at this Moment."
                    }
                }
                if toxicCount == 1{
                    imageView1.isHidden = false
                    personneImage1Label.isHidden = false
                  
                }
                if toxicCount == 2{
                    imageView1.isHidden = false
                    personneImage1Label.isHidden = false
                    imageView2.isHidden = false
                    personneImage2Label.isHidden = false
                }
                if toxicCount == 3{
                    imageView1.isHidden = false
                    personneImage1Label.isHidden = false
                    imageView2.isHidden = false
                    personneImage2Label.isHidden = false
                    imageView3.isHidden = false
                    personneImage3Label.isHidden = false
                }
                if toxicCount >= 4{
                    imageView1.isHidden = false
                    personneImage1Label.isHidden = false
                    imageView2.isHidden = false
                    personneImage2Label.isHidden = false
                    imageView3.isHidden = false
                    personneImage3Label.isHidden = false
                    imageView4.isHidden = false
                    personneImage4Label.isHidden = false
                }
                DispatchQueue.main.async {
                    self.toxicPersonsLbl.text = toxicPersonsText
                    self.personsCollectionView.reloadData()
                }
            }
        }
    }
    
    // hacrcelemnt de actuel
    func setupLineChart(listeDates: [Double]?, listeMaxScore: [Int]?) {
        let formattedDates = listeDates?.formatTimestampsToStrings(dateFormat: "yyyy-MM-dd")
        print(formattedDates)
        
        
        // Create chart entries
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<(formattedDates?.count ?? 0) {
            let dataEntry = ChartDataEntry(x: Double(i), y: Double(listeMaxScore?[i] ?? 0))
            dataEntries.append(dataEntry)
        }
        
        // Check if there are any data entries
        if dataEntries.isEmpty {
            // Hide the chart and remove any messages
            lineChartView.isHidden = false
//            lineChartView.noDataText = ""
            print("no data")
            loadingIndicator.stopAnimating()
            loadingIndicator.isHidden = true
            messageLineChart.isHidden = false
         
            if LanguageManager.shared.currentLanguage == "fr" {
                messageLineChart.text = " Il n'y a pas de données à afficher pour le moment. "
            }
            if LanguageManager.shared.currentLanguage == "en" {
                messageLineChart.text = " There Is No Data to Display at this Moment."
            }
        } else {
            // Show the chart
            lineChartView.isHidden = true
            maxScoreLabel.isHidden = false
            // Create a line dataset
            let lineDataSet = LineChartDataSet(entries: dataEntries, label: "Percentage")
            
            // Customize the line dataset
            lineDataSet.colors = [UIColor.clear] // Set the color of the line to clear (transparent)
            lineDataSet.circleColors = [UIColor.red] // Set the color of the circles (data points)
            lineDataSet.circleRadius = 5.0 // Adjust the size of the circles
            lineDataSet.circleHoleRadius = 2.5 // Adjust the size of the circle hole
            lineDataSet.drawCircleHoleEnabled = true // Enable drawing circle holes
            
            // Create line chart data
            let data = LineChartData(dataSet: lineDataSet)
            
            // Set data to the chart view
            lineChartView.data = data
            
            // Customize chart appearance
            lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: formattedDates ?? [])
            lineChartView.xAxis.labelPosition = .bottom
            lineChartView.rightAxis.enabled = false
            lineChartView.leftAxis.axisMaximum = 1.2
            lineChartView.leftAxis.axisMinimum = 0

//            lineChartView.leftAxis.labelCount = 11 // Afficher 11 étiquettes sur l'axe Y
            lineChartView.leftAxis.granularity = 0.2 // Étape de 10 pour les étiquettes de l'axe Y
            lineChartView.legend.enabled = false // Supprimer la légende
            lineChartView.xAxis.drawGridLinesEnabled = false // Supprimer les lignes verticales
            lineChartView.backgroundColor = .white
            lineChartView.legend.enabled = true
            
            lineChartView.pinchZoomEnabled = true
            lineChartView.dragEnabled = true
            lineChartView.scaleXEnabled = true
            lineChartView.scaleYEnabled = true
            
            let l = lineChartView.legend
            l.form = .line
            l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
            l.textColor = .white
            l.horizontalAlignment = .left
            l.verticalAlignment = .bottom
            l.orientation = .horizontal
            l.drawInside = false
            
            // Customize the chart description (title)
            lineChartView.chartDescription.text = "" // Remove the default chart description text
            lineChartView.drawMarkers = false // Hide the default description marker
            
            // Set the custom title position at the center of the chart
            //            let title = "Max score platform by date"
            //            let titleLabel = UILabel()
            //            titleLabel.text = title
            //            titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
            //            titleLabel.textColor = .black
            //            titleLabel.sizeToFit()
            //            titleLabel.center = CGPoint(x: 168, y: 2)
            //            linechart.addSubview(titleLabel)
            
            // Set the custom marker for data points (plus symbol)
            let customMarker = CustomMarkerView(color: UIColor.red, font: UIFont.systemFont(ofSize: 12))
            lineChartView.marker = customMarker
            
            lineChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        }
    }
    
    func updateLanguageButtonImage() {
        if let selectedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") {
            if selectedLanguage == "fr" {
                changeLanguageBtn.setImage(UIImage(named: "fr_white")?.withRenderingMode(.alwaysOriginal), for: .normal)
            } else if selectedLanguage == "en" {
                changeLanguageBtn.setImage(UIImage(named: "eng_white")?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
    }
    
    func updateLocalizedStrings() {
        let bundle = Bundle.main.path(forResource: LanguageManager.shared.currentLanguage, ofType: "lproj").flatMap(Bundle.init) ?? Bundle.main
        addConcernedRelationship()
        let bonjourString = NSLocalizedString("hello", tableName: nil, bundle: bundle, value: "", comment: "Bonjour greeting")
        let firstName = UserDefaults.standard.string(forKey: "firstName") ?? ""
        let localizedText = "\(bonjourString) \(firstName) !"
        
        BonjourLbl.text = localizedText
        dateTF.placeholder = NSLocalizedString("rangeDate", tableName: nil, bundle: bundle, value: "", comment: "rangeDate")
        
        RisqueLabel.text = NSLocalizedString("current_har", tableName: nil, bundle: bundle, value: "", comment: "")
        errorLbl.text = NSLocalizedString("msgerreur", tableName: nil, bundle: bundle, value: "", comment: "")
        missingDataLbl.text = NSLocalizedString("msgerreur", tableName: nil, bundle: bundle, value: "", comment: "")
        messageLineChart.text = NSLocalizedString("msgerreur", tableName: nil, bundle: bundle, value: "", comment: "")
        dangerLabel.text = NSLocalizedString("danger", tableName: nil, bundle: bundle, value: "", comment: "")
        nombrePersonneLabel.text = NSLocalizedString("personneToxique", tableName: nil, bundle: bundle, value: "", comment: "")
        percentageLabel.text = NSLocalizedString("number", tableName: nil, bundle: bundle, value: "", comment: "")
        rapportLabel.text = NSLocalizedString("rapport", tableName: nil, bundle: bundle, value: "", comment: "")
        moyenneGnLabel.text = NSLocalizedString("moyenne", tableName: nil, bundle: bundle, value: "", comment: "")
        personsBtn.setTitle(NSLocalizedString("tousPersonneBt", tableName: nil, bundle: bundle, value: "", comment: ""), for: .normal)
        moyenneButton.setTitle(NSLocalizedString("moyenneBt", tableName: nil, bundle: bundle, value: "", comment: ""), for: .normal)
        dateWeek()
        addConcernedRelationship()
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
    func setupDateTF(){
        //Set up date textfield
        dateTF.layer.masksToBounds = false
        dateTF.layer.masksToBounds = false
        //        dateTF.layer.cornerRadius = dateTF.bounds.height / 2
        dateTF.layer.shadowColor = UIColor.gray.cgColor
        dateTF.layer.shadowOpacity = 0.5
        dateTF.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    func MoyenneButton(_ sender: Any) {
        addChild(ChildInfoViewController!)
    }
    
    
    @IBAction func childButton(_ sender: Any) {
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
    
    
    @IBAction func personsBtnTapped(_ sender: Any) {
        personsBtn.isHidden = true
   
        personsCollectionView.isHidden = false
        self.loadingPersonIndicator.isHidden = false
        self.loadingPersonIndicator.startAnimating()
        // Call the API to fetch toxic persons
        APIManager.shareInstance.fetchToxicPersons(forPerson: selectedChild?.id ?? 2) { [self] pseudos in
            if let pseudos = pseudos {
                // Update your toxic pseudos array
                self.loadingPersonIndicator.stopAnimating()
                self.loadingPersonIndicator.isHidden = true
                // Reload the collection view to reflect the changes
                self.personsCollectionView.reloadData()
            } else {
                print("No toxic persons data")
                self.loadingPersonIndicator.stopAnimating()
                self.loadingPersonIndicator.isHidden = true
                personsCollectionView.isHidden = false
                missingDataLbl.isHidden = false
               
                if LanguageManager.shared.currentLanguage == "fr" {
                    self.missingDataLbl.text = " Il n'y a pas de données à afficher pour le moment. "
                }
                if LanguageManager.shared.currentLanguage == "en" {
                    self.missingDataLbl.text = " There is No Data to Display at this Moment."
                }

            }
        }

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
    
//    func getCurrentUserData() {
//        guard let savedUserName = UserDefaults.standard.string(forKey: "username") else { return }
//        DispatchQueue.main.async {
//            APIManager.shareInstance.fetchCurrentUserData(username: savedUserName) { user in
//                if let firstName = user.first_name {
//                   print("La variable déballée vaut \(firstName)")
//                    self.BonjourLbl.text = "Bonjour \(firstName) !"
//                }
//            }
//        }
//    }
    
    var startDateTimestamp: TimeInterval = 0
    var endDateTimestamp: TimeInterval = 0
    
    func loadChildInfo() {
        guard let selectedChild = selectedChild else { return }

        
        let imageName = selectedChild.user?.gender == "M" ? "malePic" : "femalePic"
        let image = UIImage(named: imageName)
        UserDefaults.standard.set(imageName, forKey: "imageName")



        childButton.setImage(image, for: .normal) // Set the image for the button

        if let photo = selectedChild.user?.photo, !photo.isEmpty {
            // Load the image for imageView5 from URL
            let fullPhotoUrl =  photo
            imageView5.loadImage(fullPhotoUrl) { [weak self] image in
                self?.imageView5.image = image
                self?.imageView5.layer.cornerRadius = (self?.imageView5.frame.size.width ?? 0) / 2
                self?.imageView5.clipsToBounds = true
                self?.imageView5.contentMode = .scaleAspectFit // Or another appropriate mode

            }
        }
    }


    
    func gotoScreen(storyBoardName: String, stbIdentifier: String) {
        let storyboard = UIStoryboard(name: storyBoardName, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: stbIdentifier) as! UINavigationController
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    //moyenne general
    @IBAction func moyenneButton(_ sender: Any) {
        let destination = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CustomAlertViewController") as! CustomAlertViewController
        destination.modalPresentationStyle = .overCurrentContext
        destination.valeur.append(state?.statistic.happy ?? 0)
        destination.valeur.append(state?.statistic.stress ?? 0)

        self.present(destination, animated: false, completion: nil)
    }
    @IBAction func changeButton(_ sender: Any) {
        let languages = ["English", "Français"]
        let languageAlert = UIAlertController(title: "Choisir la langue", message: nil, preferredStyle: .actionSheet)
      
        for language in languages {
            let action = UIAlertAction(title: language, style: .default) { action in
                if action.title == "English" {
                    LanguageManager.shared.currentLanguage = "en"
                    self.delegateSide?.changeLangage(langue: "en")
                    self.subSideBar.langue = "en"
                    UserDefaults.standard.set("en", forKey: "selectedLanguage")
                } else if action.title == "Français" {
                    LanguageManager.shared.currentLanguage = "fr"
                    UserDefaults.standard.set("fr", forKey: "selectedLanguage")
                    self.delegateSide?.changeLangage(langue: "fr")
                    self.subSideBar.langue = "fr"
                }
                        NotificationCenter.default.post(name: NSNotification.Name("NotificationFromB"), object: nil, userInfo: ["message": LanguageManager.shared.currentLanguage])
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
    
    
}

extension homeVC : SideBarDelegate {
    func changeLangage(langue: String) {
        print(langue)
        delegateSide?.changeLangage(langue: langue)
    }
    
    func selectedCell(_ row: Int) {
        switch row {
        case 0: break
            // Profile
//            self.gotoScreen(storyBoardName: "Profile", stbIdentifier: "userProfile")
        case 1:
            // Autorisation d’accés
            self.gotoScreen(storyBoardName: "Autorisation", stbIdentifier: "AutorisationID")
        case 2:
            // Nous contacter
            self.gotoScreen(storyBoardName: "Contact", stbIdentifier: "ContactID")
        case 3:
            // Mentions légales
            self.gotoScreen(storyBoardName: "LegalMention", stbIdentifier: "LegalMentionID")
        case 4:
            // À propos
            self.gotoScreen(storyBoardName: "Apropos", stbIdentifier: "AproposID")
        case 5:
            // Déconnexion
            // Clear user defaults
            UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
            UserDefaults.standard.synchronize()
            
            // Dismiss the current presented view controlle
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "signIn")
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
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
            if let shadowView = self.sideMenuShadowView {
                UIView.animate(withDuration: 0.5) {
                    shadowView.alpha = 0.6
                }
            }
        }
        else {
            self.animateSideMenu(targetPosition: self.revealSideMenuOnTop ? (-self.sideMenuRevealWidth - self.paddingForRotation) : 0) { _ in
                self.isExpanded = false
            }
            // Animate Shadow (Fade Out)
            if let shadowView = self.sideMenuShadowView {
                UIView.animate(withDuration: 0.5) {
                    shadowView.alpha = 0.0
                }
            }
        }
    }
    
    func animateSideMenu(targetPosition: CGFloat, completion: @escaping (Bool) -> ()) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .layoutSubviews, animations: {
            if self.revealSideMenuOnTop {
                if let constraint = self.sideMenuTrailingConstraint {
                    constraint.constant = targetPosition
                    self.view.layoutIfNeeded()
                }
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
                APIManager.shareInstance.getScore { [self] score in
                    self.loadingIndicatorCarte.stopAnimating()
                    loadingIndicatorCarte.isHidden = true
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
                self.loadingIndicatorCarte.stopAnimating()
                loadingIndicatorCarte.isHidden = true
                cell.cardDesc.text = NSLocalizedString("future_har", comment: "RISQUE FUTUR HARCÈLEMENT")
                cell.cardLogo.image = UIImage(named: "RISQUE_FUTUR")
                cell.containerView.backgroundColor = UIColor(patternImage: UIImage(named: "orange")!)
            case 2:
                self.loadingIndicatorCarte.stopAnimating()
                loadingIndicatorCarte.isHidden = true
                cell.cardDesc.text = NSLocalizedString("etat_mental", comment: "ÉTAT MENTAL")
                cell.cardLogo.image = UIImage(named: "ETAT_MENTAL")
                
                // Call the fetchAndProcessMentalState function to fetch and process the mental state data
                fetchAndProcessMentalState(cell: cell)
            default:
                break
            }
            
            return cell
            
        } else
        if collectionView.tag == 2 {
            loadingPlatformIndicator.stopAnimating()
            loadingPlatformIndicator.isHidden = true
            // Dequeue the cell
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DangerCell", for: indexPath) as? DangerCollectionViewCell else {
                fatalError("Unable to dequeue DangerCollectionViewCell")
            }
            
            let platform = platforms[indexPath.item]
            let logoURL = platform.logo.absoluteString
            
            // Check if the URL starts with "http://"
            if logoURL.hasPrefix("http://") {
                // Replace "http://" with "https://"
                let modifiedLogoURL = logoURL.replacingOccurrences(of: "http://", with: "https://")
                
                // Create a new URL from the modified string
                if let url = URL(string: modifiedLogoURL) {
                    cell.cardLogo.af.setImage(withURL: url)
                }
                //            } else {
                //                cell.cardLogo.af.setImage(withURL: platform.logo)
            }
            
            APIManager.shareInstance.fetchScore(forPlatform: platform.platform, childID: selectedChild?.id ?? 2, startDateTimestamp: Int(Double(Int(startDateTimestamp))), endDateTimestamp: Int(endDateTimestamp)) { score in
                if LanguageManager.shared.currentLanguage == "fr" {
                    if let score = score {
                        // Use the score value to determine the cardTitle
                        if score < 30 {
                            cell.cardTitle.text = "Statut ordinaire"
                            cell.containerView.backgroundColor = UIColor(patternImage: UIImage(named: "green")!)
                        } else if score >= 30 && score < 50 {
                            cell.cardTitle.text = "Statut Irrégulier"
                            cell.containerView.backgroundColor = UIColor(patternImage: UIImage(named: "orange")!)
                        } else {
                            cell.cardTitle.text = "Statut à Risque"
                            cell.containerView.backgroundColor = UIColor(patternImage: UIImage(named: "red")!)
                        }
                    }
                }
                if LanguageManager.shared.currentLanguage == "en" {
                    if let score = score {
                        // Use the score value to determine the cardTitle
                        if score < 30 {
                            cell.cardTitle.text = "ordinary statute"
                            cell.containerView.backgroundColor = UIColor(patternImage: UIImage(named: "green")!)
                        } else if score >= 30 && score < 50 {
                            cell.cardTitle.text = "irregular status"
                            cell.containerView.backgroundColor = UIColor(patternImage: UIImage(named: "orange")!)
                        } else {
                            cell.cardTitle.text = "Risk status"
                            cell.containerView.backgroundColor = UIColor(patternImage: UIImage(named: "red")!)
                        }
                    }
                }
                
                
                else {
                    // Handle error case or set a default value for the cardTitle
                    //                    cell.cardTitle.text = "No Data Platform"
                    //                    cell.containerView.backgroundColor = UIColor(patternImage: UIImage(named: "green")!)
                    self.dangerCollectionView.isHidden = true
                    self.loadingPlatformIndicator.stopAnimating()
                    self.loadingPlatformIndicator.isHidden = true
                    
                    self.errorLbl.isHidden = false
                    print("erreur platform")
                    if LanguageManager.shared.currentLanguage == "fr" {
                        self.errorLbl.text = " Il n'y a pas de données à afficher pour le moment. "
                    }
                    if LanguageManager.shared.currentLanguage == "en" {
                        self.errorLbl.text = " There Is No Data to Display at this Moment."
                    }
                    
                }
            }
            return cell
        } else
        if collectionView.tag == 3 {
            // Dequeue the cell
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ToxicPersonCell", for: indexPath) as? ToxicPersonCollectionViewCell else {
                fatalError("Unable to dequeue ToxicPersonCollectionViewCell")
            }
            loadingPlatformIndicator.stopAnimating()
            loadingPlatformIndicator.isHidden = true
            let pseudo = toxicPseudos[indexPath.item]
            cell.cardTitle.text = pseudo
            
            
            let carteCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ToxicPersonCell", for: indexPath) as! ToxicPersonCollectionViewCell
            carteCell.setData(text: self.toxicPseudos[indexPath.row], image: self.toxicPseudos[indexPath.row])
            return carteCell
            
            // Set the image to the cardLogo image view
            //            if let image = sharedImage {
            //                // Resize the image to fit within the cardLogo image view
            //                let resizedImage = image.resize(to: CGSize(width: 30, height: 30))
            //
            //                cell.cardLogo.image = resizedImage
            //            } else {
            //                // Set a placeholder image or handle the case when sharedImage is nil
            //                cell.cardLogo.image = UIImage(named: "empty")
            //            }
            //
            //            cell.cardLogo.contentMode = .scaleAspectFit
            //            cell.cardLogo.clipsToBounds = true
            
            return cell
        } else
        if collectionView.tag == 4 {
            self.rapportActivityIndicator.startAnimating()
            // Dequeue the cell
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "humorCell", for: indexPath) as? HumorCollectionViewCell else {
                fatalError("Unable to dequeue HumorCollectionViewCell")
            }
            
            // Update the UI on the main thread
            DispatchQueue.main.async {
                
                if LanguageManager.shared.currentLanguage == "fr" {
                    self.rapportActivityIndicator.stopAnimating()
                    self.rapportActivityIndicator.isHidden = true
                    if indexPath.row < self.states.count {
                        self.messageRappotLabel.text = ""

                        print("oooooo")
                        let state = self.states[indexPath.row]
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "EEE\nd" // Customize the date format as needed
                        cell.cardTitle.text = dateFormatter.string(from: Date(timeIntervalSince1970: state.date))
                        if state.mental_state == "happy" {
                            cell.cardLogo.image = UIImage(named: "smileyface")
                            cell.containerView.backgroundColor = UIColor(patternImage: UIImage(named: "Hgreen")!)
                        } else if state.mental_state == "stress" {
                            cell.cardLogo.image = UIImage(named: "angryface")
                            cell.containerView.backgroundColor = UIColor(patternImage: UIImage(named: "Hred")!)
                        } else {
                            cell.cardLogo.image = UIImage(named: "pokerface")
                            cell.containerView.backgroundColor = UIColor(patternImage: UIImage(named: "Horange")!)
                        }
                    }
                }
                if LanguageManager.shared.currentLanguage == "en" {
                    self.rapportActivityIndicator.stopAnimating()
                    self.rapportActivityIndicator.isHidden = true
                    if indexPath.row < self.states.count {
                        self.messageRappotLabel.isHidden = true

                        print("oooooo")
                        let state = self.states[indexPath.row]
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.locale = Locale(identifier: "en") // Set locale to English
                        dateFormatter.dateFormat = "EEE\nd" // Customize the date format as needed
                        
                        cell.cardTitle.text = dateFormatter.string(from: Date(timeIntervalSince1970: state.date))
                        
                        if state.mental_state == "happy" {
                            cell.cardLogo.image = UIImage(named: "smileyface")
                            cell.containerView.backgroundColor = UIColor(patternImage: UIImage(named: "Hgreen")!)
                        } else if state.mental_state == "stress" {
                            cell.cardLogo.image = UIImage(named: "angryface")
                            cell.containerView.backgroundColor = UIColor(patternImage: UIImage(named: "Hred")!)
                        } else {
//                            cell.cardLogo.image = UIImage(named: "pokerface")
//                            cell.containerView.backgroundColor = UIColor(patternImage: UIImage(named: "Horange")!)
                            self.rapportActivityIndicator.stopAnimating()
                            self.rapportActivityIndicator.isHidden = true
//                            self.messageRappotLabel.isHidden = false
                            if LanguageManager.shared.currentLanguage == "fr" {
                                self.messageRappotLabel.text = " Il n'y a pas de données à afficher pour le moment. "
                            }
                            if LanguageManager.shared.currentLanguage == "en" {
                                self.messageRappotLabel.text = " There Is No Data to Display at this Moment."
                            }
                        }
                    }
                }
                
                else {
                    // Handle the case when index path is out of bounds
                    self.rapportActivityIndicator.stopAnimating()
                    self.rapportActivityIndicator.isHidden = true
                    self.messageRappotLabel.isHidden = false
                    if LanguageManager.shared.currentLanguage == "fr" {
                        self.messageRappotLabel.text = " Il n'y a pas de données à afficher pour le moment. "
                    }
                    if LanguageManager.shared.currentLanguage == "en" {
                        self.messageRappotLabel.text = " There Is No Data to Display at this Moment."
                    }
                }
            }
            return cell
        }
        else
        if collectionView.tag == 5 {
            let cell = indicateurCollectionView.dequeueReusableCell(withReuseIdentifier: "IndicatorCollectionViewCell", for: indexPath) as! IndicatorCollectionViewCell
                
            cell.layer.cornerRadius = 10 // Ajustez la valeur selon vos besoins
                  
                  // Ajouter une ombre
                  cell.layer.shadowColor = UIColor.black.cgColor
                  cell.layer.shadowOpacity = 0.3
                  cell.layer.shadowOffset = CGSize(width: 0, height: 2)
                  cell.layer.shadowRadius = 3
            
            ApiManagerAdd.shareInstance1.getIndicatorActivityData(personID: selectedChild?.id ?? 7, fromDateTimestamp: 1660645240, toDateTimestamp: 1692181240) { indicatorActivity in
                if let indicatorActivity = indicatorActivity {
                    // Traitez les données indicatorActivity ici
                    print(indicatorActivity)
                    if indexPath.item < indicatorActivity.count {
                        let indicatorData = indicatorActivity[indexPath.item]
                        self.erroIndicatorLabel.isHidden = true
                        // Utilisez les propriétés de indicatorData pour configurer la cellule
                        let icon = indicatorData.icon
                        let toxicityRate = String(format: "%.2f", indicatorData.toxicityRate)
                        let name = indicatorData.nameFr
                        if indicatorData.toxicityRate > 0.4 {
                            self.background = "red"
                            } else if indicatorData.toxicityRate > 0.2 {
                                self.background = "orange"
                            } else {
                                self.background = "green"
                            }
                            
                        cell.setData(background: self.background, icon: icon, toxicity: toxicityRate, name: name)
                    }else{
                        self.indicateurCollectionView.isHidden = true
                        self.erroIndicatorLabel.isHidden = false
                        if LanguageManager.shared.currentLanguage == "fr" {
                            self.erroIndicatorLabel.text = " Il n'y a pas de données à afficher pour le moment. "
                        }
                        if LanguageManager.shared.currentLanguage == "en" {
                            self.erroIndicatorLabel.text = " There Is No Data to Display at this Moment."
                        }
                    }
                } else {
                    // Gérez le cas où il n'y a pas de données ou une erreur est survenue
                    self.indicateurCollectionView.isHidden = true
                    self.erroIndicatorLabel.isHidden = false
                    print("Aucune donnée disponible ou erreur est survenue")
                    if LanguageManager.shared.currentLanguage == "fr" {
                        self.erroIndicatorLabel.text = " Il n'y a pas de données à afficher pour le moment. "
                    }
                    if LanguageManager.shared.currentLanguage == "en" {
                        self.erroIndicatorLabel.text = " There Is No Data to Display at this Moment."
                    }
                 
                }
            }
    
            
            return cell
        }

        
        return UICollectionViewCell()
    }





    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1 {
            return 3
        } else if collectionView.tag == 2 {
            print(platforms.count)
            return platforms.count
        } else if collectionView.tag == 3 {
            return toxicPseudos.count
        } else if collectionView.tag == 4 {
            print(states.count)
            return states.count
          // return 10
        } else if collectionView.tag == 5{
            return 4
        }
        
        return 0
    }
    
    
    func fetchAndProcessMentalState(cell: CustomCollectionViewCell) {
        // Call the getMentalState function to fetch the mental state data`
        
        APIManager.shareInstance.getMentalState(childID: selectedChild?.id ?? 2, startDateTimestamp: startDateTimestamp, endDateTimestamp: endDateTimestamp) { states in
            // Update the UI on the main thread
            DispatchQueue.main.async {
                if let states = states?.data {
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
        print(startDateTimestamp)
        print(endDateTimestamp)
        
        getScorePlateform(startDateT: Int(startDateTimestamp), endDateT: Int(endDateTimestamp))
        getMentalState(startDateT: Int(startDateTimestamp), endDateT: Int(endDateTimestamp))
        getIndicatorActivite(startDateTimestamp: startDateTimestamp, endDateTimestamp: endDateTimestamp)
        viewDidLoad()
//        // Call the getMaxScoresPerDate function with the parameters
//        APIManager.shareInstance.getMaxScorePerDate(childID: 7, startDateTimestamp: startDateTimestamp, endDateTimestamp: endDateTimestamp) { maxScoresData in
//            // Process and handle the maxScoresData as needed
//
//            // Pass the processed maxScoresData and dates to the completion handler
//            completion(maxScoresData, dates)
            
            // Update the chart with the processed data
//            self.displayMaxScoresLineChart(maxScoresData: maxScoresData, dates: dates)
//        }
    }
    
//    func displayMaxScoresLineChart(maxScoresData: [String: Int]?, dates: [String]) {
//        var entries: [ChartDataEntry] = []
//
//        for (index, date) in dates.enumerated() {
//            let score = maxScoresData?[date] ?? 0
//            let entry = ChartDataEntry(x: Double(index), y: Double(score))
//            entries.append(entry)
//        }
//        setupLineChart()
//    }
    
    func dateWeek() {
        // Récupérer la date actuelle (sysdate)
        let currentDate = Date()

        // Récupérer la date d'une semaine avant la date actuelle
        let calendar = Calendar.current
        if let oneWeekAgo = calendar.date(byAdding: .day, value: -7, to: currentDate) {
            let dateFormatter = DateFormatter()
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
                self.dateTF.text = "Du \(currentDateFormatted) Au \(oneWeekAgoFormatted)"
            }
            if LanguageManager.shared.currentLanguage == "en" {
                self.dateTF.text = "From \(currentDateFormatted) to \(oneWeekAgoFormatted)"
            }
            getScorePlateform(startDateT: Int(currentDateTimestamp), endDateT: Int(oneWeekAgoTimestamp))
            getMentalState(startDateT: Int(currentDateTimestamp), endDateT: Int(oneWeekAgoTimestamp))
            getIndicatorActivite(startDateTimestamp: currentDateTimestamp, endDateTimestamp: oneWeekAgoTimestamp)
      
        } else {
            print("Erreur lors de la récupération de la date d'une semaine avant.")
        }
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
            
            let startDate = startDatePicker.date
            let endDate = endDatePicker.date
            print(startDate,endDate)
            print("start and end dates: \(startDate),\(endDate)")
            
            let startDateString = dateFormatter.string(from: startDate)
            let endDateString = dateFormatter.string(from: endDate)
            
            let startDateTimestamp = startDate.timeIntervalSince1970
            let endDateTimestamp = endDate.timeIntervalSince1970
            print("time stamps dates: \(startDateTimestamp),\(endDateTimestamp)")
            
            self.dateTF.text = "Du \(startDateString) Au  \(endDateString)"
            
            self.scoreLbl.isHidden = !self.scoreLbl.isHidden // Toggle the visibility
            
            // Call the function to fetch and process the max scores data
            self.fetchAndProcessMaxScores(startDate: startDate, endDate: endDate, startDateTimestamp: startDateTimestamp, endDateTimestamp: endDateTimestamp) { maxScoresData, dates in
                print("Max Scores Data:", maxScoresData)
                print("Dates:", dates)
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
extension UIImage {
    func resize(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        
        self.draw(in: CGRect(origin: .zero, size: size))
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}


extension Array where Element == Double {
    func formatTimestampsToStrings(dateFormat: String) -> [String] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat

        return self.compactMap { timestamp in
            let date = Date(timeIntervalSince1970: timestamp)
            return dateFormatter.string(from: date)
        }
    }
}
