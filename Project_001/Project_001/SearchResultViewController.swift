//
//  SearchResultViewController.swift
//  Project_001
//
//  Created by Yifeng Guo on 7/5/19.
//  Copyright © 2019 Yifeng Guo. All rights reserved.
//

import UIKit

class SearchResultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.nameofSearchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tablecell = UITableViewCell(style: .default, reuseIdentifier: "searchCell")
        tablecell.textLabel?.text = searchResult.nameofSearchResult[indexPath.row]
        tablecell.accessibilityIdentifier = searchResult.idofSearchResult[indexPath.row]
        return tablecell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let tablecell = tableView.cellForRow(at: indexPath)
            searchInformation.nameofChat = (tablecell!.textLabel?.text!)!
            searchInformation.idofChat = tablecell!.accessibilityIdentifier!
            print("select")
            self.performSegue(withIdentifier: "afterSearchResultClickedSegue", sender: nil)
    }
    
    
    @IBOutlet weak var searchTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTableView.delegate = self
        searchTableView.dataSource = self
    }
    override func viewDidDisappear(_ animated: Bool) {
    }
}
