//
//  AppSerchVC+Search.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-08-18.
//  Copyright © 2016 Snowpunch. All rights reserved.
//

import UIKit

extension AppSearchVC {
    
    func setTableStyle() {
        self.tableView.separatorStyle = .none
        self.tableView.allowsMultipleSelection = true;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppSelectCellID", for: indexPath) as! AppSelectCell
        let model = self.apps[indexPath.row]
        cell.setup(model: model)
        return cell
    }
    
    // select app
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! AppSelectCell
        cell.addSwitch.setOn(true, animated: true)
        let model = self.apps[indexPath.row]
        SearchList.sharedInst.addAppModel(model: model)
    }
    
    // deselect app
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! AppSelectCell
        cell.addSwitch.setOn(false, animated: true)
        let model = self.apps[indexPath.row]
        SearchList.sharedInst.removeAppModel(model: model)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apps.count
    }
}
