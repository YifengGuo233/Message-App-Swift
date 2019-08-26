//
//  ChatViewController.swift
//  Project_001
//
//  Created by Yifeng Guo on 6/27/19.
//  Copyright © 2019 Yifeng Guo. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
import AVFoundation

class chatUserCell: UITableViewCell{
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var messageBackground: UIView!
    @IBOutlet weak var audioButton: UIButton!
}

class chatOtherCell: UITableViewCell{
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var messageBackground: UIView!
    @IBOutlet weak var audioButton: UIButton!
}


class ChatViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("cacheMessage")
        print(cacheMessage)
        print(cacheMessage[self.chatWithId]?[2].count)
        return((cacheMessage[self.chatWithId]?[2].count) ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if cacheMessage[self.chatWithId]?[1][indexPath.row] == userauth.currentUser?.uid{
            let tablecell = tableView.dequeueReusableCell(withIdentifier: "chatLine") as! chatUserCell?
            tablecell?.profileImage.image = cacheItem.object(forKey: cacheMessage[self.chatWithId]![1][indexPath.row] as! NSString)
            tablecell?.profileImage.layer.borderWidth = 1.0
            tablecell?.messageBackground.layer.cornerRadius = 15
            tablecell?.selectionStyle = .none
            print("cacheMessage[self.chatWithId]?[3][indexPath.row]")
            print(cacheMessage[self.chatWithId]?[3][indexPath.row])
            if cacheMessage[self.chatWithId]?[3][indexPath.row] == "false"{
            tablecell?.message.text = cacheMessage[self.chatWithId]?[2][indexPath.row]
            
            tablecell?.message.numberOfLines = 0
            tablecell?.message.lineBreakMode = .byWordWrapping
                 tablecell?.message.alpha = 1
                 tablecell?.audioButton.alpha = 0
            }
            else{
                print("why here?")
                tablecell?.message.alpha = 0
                tablecell?.audioButton.alpha = 1
                tablecell?.audioButton.accessibilityIdentifier = cacheMessage[self.chatWithId]?[2][indexPath.row]
            }
            return tablecell!
            
            
        }
        else{
            let tablecell = tableView.dequeueReusableCell(withIdentifier: "chatOtherLine") as! chatOtherCell?
            tablecell?.profileImage.image = cacheItem.object(forKey: cacheMessage[self.chatWithId]?[1][indexPath.row] as! NSString)
            tablecell?.profileImage.layer.borderWidth = 1.0
            tablecell?.messageBackground.layer.cornerRadius = 15
            tablecell?.selectionStyle = .none
            print("cacheMessage[self.chatWithId]?[3][indexPath.row]")
            print(cacheMessage[self.chatWithId]?[3][indexPath.row])
             if cacheMessage[self.chatWithId]![3][indexPath.row] == "false"{
            tablecell?.message.text = cacheMessage[self.chatWithId]?[2][indexPath.row]
            tablecell?.message.numberOfLines = 0
            tablecell?.message.lineBreakMode = .byWordWrapping
                tablecell?.message.alpha = 1
                tablecell?.audioButton.alpha = 0
            }
             else{
                print("why here?")
                tablecell?.message.alpha = 0
                tablecell?.audioButton.alpha = 1
                tablecell?.audioButton.accessibilityIdentifier = cacheMessage[self.chatWithId]?[2][indexPath.row]
            }
           
            return tablecell!
        }
    }
    
    
    @IBOutlet weak var ViewBottomC: NSLayoutConstraint!
    
    var array: [String] = []
    var rarray: [String] = []
    var sarray: [String] = []
    var who: [String] = []
    var keys: [String] = []
    var audio: [String] = []
    var audiourl: [String: String] = [:]
    var timestamp : [String] = []
    var rtimestamp : [String] = []
    var stimestamp : [String] = []
    var rdic: [String: Any] = [:]
    let dispatchGroup = DispatchGroup()
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var bavigationBar: UINavigationBar!
    @IBOutlet weak var bavigationTitle: UINavigationItem!
    @IBOutlet weak var chatInput: UITextField!
    @IBOutlet weak var voiceInput: UIView!
    @IBOutlet weak var voiceButton: UIButton!
//
    var soundRecorder: AVAudioRecorder!
    var soundPlayer = AVAudioPlayer()
//
//
    let userauth = Auth.auth()
    let db = Firestore.firestore()
    var chatWithId: String = ""
    var chatisGroupChat : Bool = false
    var roomMember : [String] = []
    var currentDate : NSDate?
    let dirpath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatTableView.delegate = self
        chatInput.delegate = self
        chatInput.sizeToFit()
        let voicePress = UILongPressGestureRecognizer(target: self, action: #selector(voiceButtonPressing))
        let voiceTap = UITapGestureRecognizer(target: self, action: #selector(voiceButtonTap))
        voiceButton.addGestureRecognizer(voicePress)
        voiceButton.addGestureRecognizer(voiceTap)
        print("dirpath")
        print("dirpath")
        print("dirpath")
        print("dirpath")
        print("dirpath")
        print("dirpath")
        print("dirpath")
        print("dirpath")
        print("dirpath")
        print("dirpath")
        print("dirpath")
        print(dirpath)
    }
    
    
    
    @IBAction func audioButtonClicked(_ sender: UIButton) {
        print(sender.accessibilityIdentifier)
        let recordingSession = AVAudioSession.sharedInstance()
        do{
            try recordingSession.setActive(true, options: .notifyOthersOnDeactivation)
        }
        catch
        {
            print("recordingSession")
            print(error)
        }
        let userauth = Auth.auth()
        let myUser = userauth.currentUser
        do{

            let url = URL(string: sender.accessibilityIdentifier ?? "nil")
            let data = try Data(contentsOf: url!)
            print(data)
            print("url done")
            
            self.soundPlayer = try AVAudioPlayer(data: data)
            self.soundPlayer.delegate = self
            print("no error")
            self.soundPlayer.prepareToPlay()
            self.soundPlayer.isMeteringEnabled = true
            self.soundPlayer.play()
        }
        catch{
            print("error")
            print(error)
        }
        

    }

    
    
    @objc func ScreenClicked(){
        chatInput.resignFirstResponder()
        print("ScreenClicked")
        //view.endEditing(true)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear")
    }
    
    
    
    @objc func voiceButtonPressing(_ sender: UIGestureRecognizer){
        if sender.state == .ended {
           
             print("sender.state == .ended ")
            soundRecorder.stop()
            print(soundRecorder.url)
            sender.view?.alpha = 1
            if let data = NSData(contentsOf: soundRecorder.url){
                let uploadRef = Storage.storage().reference(withPath: "Audio/\(self.userauth.currentUser!.uid)/"+"\(chatWithId)/"+"\(currentDate!.timeIntervalSince1970).m4a")
                let uploadMetadata = StorageMetadata.init()
                //uploadMetadata.contentType = "image/jpeg"
                uploadRef.putData(data as Data, metadata: uploadMetadata){
                        (downloadMetadata, error) in
                        if let error = error {
                            print(error)
                        }
                        else{
                            //downloaded
                            print("String(describing: downloadMetadata)")
                            print(String(describing: downloadMetadata))
                            uploadRef.downloadURL
                            { (url, error) in
                                if let downloadURL = url{
                                    self.sarray.append(downloadURL.absoluteString)
                                }
                                        else {
                                     self.sarray.append("")
                                    }
                                let myUser = self.userauth.currentUser
                                print("current chat with: " + String(self.chatWithId))
                                print("myUser: " + String(myUser!.uid))
                                let docRefc1 = self.db.document("User/"+String(myUser!.uid)+"/Friends/"+self.chatWithId+"/Chat/Conversation")
                                var docRefc2 = self.db.document("User/"+self.chatWithId+"/Friends/"+String(myUser!.uid)+"/Chat/Conversation")
                                self.sarray.append(myUser!.uid)
                                self.sarray.append("true")
                                let t = NSDate().timeIntervalSince1970
                                self.timestamp.append(String(t))
                                var bufferdata = [String: [String]]()
                                var sdata = [String: [String]]()
                                print(self.sarray)
                                for(_, element) in self.timestamp.enumerated(){
                                    sdata[element] = self.sarray
                                    bufferdata[element] = self.sarray
                                }
                                if self.chatisGroupChat == true{
                                    print("lllllllll@@@@@@@@@@@@@@")
                                    docRefc2 = self.db.document("Group/"+self.chatWithId+"/Chat/Conversation")
                                    print("roomMember")
                                    print(self.roomMember)
                                    DispatchQueue.main.async {
                                        for id in self.roomMember {
                                            if id != myUser?.uid{
                                                print(id)
                                                let docBuffer = self.db.document("User/"+id+"/ChatBuffer/"+self.chatWithId)
                                                print("DQ")
                                                docBuffer.setData(bufferdata, merge: true)
                                                { err in
                                                    if let err = err {
                                                        print("Error writing document: \(err)")
                                                    } else {
                                                        print("Document successfully written!")
                                                    }
                                                }
                                                
                                            }
                                        }
                                    }
                                }
                                else{
                                    let docBuffer = self.db.document("User/"+self.chatWithId+"/ChatBuffer/Buffer")
                                    docBuffer.setData(bufferdata, merge: true){ err in
                                        if let err = err {
                                            print("Error writing document: \(err)")
                                        } else {
                                            print("Document successfully written!")
                                        }
                                    }
                                }
                                
                                
                                docRefc1.setData(sdata, merge: true) { err in
                                    if let err = err {
                                        print("Error writing document: \(err)")
                                    } else {
                                        print("Document successfully written!")
                                    }
                                }
                                docRefc2.setData(sdata, merge: true) { err in
                                    if let err = err {
                                        print("Error writing document: \(err)")
                                    } else {
                                        print("Document successfully written!")
                                    }
                                }
                                self.sarray = []
                                self.timestamp = []
                            }
                            
                        }
                    }
            }
            
        }
        else if sender.state == .began {
            print("sender.state == .began ")
            sender.view?.alpha = 0.5
            currentDate = NSDate()
            print(currentDate)
            let filename = String(currentDate!.timeIntervalSince1970)+".m4a"
            print(filename)
            let pathArray = [dirpath, filename]
            let filePath = NSURL.fileURL(withPathComponents: pathArray)
            print(filePath)
            let recordingSession = AVAudioSession.sharedInstance()
            do{
                try recordingSession.setCategory(.playAndRecord,mode:.spokenAudio, options: .defaultToSpeaker)
                try recordingSession.setActive(true, options: .notifyOthersOnDeactivation)
            }
            catch
            {
                print("recordingSession")
                print(error)
            }
            //setting information from https://www.hackingwithswift.com/example-code/media/how-to-record-audio-using-avaudiorecorder
           // let settings = [String:Any]()
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            do{
                soundRecorder = try AVAudioRecorder(url: filePath!, settings: settings)
                soundRecorder.delegate = self
                soundRecorder.isMeteringEnabled = true
                soundRecorder.prepareToRecord()
                print("soundRecorder.prepareToRecord()")
                print(soundRecorder.prepareToRecord())
                if soundRecorder.prepareToRecord(){
                soundRecorder.record()
                }
            }
            catch{
                print(error)
            }
        }
    }
    
    @objc func voiceButtonTap(){
        print("Tap")
    }
    
    
    @objc func keyboardWillShow() {
        UIView.animate(withDuration:1.0, animations:{
            self.ViewBottomC.constant = CGFloat(322)
            
        })
    }
    
    @objc func keyboardWillNotShow() {
        UIView.animate(withDuration:1.0, animations:{
            self.ViewBottomC.constant = CGFloat(0)
            
        })
    }
    
    func buffercleaner(){
        if chatisGroupChat == true{
            let docRef = db.collection("Group").document(chatWithId)
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("Document data: \(dataDescription)")
                    print(document.data()!["RoomMember"] as! [String])
                    self.roomMember = document.data()!["RoomMember"] as! [String]
                } else {
                    print("Document does not exist")
                }
            }
        }
        
        print("cacheMessage[self.chatWithId]")
        print(cacheMessage[self.chatWithId]?[0])
        if cacheMessage[self.chatWithId] != nil{
            print("count")
            self.chatTableView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.chatTableView.scrollToRow(at: IndexPath(row: (cacheMessage[self.chatWithId]?[2].count)!-1, section: 0), at: .top, animated: false)
            }
        }
        print("viewWillAppear")
        let userauth = Auth.auth()
        let myUser = userauth.currentUser
        
        for (key, value) in (bufferChat.sorted( by: { $0.0 < $1.0 })) {
            print("value[1]")
            print(value[1])
            print("chatWithId")
            print(chatWithId)
            if (value[1] == chatWithId){
                print("delete")
                var index = bufferChat.index(forKey: key)
                bufferChat.remove(at: index!)
            }
        }
        print("bufferChat")
        print(bufferChat)
        var updateBufferChat = bufferChat as [String:[Any]]
        
        let docBuffer = db.document("User/"+String(myUser!.uid)+"/ChatBuffer/Buffer")
        docBuffer.setData(bufferChat, merge: false){
            err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        
        for (key, value) in (bufferGroupChat) {
            if (key == chatWithId){
                print("delete")
                var index = bufferGroupChat.index(forKey: key)
                bufferGroupChat.remove(at: index!)
            }
        }
        print("bufferGroupChat")
        print(bufferGroupChat)
        let groupBuffer = db.document("User/"+String(myUser!.uid)+"/ChatBuffer/"+chatWithId)
        groupBuffer.delete()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let userauth = Auth.auth()
        let myUser = userauth.currentUser
        self.chatTableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ScreenClicked)))
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillNotShow), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.chatWithId = information.idofChat
        self.chatisGroupChat = information.isGroupChat
        buffercleaner()
        
        print("email"+information.nameofChat)
        bavigationTitle.title = information.nameofChat
        print("id: "+chatWithId)
        print("current chat with: " + String(self.chatWithId))
        print("myUser: " + String(myUser!.uid))
        var docRefc = db.document("User/"+String(myUser!.uid)+"/Friends/"+self.chatWithId+"/Chat/Conversation")
        if chatisGroupChat == true{
            print("hhhhhhhhhasluhfalskjdhfaskdjfhasldkfjhasfk")
            docRefc = db.document("Group/"+self.chatWithId+"/Chat/Conversation")
        }
        if(myUser!.uid != self.chatWithId){
            docRefc.addSnapshotListener { (document, error) in
                if let document = document, document.exists {
                    print("new message")
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("mark")
                    for (key, value) in (document.data()?.sorted( by: { $0.0 < $1.0 }))! {
                        print("\(key) -> \(value)")
                        print(type(of: key))
                        print(cacheMessage[self.chatWithId]?[0])
                        if cacheMessage[self.chatWithId]?[0].contains(key) ?? false {
                            print("already there")
                        }
                        else{
                            self.keys.append(key)
                            self.array.append((value as! [String])[0])
                            self.who.append((value as! [String])[1])
                            self.audio.append((value as! [String])[2])
                            
                            print("append")
                            print("cacheMessage[self.chatWithId]")
                            print(cacheMessage[self.chatWithId])
                             cacheMessage[self.chatWithId] = [self.keys, self.who, self.array, self.audio]
                            
                            //self.buffercleaner()
                            self.chatTableView.reloadData()
                            DispatchQueue.main.asyncAfter(deadline: .now()) {
                                self.chatTableView.scrollToRow(at: IndexPath(row: (cacheMessage[self.chatWithId]?[2].count)!-1, section: 0), at: .bottom, animated: true)
                            }
                        }
                    }
                    self.chatTableView.reloadData()
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        self.chatTableView.scrollToRow(at: IndexPath(row: (cacheMessage[self.chatWithId]?[2].count)!-1, section: 0), at: .bottom, animated: false)
                    }
                } else {
                    print("Document does not exist")
                }
            }
        }
        else{
            print("wait")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        rarray = []
        sarray = []
        timestamp = []
        rtimestamp = []
        stimestamp = []
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        finishEditing()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.chatInput.resignFirstResponder()
        //view.endEditing(true)
        print("???????sdfasdfasf")
    }
    
    
    func finishEditing() {
        if chatInput.text != "" {
            let myUser = userauth.currentUser
            print("current chat with: " + String(self.chatWithId))
            print("myUser: " + String(myUser!.uid))
            let docRefc1 = db.document("User/"+String(myUser!.uid)+"/Friends/"+self.chatWithId+"/Chat/Conversation")
            var docRefc2 = db.document("User/"+self.chatWithId+"/Friends/"+String(myUser!.uid)+"/Chat/Conversation")
            
            sarray.append(chatInput.text!)
            sarray.append(myUser!.uid)
            self.sarray.append("false")
            let t = NSDate().timeIntervalSince1970
            timestamp.append(String(t))
            var bufferdata = [String: [String]]()
            var sdata = [String: [String]]()
            print(sarray)
            for(_, element) in timestamp.enumerated(){
                sdata[element] = sarray
                bufferdata[element] = sarray
            }
            if chatisGroupChat == true{
                print("lllllllll@@@@@@@@@@@@@@")
                docRefc2 = db.document("Group/"+self.chatWithId+"/Chat/Conversation")
                print("roomMember")
                print(roomMember)
                DispatchQueue.main.async {
                    for id in self.roomMember {
                        if id != myUser?.uid{
                            print(id)
                            let docBuffer = self.db.document("User/"+id+"/ChatBuffer/"+self.chatWithId)
                            print("DQ")
                            docBuffer.setData(bufferdata, merge: true)
                            { err in
                                if let err = err {
                                    print("Error writing document: \(err)")
                                } else {
                                    print("Document successfully written!")
                                }
                            }
                        }
                    }
                }
            }
            else{
                let docBuffer = db.document("User/"+self.chatWithId+"/ChatBuffer/Buffer")
                docBuffer.setData(bufferdata, merge: true){ err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                    }
                }
            }
            
            
            docRefc1.setData(sdata, merge: true) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
            docRefc2.setData(sdata, merge: true) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
            sarray = []
            timestamp = []
            chatInput.text = ""
        }
        else{
            let alert = UIAlertController(title: "Can not send empty space", message: "Please Type Something", preferredStyle: .alert)
            self.present(alert, animated: true)
            alert.dismiss(animated: true)
        }
    }
    
    @IBAction func voiceRecordPressing(_ sender: Any) {
        if voiceInput.alpha == 0{
        
                voiceInput.alpha = 1
        }
        else{
                voiceInput.alpha = 0
        }
        
    }

    
}
