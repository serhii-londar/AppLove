//
//  ReviewListVC+TVDataSource.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-08-18.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  DataSource for review data. Displays user reviews.
//

import UIKit

extension ReviewListVC: UITableViewDataSource {
    
    func tableSetup() {
        self.tableView.register(UINib(nibName: "ReviewCell", bundle: nil), forCellReuseIdentifier: "ReviewCellID")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        self.tableView.allowsSelection = false
    }
    
    func reloadData() {
        allReviews = ReviewLoadManager.sharedInst.reviews
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCellID", for: indexPath) as! ReviewCell
        let model = self.allReviews[indexPath.row]
        cell.setup(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allReviews.count;
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
}
