//
//  LoginViewController.swift
//  Project_001
//
//  Created by Yifeng Guo on 7/1/19.
//  Copyright © 2019 Yifeng Guo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import FileProviderUI
import GoogleSignIn
import UserNotifications

class LoginViewController: UIViewController, GIDSignInUIDelegate{

    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    let notification = UNUserNotificationCenter.current()
    
    @IBAction func LoginClick(_ sender: Any) {
        if email.text != "" && password.text != ""{
            Auth.auth().signIn(withEmail: email.text!, password: password.text!) { [weak self] user, error in
                guard let strongSelf = self else { return }
                
                print(user?.user.uid as Any)
                if user?.user.uid != nil{
                    print("in")
                    
                    //self?.listener()

                    strongSelf.performSegue(withIdentifier: "AfterLoginSegue", sender: nil)
                    
                }
                if error != nil{
                    let alert = UIAlertController(title: "Account Or Password is Wrong!", message: "Please re-type", preferredStyle: .alert)
                    strongSelf.present(alert, animated: true)
                    alert.dismiss(animated: true)
                }
        }
        }
        else{
            print("please type in something")
            let alert = UIAlertController(title: "Failed!", message: "Please Type Something", preferredStyle: .alert)
            self.present(alert, animated: true)
            alert.dismiss(animated: true)
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
                 self.navigationController?.popViewController(animated: true)
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
                    print("\(key) -> \(value)")
                }
            }
        }
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
    
    @IBAction func Signout(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        print("click")
        do {
            try firebaseAuth.signOut()
            cacheMessage.removeAll()
            cacheItem.removeAllObjects()
            cacheBlog.removeAll()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "adult-bar-brainstorming-1015568")
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.alpha = 0.8
        self.view.insertSubview(backgroundImage, at: 0)
    }

}
