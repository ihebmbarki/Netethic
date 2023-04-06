//
//  ChildrenViewController.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 5/4/2023.
//

import UIKit
import Foundation

class ChildrenViewController: UIViewController {
    @IBOutlet weak var exitBtnLbl: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backBtn: UIBarButtonItem!
    
    private let btn: UIButton = {
        let button = UIButton()
//        button.layer.masksToBounds = true
        button.layer.cornerRadius = 25
        button.backgroundColor = Colrs.bgColor
        let img = UIImage(systemName: "plus")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 24, weight: .semibold))
        button.setImage(img, for: .normal)
        button.tintColor = .white
        button.setTitleColor(.blue, for: .normal)
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.3
        return button
    }()
    
    var childrenArray = [Child]()
    var selectedChild: Child?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureUI()
        getCurrentUserChildren()
        configureTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let btn = UIButton()
        view.addSubview(btn)
        btn.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingBottom: 20, paddingRight: 8, width: 50, height: 50)


//        btn.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingBottom: 20, paddingRight: 8, width: 50, height: 50)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.getCurrentUserChildren()
            guard let userIDString = UserDefaults.standard.string(forKey: "userID"),
                  let userID = Int(userIDString) else {
                print("User ID not found")
                return
            }

            let date = Date()
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            let dateString = df.string(from: date)

            let x = [
                "user": userID,
                "wizard_step": 6,
                "platform": "mobile",
                "date": dateString
            ] as [String : Any]
            let journey = UserJourney(dictionary: x)
            
            APIManager.shareInstance.saveUserJourney(journeyData: journey) { userJourney in
                print(userJourney)
            }
        }
    }

    
    func getCurrentUserChildren() {
        guard let username = UserDefaults.standard.string(forKey: "username") else { return }
            APIManager.shareInstance.fetchCurrentUserChildren(username: username) { children in
                self.childrenArray = children
                    self.tableView.reloadData()
//                print("\(children)")
                self.verifyChildList(childrenList: children)
        }
    }
    
    func configureUI() {
        navigationItem.rightBarButtonItem = nil
        navigationItem.leftBarButtonItem = nil
        guard let username = UserDefaults.standard.string(forKey: "username") else { return }
        print(username)
        view.addSubview(btn)
        btn.addTarget(self, action: #selector(addChildd), for: .touchUpInside)
    }
    
    func gotoScreen(storyBoardName: String, stbIdentifier: String) {
        let storyboard = UIStoryboard(name: storyBoardName, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: stbIdentifier) as! UINavigationController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
      @objc func addChildd() {
        print("Add child btn got tapped")
          gotoScreen(storyBoardName: "Main", stbIdentifier: "childInfos")
    }
    
    func verifyChildList(childrenList: [Child]) {
        if childrenList.count > 0 {
            // Children list is not empty, do nothing.
        } else {
            let alertController = UIAlertController(title: "4INSHIELD", message: "Your children list is empty!\nTo add a new child please click on the button (+) at the bottom right", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }

    //register tableView Cell
    func configureTableView(){
//        tableView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "ChildTableViewCell", bundle: nil), forCellReuseIdentifier: "ChildCell")
    }
    
}

extension ChildrenViewController:  UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Table view data source
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return childrenArray.count
    }
    
    
    
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChildCell", for: indexPath) as! ChildTableViewCell

        let child = childrenArray[indexPath.row]
          DispatchQueue.main.async {
              if (child.photo ?? "").isEmpty {
                  if child.gender == "M" {
                      cell.childAvatar.image = UIImage(imageLiteralResourceName: "malePic")
                  } else {
                      cell.childAvatar.image = UIImage(imageLiteralResourceName: "femalePic")
                  }
              } else {
                  cell.childAvatar.loadImage(child.photo)
              }
                cell.childFullName.text = child.first_name.uppercased() + " " + child.last_name.uppercased()
          }
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedChild = childrenArray[indexPath.row]
        print(selectedChild.id)
        
//        Services.shared.fetchChildDevices(withID: selectedChild.id) { devices in
//            let _ : Bool = KeychainWrapper.standard.set(selectedChild.first_name, forKey: "childName")
//            let _ : Bool = KeychainWrapper.standard.set(selectedChild.id, forKey: "childID")
//
//            if devices.isEmpty {
////                print("This child is not affected yet to any device")
//
//                let appearance = SCLAlertView.SCLAppearance(
//                    showCloseButton: false,
//                    showCircularIcon: true
//                )
//
//                let alertView = SCLAlertView(appearance: appearance)
//                alertView.addButton("Okey") {
//                    self.performSegue(withIdentifier: "toDashboard", sender: self)
//                }
//
//                let alertViewIcon = UIImage(named: "logo")
//                alertView.showInfo("4INSHIELD", subTitle: "No device registred for this child!!", circleIconImage: alertViewIcon)
//            } else {
//                //put this when select child
////                Services.shared.getChildAppsCategorieUsage(childID: 107) { appsCatg in
////                    let _ : Bool = KeychainWrapper.standard.set(appsCatg[0]["Board"]!, forKey: "board")
////                    let _ : Bool = KeychainWrapper.standard.set(appsCatg[1]["Communication"]!, forKey: "comm")
////                    let _ : Bool = KeychainWrapper.standard.set(appsCatg[2]["unknown"]!, forKey: "unknown")
////                }
////                Services.shared.getPlatformsToxicityDegree(childID: 2) { toxPlatform in
////                    let _ : Bool = KeychainWrapper.standard.set(toxPlatform.Twitter ?? 0, forKey: "Twitter")
////                    let _ : Bool = KeychainWrapper.standard.set(toxPlatform.Facebook ?? 5, forKey: "Facebook")
////                    let _ : Bool = KeychainWrapper.standard.set(toxPlatform.Instagram ?? 5, forKey: "Instagram")
////                    let _ : Bool = KeychainWrapper.standard.set(toxPlatform.TikTok ?? 5, forKey: "TikTok")
////                }
////
//                guard let last_dev = devices.last else {return}
//                let _ : Bool = KeychainWrapper.standard.set(last_dev.uuid, forKey: "savedDeviceID")
//                print("DEBUG: This child is using the device UID: \(last_dev.uuid)")
//                print("DEBUG: This child is using the device ID: \(last_dev.id)")
//
//                self.performSegue(withIdentifier: "toDashboard", sender: self)
//            }
//        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "toDashboard" {
//            if let vc = segue.destination as? MainDashViewController {
//                vc.child = self.selectedChild
//            }
////        } else if segue.identifier == "goToUpdateChild" {
////            if let vc = segue.destination as? ModifyChildTableViewController {
////                vc.child = self.selectedChild
////            }
//        }
//    }
    

   
     func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    
//    @available(iOS 11.0, *)
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
//    {
//        let child = self.childrenArray[indexPath.row]
//
//        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
//
//            let alert = UIAlertController(title: nil, message: "Are you sure, you want remove this child from your list?", preferredStyle: .actionSheet)
//            alert.addAction(UIAlertAction(title: "Yes, sure", style: .destructive, handler: { _ in
//                self.childrenArray.remove(at: indexPath.row)
//                self.tableView.deleteRows(at: [indexPath], with: .fade)
//                Services.shared.deleteChild(withID: child.id)
//                print("DEBUG: u've deleted element \(child.first_name)")
//            }))
//            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel ,handler: { _ in self.tableView.reloadData()}))
//            self.present(alert, animated: true, completion: nil)
//        }
//        deleteAction.image = UIImage(systemName: "trash.fill")
//        deleteAction.backgroundColor =  .systemRed
//
//        let updateAction = UIContextualAction(style: .normal, title: "Update") { (action, view, handler) in
//            let _ : Bool = KeychainWrapper.standard.set(child.id, forKey: "childID")
//            print(child.id)
//
////            self.performSegue(withIdentifier: "goToUpdateChild", sender: self)
//
//            self.gotoScreen(storyBoardName: "ModifyChild", stbIdentifier: "ModifyChildSB")
//
//        }
//        updateAction.image = UIImage(systemName: "rectangle.and.pencil.and.ellipsis")
//        updateAction.backgroundColor = Colrs.bgColor
//
//
//        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, updateAction])
//        configuration.performsFirstActionWithFullSwipe = false
//        return configuration
//    }
    
    
  
}

extension UIButton {
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight: CGFloat = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil) {
        self.imageView?.anchor(top: top, left: left, bottom: bottom, right: right, paddingTop: paddingTop, paddingLeft: paddingLeft, paddingBottom: paddingBottom, paddingRight: paddingRight, width: width, height: height)
    }
}
