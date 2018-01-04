//
//  AppListExtension.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-04-04.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  Table for main view. Can select, re-order or delete apps.
// 

import UIKit

extension AppListVC: UITableViewDataSource {
    
    func initTableView() {
        let nib = UINib(nibName: "AppCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "AppCellID")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 71
        self.tableView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppCellID", for: indexPath ) as! AppCell
        let model = AppList.sharedInst.appModels[indexPath.row]
        cell.setup(model: model)
        return cell
    }
    
    // select row
    func tableView(_ tableView: UITableView, willSelectRowAtIndexPath indexPath: IndexPath) -> IndexPath? {
        let item = AppList.sharedInst.appModels[indexPath.row]
        AppList.sharedInst.setSelectedModel(model: item)
        performSegue(withIdentifier: "detailReviews", sender: self)
        return indexPath
    }
    
    // delete row
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle,forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            AppList.sharedInst.appModels.remove(at: indexPath.row)
            AppList.sharedInst.save()
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        default:
            return
        }
    }
    
    // move row
    func tableView(_ tableView: UITableView,
                   moveRowAt sourceIndexPath: IndexPath,
                   to destinationIndexPath: IndexPath) {
        let val = AppList.sharedInst.appModels.remove(at: sourceIndexPath.row)
        AppList.sharedInst.appModels.insert(val, at: destinationIndexPath.row)
            AppList.sharedInst.save()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppList.sharedInst.appModels.count;
    }
}
