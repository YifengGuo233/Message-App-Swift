//
//  StartGroupChatViewController.swift
//  Project_001
//
//  Created by Yifeng Guo on 7/25/19.
//  Copyright © 2019 Yifeng Guo. All rights reserved.
//

import UIKit
import Firebase

class StartGroupChatViewController: UIViewController,UITextFieldDelegate, UITableViewDelegate,UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfFriendsWithoutGroup.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tablecell = tableView.dequeueReusableCell(withIdentifier: "friendCell") as! UITableViewCell
        print("create element")
        tablecell.textLabel?.text = listOfFriendsWithoutGroup[indexPath.row]
        tablecell.accessibilityIdentifier = listOfIdWithoutGroup[indexPath.row]
        return tablecell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt")
        let tablecell = tableView.cellForRow(at: indexPath) as! UITableViewCell
        print(tablecell.accessoryType)
        if tablecell.accessoryType == .checkmark{
        tablecell.accessoryType = .none
            if let index = groupChatFriends.index(of: tablecell.accessibilityIdentifier!) {
                groupChatFriends.remove(at: index)
            }
        }
        else{
            tablecell.accessoryType = .checkmark
            groupChatFriends.append(tablecell.accessibilityIdentifier!)
        }
    }
    
    let userauth = Auth.auth()
    let db = Firestore.firestore()
    
    @IBAction func startGroupChatNow(_ sender: Any) {
        print("groupChatFriends")
        print(groupChatFriends)
        let myUser = userauth.currentUser
        var ref: DocumentReference? = nil
        var groupPeoples = groupChatFriends
        groupPeoples.append(myUser!.uid)
        ref = db.collection("Group").addDocument(data: ["RoomOwner" : myUser?.uid , "RoomMember" : groupPeoples])
        { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                self.db.document("User/"+String(myUser!.uid)+"/Friends/\(ref!.documentID)").setData(["username": String(myUser!.email!)+"Start a Group Chat" as Any, "groupFlag" : true])
                for id in self.groupChatFriends{
                self.db.document("User/"+id+"/Friends/\(ref!.documentID)").setData(["username": String(myUser!.email!)+"Start a Group Chat" as Any, "groupFlag" : true])
                }
                
            }
        }
        self.performSegue(withIdentifier: "afterGroupingSegue", sender: nil)
    }
    
    
    @IBOutlet weak var friendGroupView: UITableView!
    var groupChatFriends: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        
        friendGroupView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
    }

}
