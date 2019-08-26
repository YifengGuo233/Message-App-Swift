//
//  DiscoverViewController.swift
//  Project_001
//
//  Created by Yifeng Guo on 7/24/19.
//  Copyright © 2019 Yifeng Guo. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications




class discoverCell: UITableViewCell{

    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var post: UILabel!
    @IBOutlet weak var username: UILabel!
 
}



class DiscoverViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BlogArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "discoverCell") as! discoverCell
        cell.imageProfile.image = cacheItem.object(forKey: UserIdArray[indexPath.row] as NSString)
        cell.post.text = BlogArray[indexPath.row]
        cell.username.text = UserNameArray[indexPath.row]
        return cell
    }
    

    @IBOutlet weak var discoverTableView: UITableView!
    var BlogArray:[String] = []
    var UserIdArray:[String] = []
    var UserNameArray: [String] = []
    let userauth = Auth.auth()
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        print("viewDidLoad")
        super.viewDidLoad()
        let myUser = userauth.currentUser
        var docRefc = db.document("User/"+myUser!.uid+"/FriendBlog/Blog")
        docRefc.addSnapshotListener { (document, error) in
            if let document = document, document.exists {
                self.BlogArray = []
                self.UserIdArray = []
                self.UserNameArray = []
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("New Blog")
                for (key, value) in (document.data()?.sorted( by: { $0.0 < $1.0 }))! {
                    print("\(key) -> \(value)")
                    print(type(of: key))
                    self.UserIdArray.append((value as! [String])[0])
                    self.BlogArray.append((value as! [String])[1])
                    self.UserNameArray.append((value as! [String])[2])
                }
                self.discoverTableView.reloadData()
            }
            else {
                print("Document does not exist")
            }
        }
//        discoverTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
     discoverTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("viewWillDisappear")
       
    }

}
