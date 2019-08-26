//
//  SearchResultProfileViewController.swift
//  Project_001
//
//  Created by Yifeng Guo on 7/5/19.
//  Copyright © 2019 Yifeng Guo. All rights reserved.
//

import UIKit
import Firebase

class SearchResultProfileViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
   // @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var currentStatue: UILabel!
    
    let userauth = Auth.auth()
    let db = Firestore.firestore()
    var searchWithId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameLabel.text = searchInformation.nameofChat
      //  userIdLabel.text = searchInformation.idofChat
        searchWithId = searchInformation.idofChat
    }
    override func viewWillAppear(_ animated: Bool) {
        let myUser = userauth.currentUser
        let docRefto = db.document("User/"+String(myUser!.uid)+"/FriendRequestTo/"+searchWithId)
        docRefto.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("mark")
                print("Document data: \(dataDescription)")
                self.currentStatue.text = "Is Requesting"
            }
            else{
                self.currentStatue.text = "No A Friend"
            }
        }
    }
    
    @IBAction func sendFriendRequest(_ sender: Any) {
        let myUser = userauth.currentUser
        let docRefto = db.document("User/"+String(myUser!.uid)+"/FriendRequestTo/"+searchWithId)
        let docReffrom = db.document("User/"+searchWithId+"/FriendRequestFrom/"+String(myUser!.uid))
        if(myUser!.uid != self.searchWithId){
            let data : [String: String] = ["Requesting": "true", "username":String((myUser?.displayName!)!)]
            docRefto.setData(data, merge: false) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
            docReffrom.setData(data, merge: false) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                    self.currentStatue.text = "Is Requesting"
                }
            }
            
        }
    }
}
