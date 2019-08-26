//
//  SigninViewController.swift
//  Project_001
//
//  Created by Yifeng Guo on 7/3/19.
//  Copyright © 2019 Yifeng Guo. All rights reserved.
//

import UIKit
import Firebase

class SignupViewController: UIViewController{
    
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "girl-headphone-laptop-1181300")
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.alpha = 0.8
        self.view.insertSubview(backgroundImage, at: 0)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func SignupClick(_ sender: Any) {
        if (email.text != "" && password.text != "")
        { Auth.auth().createUser(withEmail: email.text!, password: password.text!) { authResult, error in
            if let error = error{
                print(error.localizedDescription)
                let alert = UIAlertController(title: "Something Wrong!", message: error.localizedDescription, preferredStyle: .alert)
                self.present(alert, animated: true)
                alert.dismiss(animated: true)
            }
            else{
                let userauth = Auth.auth()
                let myUser = userauth.currentUser
                let db = Firestore.firestore()
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = self.email.text
                print("look herer")
                changeRequest?.commitChanges { (error) in
                    print(error)
                }
                print(Auth.auth().currentUser?.displayName)
                let bufferRef = db.document("User/"+String(myUser!.uid)+"/ChatBuffer/Buffer")
                bufferRef.setData([
                    "userID": String(myUser!.uid)
                    ]) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!")
                        }
                }
                bufferRef.updateData([
                    "userID": FieldValue.delete(),
                ]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document successfully updated")
                    }
                }
                
//                let groupBufferRef = db.document("User/"+String(myUser!.uid)+"/ChatBuffer/GroupBuffer")
//                groupBufferRef.setData([
//                    "userID": String(myUser!.uid)
//                ]) { err in
//                    if let err = err {
//                        print("Error writing document: \(err)")
//                    } else {
//                        print("Document successfully written!")
//                    }
//                }
//                groupBufferRef.updateData([
//                    "userID": FieldValue.delete(),
//                ]) { err in
//                    if let err = err {
//                        print("Error updating document: \(err)")
//                    } else {
//                        print("Document successfully updated")
//                    }
//                }
                
                
                let docRef = db.collection("User").document(myUser!.uid)
                docRef.setData([
                    "email": myUser?.email as Any,
                    "username": myUser?.email as Any
                ]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                        self.performSegue(withIdentifier: "afterSignUpSegue", sender: nil)
                    }
                }
            }
            
            }
        }
        else{
            print("type something")
            let alert = UIAlertController(title: "Failed!", message: "Please Type Something", preferredStyle: .alert)
            self.present(alert, animated: true)
            alert.dismiss(animated: true)
        }
    }
    
    
    
}
