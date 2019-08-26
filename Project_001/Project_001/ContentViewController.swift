//
//  ContentViewController.swift
//  Project_001
//
//  Created by Yifeng Guo on 7/5/19.
//  Copyright © 2019 Yifeng Guo. All rights reserved.
//

import UIKit
import Firebase

class ContentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendRequestInformation.id.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tablecell = UITableViewCell(style: .default, reuseIdentifier: "friendRequestCell")
        tablecell.textLabel?.text = friendRequestInformation.name[indexPath.row]
        tablecell.accessibilityIdentifier = friendRequestInformation.id[indexPath.row]
        return tablecell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tablecell = tableView.cellForRow(at: indexPath)
        friendSelectedInformation.name = (tablecell!.textLabel?.text!)!
        friendSelectedInformation.id = tablecell!.accessibilityIdentifier!
        print("select")
        self.performSegue(withIdentifier: "afterFriendRequestListClickedSegue", sender: nil)
    }
    
    
    @IBOutlet weak var contentTableView: UITableView!
    
    let userauth = Auth.auth()
    let db = Firestore.firestore()
    
    @IBOutlet weak var contentBarItem: UITabBarItem!
    //@IBOutlet weak var contentBarItem: UITabBarItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("friendRequest")
        print(friendRequestInformation)
        if friendRequestInformation.id.count > 0{
        contentBarItem.badgeValue = String(friendRequestInformation.id.count)
        contentBarItem.badgeColor = UIColor.green
        }
        let myUser = userauth.currentUser
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("update! ContentViewController viewWillAppear")
        if friendRequestInformation.id.count > 0{
        contentBarItem.badgeValue = String(friendRequestInformation.id.count)
        contentBarItem.badgeColor = UIColor.green
        }
        contentTableView.reloadData()
    }
    
    
    override func loadViewIfNeeded() {
        print("loadViewIfNeeded")
    }
}
