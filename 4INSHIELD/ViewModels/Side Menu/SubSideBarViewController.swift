import UIKit

class SubSideBarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var subSideMenuTableView: UITableView!
    var preferredWidth: CGFloat = 0.0
    
    var delegate: SideBarDelegate?
    var defaultHighlightedCell: Int = 0
    var langue = "fr"
    var subMenu1 = ["Mon profil", "Configuration des notifications", "Changer le mot de passe"]
    var subMenu2 = ["My profile ", "Notification Settings", "Change password "]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.frame.size.width = preferredWidth
        subSideMenuTableView.delegate = self
        subSideMenuTableView.dataSource = self
        subSideMenuTableView.separatorStyle = .none
        
        DispatchQueue.main.async {
            let defaultRow = IndexPath(row: self.defaultHighlightedCell, section: 0)
            self.subSideMenuTableView.selectRow(at: defaultRow, animated: false, scrollPosition: .none)
        }
        
        subSideMenuTableView.register(UINib.init(nibName: "SubSideTableViewCell", bundle: nil), forCellReuseIdentifier: "SubSideTableViewCell")
        subSideMenuTableView.separatorStyle = .none
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // Set the width of the view during layout
        self.view.frame.size.width = preferredWidth
    }
    func translate(langue: String){
        if langue == "fr"{
            var subMenu1 = ["Mon profil", "Configuration des notifications", "Changer le mot de passe"]
        }
        if langue  == "en"{
            var subMenu2 = ["My profile ", "Notification Settings", "Change password "]
//            subSideMenuTableView.reloadData()
        }
    }
    
    func gotoScreen(storyBoardName: String, stbIdentifier: String) {
        let storyboard = UIStoryboard(name: storyBoardName, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: stbIdentifier) as! UINavigationController
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func paramButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subMenu1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubSideTableViewCell", for: indexPath) as! SubSideTableViewCell
        
        
        // Set the text color, font, and style for the text label

        cell.titleLabel.text = subMenu1[indexPath.row]

        if langue == "fr"{
            cell.titleLabel.text = subMenu1[indexPath.row]
   
        }else
        if langue == "en"{
            cell.titleLabel.text = subMenu2[indexPath.row]
        }
        return cell
    }

    // Adjust cell appearance when displaying
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        cell.textLabel?.textColor = UIColor.black
//        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 10)
//    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
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

