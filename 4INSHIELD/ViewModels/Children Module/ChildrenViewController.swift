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
    
    var childrenArray = [Child]()
    var selectedChild: Child?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
//        getCurrentUserChildren()
        configureTableView()
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
    
    func gotoScreen(storyBoardName: String, stbIdentifier: String) {
        let storyboard = UIStoryboard(name: storyBoardName, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: stbIdentifier) as! UINavigationController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
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
        tableView.separatorStyle = .none
    }
    
    
    @IBAction func infoBtnTapped(_ sender: Any) {
//        let alertController = UIAlertController(title: "4INSHIELD", message: "Swipe left to manage (Delete or update) your children list", preferredStyle: .alert)
//        alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
//        present(alertController, animated: true, completion: nil)
        self.gotoScreen(storyBoardName: "Profile", stbIdentifier: "userProfile")
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
            if let photo = child.photo, !photo.isEmpty {
                var photoUrl = photo
                if let range = photo.range(of: "http") {
                    photoUrl.insert("s", at: range.upperBound)
                }
                cell.childAvatar.loadImage(photoUrl)
            } else {
                if child.gender == "M" {
                    cell.childAvatar.image = UIImage(imageLiteralResourceName: "malePic")
                } else {
                    cell.childAvatar.image = UIImage(imageLiteralResourceName: "femalePic")
                }
            }
            cell.childFullName.text = child.first_name.uppercased() + " " + child.last_name.uppercased()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedChild = childrenArray[indexPath.row]
        print(selectedChild.id)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let child = self.childrenArray[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
            
            let alert = UIAlertController(title: nil, message: "Are you sure, you want remove this child from your list?", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Yes, sure", style: .destructive, handler: { _ in
                self.childrenArray.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                APIManager.shareInstance.deleteChild(withID: child.id)
                print("You have deleted element \(child.first_name)")
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel ,handler: { _ in self.tableView.reloadData()}))
            self.present(alert, animated: true, completion: nil)
        }
        deleteAction.image = UIImage(systemName: "trash.fill")
        deleteAction.backgroundColor =  .systemRed
        
        let updateAction = UIContextualAction(style: .normal, title: "Update") { (action, view, handler) in
            UserDefaults.standard.set(child.id, forKey: "childID")
            print(child.id)
            
            let storyboard = UIStoryboard(name: "UpdateChild", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "updateChild")
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
        
        updateAction.image = UIImage(systemName: "rectangle.and.pencil.and.ellipsis")
        updateAction.backgroundColor = Colrs.bgColor
        
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, updateAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
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
