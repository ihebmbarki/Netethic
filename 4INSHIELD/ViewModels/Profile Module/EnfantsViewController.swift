//
//  EnfantsViewController.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 2/5/2023.
//

import UIKit

class EnfantsViewController: UIViewController {

    @IBOutlet weak var childrenTableView: UITableView!
    @IBOutlet weak var addChildBtn: UIButton!
    
    var childrenArray = [Child]()
    var decodedChildrenArray = [Childd]()
    var selectedChild: Child?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureTableView()
        childrenTableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
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
        }
    }
    
    func getCurrentUserChildren() {
        guard let username = UserDefaults.standard.string(forKey: "username") else { return }
        APIManager.shareInstance.fetchCurrentUserChildren(username: username) { children in
            self.decodedChildrenArray = children
            self.childrenTableView.reloadData()
            self.verifyChildList(childrenList: children)
        }
    }
    func verifyChildList(childrenList: [Childd]) {
        if childrenList.count > 0 {
            // Children list is not empty, do nothing.
        } else {
            let alertController = UIAlertController(title: "4INSHIELD", message: "Your children list is empty!", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    //register tableView Cell
    func configureTableView(){
        childrenTableView.delegate = self
        childrenTableView.dataSource = self
        childrenTableView.register(UINib.init(nibName: "childCell", bundle: nil), forCellReuseIdentifier: "UserChildCell")
        childrenTableView.separatorStyle = .none
    }

    @IBAction func addChildBtnClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "childInfos")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        
    }
    
}

extension EnfantsViewController:  UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return decodedChildrenArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.rowHeight = UITableView.automaticDimension
        return 100.0

    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserChildCell", for: indexPath) as! ChildTvCell

        let child = decodedChildrenArray[indexPath.row]
        
        DispatchQueue.main.async {
            if let photo = child.user?.photo, !photo.isEmpty {
                var photoUrl = photo
                if let range = photo.range(of: "http") {
                    photoUrl.insert("s", at: range.upperBound)
                }
                cell.childPhoto.loadImage(photoUrl)
            } else {
                if child.user?.gender == "M" {
                    cell.childPhoto.image = UIImage(imageLiteralResourceName: "malePic")
                } else {
                    cell.childPhoto.image = UIImage(imageLiteralResourceName: "femalePic")
                }
            }
            cell.nameLbl.text = (child.user?.first_name.uppercased())! + " " + (child.user?.last_name.uppercased())!
            //Calculate age from birthday
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd" // or whatever format your date string is in
            if let birthdayDate = dateFormatter.date(from: child.user!.birthday) {
                let age = self.age(from: birthdayDate)
                cell.ageLbl.text = "\(age) ans"
            }
        }
        return cell
    }
    
    func age(from birthday: Date) -> Int {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthday, to: Date())
        let age = ageComponents.year ?? 0
        return age
    }

}

