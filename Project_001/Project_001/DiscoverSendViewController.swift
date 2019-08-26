//
//  DiscoverSendViewController.swift
//  Project_001
//
//  Created by Yifeng Guo on 7/26/19.
//  Copyright © 2019 Yifeng Guo. All rights reserved.
//

import UIKit
import Firebase

class DiscoverSendViewController: UIViewController {

    @IBOutlet weak var storySharedTextField: UITextView!
    
    let userauth = Auth.auth()
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storySharedTextField.layer.borderWidth = 1
    }
    

    @IBAction func sendStoryClicked(_ sender: Any) {
        print(storySharedTextField.text)
        if storySharedTextField.text != nil{
        let myUser = userauth.currentUser
        let t = NSDate().timeIntervalSince1970
        var data = [String(t): [myUser?.uid, storySharedTextField.text,myUser?.displayName]]
        let docRefc = db.document("User/"+String(myUser!.uid)+"/MyBlog/Blog")
        docRefc.setData(data, merge: true) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
        let docRefc2 = db.document("User/"+String(myUser!.uid)+"/FriendBlog/Blog")
            docRefc2.setData(data, merge: true) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
            for id in listOfId{
            let docRefc3 = db.document("User/"+id+"/FriendBlog/Blog")
                docRefc3.setData(data, merge: true) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                    }
                }
            }
            self.navigationController?.popViewController(animated: true)
        }
        else{
            let alert = UIAlertController(title: "Can not send empty space", message: "Please Type Something", preferredStyle: .alert)
            self.present(alert, animated: true)
            alert.dismiss(animated: true)
        }
        }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.storySharedTextField.resignFirstResponder()
    }
    
    
}
