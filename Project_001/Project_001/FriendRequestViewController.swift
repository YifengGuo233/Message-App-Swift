//
//  FriendRequestViewController.swift
//  Project_001
//
//  Created by Yifeng Guo on 7/6/19.
//  Copyright © 2019 Yifeng Guo. All rights reserved.
//

import UIKit
import Firebase

class FriendRequestViewController: UIViewController {


    @IBOutlet weak var usernameLabel: UILabel!
    
    let userauth = Auth.auth()
    let db = Firestore.firestore()
    var requestWithId : String = ""
    var requestWithName: String = ""
  
    override func viewDidLoad() {
        super.viewDidLoad()
        let myUser = userauth.currentUser
        usernameLabel.text = friendSelectedInformation.name
        //idLabel.text = friendSelectedInformation.id
        requestWithId = friendSelectedInformation.id
        requestWithName = friendSelectedInformation.name
        print("name")
        print(requestWithName)
        print("id")
        print(requestWithId)
        print("myuser")
        print(myUser?.displayName)
    }
    
    @IBAction func agreeClicked(_ sender: Any) {
        //let group = DispatchGroup()
        let myUser = userauth.currentUser
        print("agreeClicked")
        db.collection("User/"+String(myUser!.uid)+"/FriendRequestFrom/").document(requestWithId).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        db.collection("User/"+requestWithId+"/FriendRequestTo/").document(String(myUser!.uid)).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        print("removed")
        db.document("User/"+String(myUser!.uid)+"/Friends/"+self.requestWithId).setData(["username": self.requestWithName as Any, "groupFlag" : false])
        print("1")
        db.document("User/"+self.requestWithId+"/Friends/"+String(myUser!.uid)).setData(["username": myUser?.displayName as Any, "groupFlag": false])
        
        self.performSegue(withIdentifier: "afterAgreeSegue", sender: nil)
    }
    @IBAction func disagreeClicked(_ sender: Any) {
        let myUser = userauth.currentUser
        db.collection("User/"+String(myUser!.uid)+"/FriendRequestFrom/").document(requestWithId).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        db.collection("User/"+requestWithId+"/FriendRequestTo/").document(String(myUser!.uid)).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        
        self.performSegue(withIdentifier: "afterDisagreeSegue", sender: nil)
    }
    
}
