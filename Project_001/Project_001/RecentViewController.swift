//
//  ViewController.swift
//  Project_001
//
//  Created by Yifeng Guo on 6/27/19.
//  Copyright © 2019 Yifeng Guo. All rights reserved.
//

import UIKit
import Firebase
import Foundation
import UserNotifications


class customCell: UITableViewCell{
    
    @IBOutlet weak var cellView: UIView!
    
    @IBOutlet weak var cellImage: UIImageView!
    
    @IBOutlet weak var cellName: UILabel!
    
    @IBOutlet weak var cellBadge: UILabel!
    
    
}




class RecentViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate,UITableViewDataSource {
    
    //set up for tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(listOfFriends.count + 1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0){
            let tablecell = tableView.dequeueReusableCell(withIdentifier: "searchBar")
            return tablecell!
        }
        else{
            
            let tablecell = tableView.dequeueReusableCell(withIdentifier: "cell") as! customCell?
            print("create element")
            var badgeCounter: Int = 0
            for (key, value) in (bufferChat.sorted( by: { $0.0 < $1.0 })) {
                print("\(key) -> \(value)")
                if (value[1] == listOfId[indexPath.row - 1]){
                    badgeCounter += 1
                }
            }
            for (key, value) in (bufferGroupChat){
                if(key) == listOfId[indexPath.row - 1]{
                     badgeCounter += 1
                }
            }
            if isGroupChat[indexPath.row-1] == false{
                tablecell!.cellName.text = listOfFriends[indexPath.row - 1]
            }
            else{
                tablecell!.cellName.text = listOfFriends[indexPath.row - 1] + "(Group Chat)"
            }
            
            tablecell!.cellBadge.text = String(badgeCounter)
            tablecell?.cellImage.image = cacheItem.object(forKey: listOfId[indexPath.row - 1] as NSString)
            tablecell?.cellImage.layer.cornerRadius = (tablecell?.cellImage.frame.height)!/2
            tablecell?.cellImage.layer.borderWidth = 1.0
            tablecell!.accessibilityIdentifier = listOfId[indexPath.row - 1]
            return tablecell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row != 0){
            let tablecell = tableView.cellForRow(at: indexPath) as! customCell
            information.nameofChat = tablecell.cellName.text!
            information.idofChat = tablecell.accessibilityIdentifier!
            if isGroupChat[indexPath.row - 1] == false {
                information.isGroupChat = false
            self.performSegue(withIdentifier: "chatSegue", sender: nil)
            }
            else{
                print("that should be group chat")
                information.isGroupChat = true
                self.performSegue(withIdentifier: "chatSegue", sender: nil)
            }
        }
    }
    
    @IBOutlet weak var newFriendName: UITextField!
    @IBOutlet weak var mainTableView: UITableView!
    
    @IBOutlet weak var alertView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTableView.delegate = self
        mainTableView.dataSource = self
        print("did load")
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        listener()
        let userauth = Auth.auth()
        let myUser = userauth.currentUser
        let islandRef = Storage.storage().reference().child("Profile/\(myUser!.uid).jpg")
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        islandRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                // Uh-oh, an error occurred!
            } else {
                // Data for "images/island.jpg" is returned
                if let image = UIImage(data: data!){
                    
                    if cacheItem.object(forKey: myUser!.uid as NSString) == nil{
                        cacheItem.setObject((image), forKey: myUser!.uid as NSString)
                    }
                    else {
                        print("image already downloaded")
                    }
                }
            }
        }
       self.mainTableView.reloadData()
        let db = Firestore.firestore()
        print("here")
        print(myUser?.displayName as Any)
        let colRef = db.collection("User").document(myUser!.uid).collection("Friends")
        print("here2")
        colRef.addSnapshotListener()
            { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    print("here3")
                    listOfFriendsWithoutGroup = []
                    listOfIdWithoutGroup = []
                    listOfFriends = []
                    listOfId = []
                    isGroupChat = []
                    for document in querySnapshot!.documents {
                        print("here4")
                        let username = document.data()["username"] as! String
                        let documentid = document.documentID
                        let groupChatFlag = document.data()["groupFlag"] as! Bool
                        listOfFriends.append(username)
                        listOfId.append(documentid)
                        isGroupChat.append(groupChatFlag)
                        if groupChatFlag == false{
                            listOfFriendsWithoutGroup.append(username)
                            listOfIdWithoutGroup.append(documentid)
                        }
                        // Create a reference to the file you want to download
                        let islandRef = Storage.storage().reference().child("Profile/\(documentid).jpg")
                        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                        islandRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                            if let error = error {
                                // Uh-oh, an error occurred!
                            } else {
                                // Data for "images/island.jpg" is returned
                                if let image = UIImage(data: data!){
                                
                                if cacheItem.object(forKey: documentid as NSString) == nil{
                                    cacheItem.setObject((image), forKey: documentid as NSString)
                                }
                                else {
                                    print("image already downloaded")
                                }
                                self.mainTableView.reloadData()
                            }
                            }
                        }
                        self.mainTableView.reloadData()
                    }
                }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        //self.mainTableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ScreenClicked)))
        self.mainTableView.reloadData()
        
    }
    
//    @objc func ScreenClicked(){
//        self.newFriendName.resignFirstResponder()
//        print("ScreenClicked")
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear")
    }
    
    @IBAction func addFriendClick(_ sender: Any) {
        UIView.animate(withDuration:1.0, animations:{
            self.alertView.alpha = 1
        })
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        UIView.animate(withDuration:1.0, animations:{
            self.alertView.alpha = 0
        })
    }
    @IBAction func addNewFriendClicked(_ sender: Any) {
        let db = Firestore.firestore()
        
        if let searchName = newFriendName.text
        {
            print(searchName)
            let searchResultQuery = db.collection("User").whereField("username", isEqualTo: searchName)
            searchResultQuery.getDocuments { (snapshot, error) in
                print("in")
                if let error = error {
                    print("Error getting documents: \(error)")
                }
                else{
                    var nametemp: [String] = []
                    var idtemp: [String] = []
                    for document in snapshot!.documents {
                        nametemp.append(document.data()["username"] as! String)
                        idtemp.append(document.documentID)
                    }
                    searchResult.nameofSearchResult = nametemp
                    searchResult.idofSearchResult = idtemp
                    UIView.animate(withDuration:1.0, animations:{
                    self.alertView.alpha = 0
                    })
                    self.performSegue(withIdentifier: "searchResultSegue", sender: nil)
                }
            }
        }
    }
    
    @IBAction func startGroupChatClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "startGroupChatSegue", sender: nil)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chatSegue"{
            //for later
        }
        else if segue.identifier == "searchResultSegue"{
            
        }
    }
    
    

    //testing
    func listener(){
        var unread : Int = 0
        let userauth = Auth.auth()
        let db = Firestore.firestore()
        let myUser = userauth.currentUser
        let colRef = db.collection("User/"+String(myUser!.uid)+"/FriendRequestFrom/")
        colRef.whereField("Requesting", isEqualTo: "true").addSnapshotListener(){ (snapshot, error) in
            print("in")
            if let error = error {
                print("Error getting documents: \(error)")
            }
            else{
                var nametemp: [String] = []
                var idtemp: [String] = []
                print("friend request")
                print(snapshot!.documents.count)
                for document in snapshot!.documents {
                    print(document.data())
                    print(document.data()["username"] as! String)
                    nametemp.append(document.data()["username"] as! String)
                    idtemp.append(document.documentID)
                }
                print("nametemp")
                print(nametemp)
                print("idtemp")
                print(idtemp)
                friendRequestInformation.name = nametemp
                friendRequestInformation.id = idtemp
                if friendRequestInformation.id.count > 0{
               
                let baritemcontroll = self.tabBarController?.children[1]
                print(baritemcontroll)
                //baritemcontroll.contentBarItem.badgeValue = String(friendRequestInformation.id.count)
                //baritemcontroll.contentBarItem.badgeColor = UIColor.green
                }
            }
        }
        
        let chatbuffer = db.document("User/"+String(myUser!.uid)+"/ChatBuffer/Buffer")
        chatbuffer.addSnapshotListener(){ (snapshot, error) in
            print("in")
            if let error = error {
                print("Error getting documents: \(error)")
            }
            else{
                print("coming message")
                print(snapshot!.data() as Any)
                bufferChat = snapshot!.data() as! [String : [String]]
                print(bufferChat)
                print("you have new message")
                self.mainTableView.reloadData()
                if bufferChat.count > 0{
                    self.alert()
                }
                for (key, value) in (snapshot!.data()?.sorted( by: { $0.0 < $1.0 }))! {
                    print("loop")
                }
            }
        }
        
        let chatGroupbuffer = db.collection("User/"+String(myUser!.uid)+"/ChatBuffer/")
        chatGroupbuffer.addSnapshotListener(){ (snapshot, error) in
            print("in")
            if let error = error {
                print("Error getting documents: \(error)")
            }
            else{
                print("coming message")
                print(snapshot as Any)
                for document in snapshot!.documents{
                    print("document!!!!")
                    print(document.documentID)
                    if (document.documentID != "Buffer"){
                        print("document.documentID!!!")
                        print(document.documentID)
                        //let array = Array(repeating: "message", count: document.data().count)
                        bufferGroupChat = [document.documentID : document.data().count]
                    }
                }
                //bufferChat = snapshot!.data() as! [String : [String]]
                print("you have new message")
                print("bufferChat")
                print(bufferChat)
                self.mainTableView.reloadData()
                if bufferChat.count > 0{
                    self.alert()
                }
//                for (key, value) in (snapshot!.data()?.sorted( by: { $0.0 < $1.0 }))! {
//                    print("loop")
//                }
            }
        }
        
        
    }
    
    override func viewDidLayoutSubviews() {
        print("ffff")
    }
    override func viewWillLayoutSubviews() {
        print("that is fucked up")
        //alert()
    }
    
    func alert(){
        print("alert")
        let alert = UIAlertController(title: "New Message!", message: "New Message", preferredStyle: .alert)
        self.present(alert, animated: true)
        DispatchQueue.global().asyncAfter(deadline: .now()+0.5, execute:{
            DispatchQueue.main.async {
        alert.dismiss(animated: false)
            }
        })
    }
    
    func noti(){
        //get the notification center
        let center =  UNUserNotificationCenter.current()
        //create the content for the notification
        let content = UNMutableNotificationContent()
        content.title = " Jurassic Park"
        content.subtitle = "Lunch"
        content.body = "Its lunch time at the park, please join us for a dinosaur feeding"
        content.sound = UNNotificationSound.default
        
        //notification trigger can be based on time, calendar or location
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval:5.0, repeats: false)
        
        //create request to display
        let request = UNNotificationRequest(identifier: "ContentIdentifier", content: content, trigger: trigger)
        
        //add request to notification center
        center.add(request) { (error) in
            if error != nil {
                print("error \(String(describing: error))")
            }
            else{
                print("shit!")
            }
        }

    }
    
}

