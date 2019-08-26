//
//  AccountViewController.swift
//  Project_001
//
//  Created by Yifeng Guo on 7/4/19.
//  Copyright © 2019 Yifeng Guo. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class AccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tablecell = UITableViewCell(style: .default, reuseIdentifier: "ProfileCell")
        tablecell.textLabel?.text = profileArray[indexPath.row]
        tablecell.accessibilityIdentifier = profileArray[indexPath.row]
        return tablecell
    }
    
    var profileArray:[String] = ["Account", "Setting"]
    var uploadImage: UIImage?
    
    
    @IBOutlet weak var accountTableView: UITableView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBAction func uploadClicked(_ sender: Any) {
        let imageController = UIImagePickerController()
        imageController.delegate = self
        imageController.sourceType = .photoLibrary
        imageController.allowsEditing = true
        self.present(imageController, animated: true)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[.editedImage] as? UIImage{
            uploadImage = image
            print(uploadImage)
            let uploadRef = Storage.storage().reference(withPath: "Profile/\(self.userauth.currentUser!.uid).jpg")
            let uploadMetadata = StorageMetadata.init()
            uploadMetadata.contentType = "image/jpeg"
            if let data = uploadImage?.jpegData(compressionQuality: 1){
                uploadRef.putData(data, metadata: uploadMetadata){
                    (downloadMetadata, error) in
                    if let error = error {
                        print(error)
                    }
                    else{
                        cacheItem.setObject(image, forKey: self.userauth.currentUser?.uid as! NSString)
                        print(String(describing: downloadMetadata))
                    }
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        print("cancel")
    }
    
    let userauth = Auth.auth()
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listener()
        let myUser = userauth.currentUser
        let docRef = db.collection("User").document(myUser!.uid)
        email.text = myUser?.email
        profileImage.image = cacheItem.object(forKey: myUser?.uid as! NSString)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                self.username.text = (document.data()!["username"] as! String)
                print("Document data: \(dataDescription)")
            } else {
                print("Document does not exist")
            }
        }
        accountTableView.reloadData()
    }
    

    
    @IBAction func SignoutClick(_ sender: Any) {
        do {
            try self.userauth.signOut()
            print("okay, Sign Out")
            
            self.performSegue(withIdentifier: "afterSignOutSegue", sender: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    
    
    
    func listener(){
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
                    let baritemcontroll = self.tabBarController?.children[1] as! ContentViewController
                    baritemcontroll.contentBarItem.badgeValue = String(friendRequestInformation.id.count)
                    baritemcontroll.contentBarItem.badgeColor = UIColor.green
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
                print("you have new message")
                for (key, value) in (snapshot!.data()?.sorted( by: { $0.0 < $1.0 }))! {
                    //print("\(key) -> \(value)")
                    //print("should have notification")
                }
            }
        }
        
    }
    
}
