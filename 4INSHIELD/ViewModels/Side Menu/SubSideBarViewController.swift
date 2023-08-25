import UIKit

class SubSideBarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var changeLangageButton: UIButton!
    @IBOutlet weak var paramButton: UIButton!
    @IBOutlet weak var subSideMenuTableView: UITableView!
    var preferredWidth: CGFloat = 0.0
    
    var delegate: SideBarDelegate?
//    var defaultHighlightedCell: Int = 0
    var subMenu = ["Mon profil", "Configuration des notifications", "Changer le mot de passe"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.view.frame.size.width = preferredWidth
        subSideMenuTableView.delegate = self
        subSideMenuTableView.dataSource = self
        subSideMenuTableView.separatorStyle = .none
        
//        DispatchQueue.main.async {
//            let defaultRow = IndexPath(row: self.defaultHighlightedCell, section: 0)
//            self.subSideMenuTableView.selectRow(at: defaultRow, animated: false, scrollPosition: .none)
//        }
        
        subSideMenuTableView.register(UINib.init(nibName: "SubSideTableViewCell", bundle: nil), forCellReuseIdentifier: "SubSideTableViewCell")
        subSideMenuTableView.separatorStyle = .none
    }
    
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//
//        LanguageManager.shared.currentLanguage = "fr"
//        updateLocalizedStrings()
//
//        // Set the width of the view during layout
////        self.view.frame.size.width = preferredWidth
//    }
 

    
    func gotoScreen(storyBoardName: String, stbIdentifier: String) {
        let storyboard = UIStoryboard(name: storyBoardName, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: stbIdentifier) as! UINavigationController
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    func updateLocalizedStrings() {
        let bundle = Bundle.main.path(forResource: LanguageManager.shared.currentLanguage, ofType: "lproj").flatMap(Bundle.init) ?? Bundle.main
//              paramButton.setTitle(NSLocalizedString("param", tableName: nil, bundle: bundle, value: "", comment: ""), for: .normal)
        if LanguageManager.shared.currentLanguage == "fr"{
            subMenu = ["Mon profil", "Configuration des notifications", "Changer le mot de passe"]
           
                paramButton.setTitle("Paramètres", for: .normal)
                paramButton.titleLabel?.font = UIFont(name: "System-Medium", size: 25.0)
        
            subSideMenuTableView.reloadData()
            
        }
        if LanguageManager.shared.currentLanguage == "en"{
            subMenu = ["My profile ", "Notification Settings", "Change password "]
                paramButton.setTitle("Settings", for: .normal)
                paramButton.titleLabel?.font = UIFont(name: "System-Medium", size: 25.0)
            subSideMenuTableView.reloadData()
        }

    }
    func translate() {
        let languages = ["English", "Français"]
        let languageAlert = UIAlertController(title: "Choisir la langue", message: nil, preferredStyle: .actionSheet)
        
        for language in languages {
            let action = UIAlertAction(title: language, style: .default) { [self] action in
                if action.title == "English" {
                    LanguageManager.shared.currentLanguage = "en"
                    UserDefaults.standard.set("en", forKey: "selectedLanguage")
                    self.changeLangageButton.setImage(UIImage(named: "eng_white1"), for: .normal)
                } else if action.title == "Français" {
                    LanguageManager.shared.currentLanguage = "fr"
                    UserDefaults.standard.set("fr", forKey: "selectedLanguage")
                    self.changeLangageButton.setImage(UIImage(named: "fr_white1"), for: .normal)
                }
                if LanguageManager.shared.currentLanguage == "fr"{
                    self.subMenu = ["Mon profil", "Configuration des notifications", "Changer le mot de passe"]
                    self.subSideMenuTableView.reloadData()
                    
                }
                if LanguageManager.shared.currentLanguage == "en"{
                    self.subMenu = ["My profile ", "Notification Settings", "Change password "]
                    subSideMenuTableView.reloadData()
                }
                self.updateLocalizedStrings()
                self.view.setNeedsLayout() // Refresh the layout of the view
            }
            languageAlert.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        languageAlert.addAction(cancelAction)
        
        present(languageAlert, animated: true, completion: nil)
    }
    @IBAction func paramButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func changeLanguageButton(_ sender: Any) {
        translate()
    }
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubSideTableViewCell", for: indexPath) as! SubSideTableViewCell
        
        
        // Set the text color, font, and style for the text label

        cell.titleLabel.text = subMenu[indexPath.row]
        return cell
    }

    // Adjust cell appearance when displaying
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        cell.textLabel?.textColor = UIColor.black
//        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 10)
//    }
    
    // MARK: - UITableViewDelegate
    
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0: // Mon profil
            self.gotoScreen(storyBoardName: "Profile", stbIdentifier: "userProfile")
            
        case 1: // Configuration des notifications
            // Perform action for Configuration des notifications
            // For example, display an alert
            let alertController = UIAlertController(title: "Notifications", message: "Configure notifications here.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
            
        case 2: // Changer le mot de passe
            // Perform action for Changer le mot de passe
            // For example, navigate to another screen
            let passwordChangeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PasswordChangeViewController") // Replace with the actual identifier of the view controller
            navigationController?.pushViewController(passwordChangeViewController, animated: true)
            
        default:
            break
        }
    }
}

