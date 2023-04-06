////
////  childListTest.swift
////  4INSHIELD
////
////  Created by iheb mbarki on 6/4/2023.
////
//
//import UIKit
//import Foundation
//
//class childListTest: UIViewController, UITableViewDelegate, UITableViewDataSource {
//    
//    @IBOutlet weak var tableView: UITableView!
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return childrenArray.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ChildCell", for: indexPath) as! ChildTvCell
//        
//        let child = childrenArray[indexPath.row]
//        if (child.photo ?? "").isEmpty {
//            if child.gender == "M" {
//                cell.childAvatar.image = UIImage(imageLiteralResourceName: "malePic")
//            } else {
//                cell.childAvatar.image = UIImage(imageLiteralResourceName: "femalePic")
//            }
//        } else {
//            cell.childAvatar.loadImage(child.photo)
//        }
//        cell.childFullName.text = child.first_name.uppercased() + " " + child.last_name.uppercased()
//        
//        return cell
//    }
//
//    
//    var childrenArray = [Child]()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//        tableView.delegate = self
//        tableView.dataSource = self
//    }
//    
//    func getCurrentUserChildren() {
//        guard let username = UserDefaults.standard.string(forKey: "username") else { return }
//            APIManager.shareInstance.fetchCurrentUserChildren(username: username) { children in
//                self.childrenArray = children
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//                print("\(children)")
//                self.verifyChildList(childrenList: children)
//        }
//    }
//    
//    func verifyChildList(childrenList: [Child]) {
//        if childrenList.count > 0 {
//            // Children list is not empty, do nothing.
//        } else {
//            let alertController = UIAlertController(title: "4INSHIELD", message: "Your children list is empty!\nTo add a new child please click on the button (+) at the bottom right", preferredStyle: .alert)
//            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//            self.present(alertController, animated: true, completion: nil)
//        }
//    }
//
//
//}
