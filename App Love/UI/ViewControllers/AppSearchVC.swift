//
//  AppSearchVC.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-02-27.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  Multi-Select search results. Add more apps to your main list.
// 

import UIKit

class AppSearchVC: UITableViewController, UISearchBarDelegate {

    var apps:[AppModel] = [AppModel]()
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableStyle()
        searchBar.delegate = self
        searchBar.placeholder = "ie: App Name";
        Theme.searchBar(item: searchBar)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        let searchStr = searchBar.text
        
        SearchApps.get(searchStr: searchStr!) { (apps, succeeded, error) -> Void in

            if let appsFound = apps {
                self.apps = appsFound
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}
