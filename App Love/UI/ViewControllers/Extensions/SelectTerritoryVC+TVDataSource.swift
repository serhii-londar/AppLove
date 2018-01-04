//
//  SelectCountryExtension.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-04-17.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  Table for selecting which territories to download from.
//

import UIKit

extension SelectTerritoryVC {
    
    func tableSetup() {
        self.tableView.allowsMultipleSelection = true;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath) as! CountrySelectCell
        let model = countries[indexPath.row]
        cell.setup(model: model)
        return cell
    }
    
    // add territory
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CountrySelectCell
        cell.addSwitch.setOn(true, animated: true)
        countries[indexPath.row].isSelected = true
    }
    
    // remove territory
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CountrySelectCell
        cell.addSwitch.setOn(false, animated: true)
        countries[indexPath.row].isSelected = false
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
}
