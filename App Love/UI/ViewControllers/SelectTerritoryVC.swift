//
//  SelectTerritoryVC.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-03-12.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  Select which territories to download from.
// 

import UIKit

class SelectTerritoryVC: UITableViewController {

    var countries = TerritoryMgr.sharedInst.getArrayOfModels()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableSetup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        TerritoryMgr.sharedInst.updateFromTableState(tableState: self.countries)
    }
    
    @IBAction func onToggleSelectAll(_ sender: UIBarButtonItem) {
        if sender.title == "ALL" {
            sender.title = "CLEAR"
            selectAll() // toggle
        }
        else {
            sender.title = "ALL"
            clearAll() // toggle
        }
        self.tableView.reloadData()
    }
    
    func clearAll() {
        for country in countries {
            country.isSelected = false
        }
    }
    
    func selectAll() {
        for country in countries {
            country.isSelected = true
        }
    }
    
    @IBAction func onDefaultTerritories(_ button: UIBarButtonItem) {
        useDefaultTeritoriesActionSheet(button: button)
    }
    
    @IBAction func onSaveAsDefault(_ button: UIBarButtonItem) {
        saveDefaultTeritoriesActionSheet(button: button)
    }
}

// action sheets
extension SelectTerritoryVC {
    
    func saveDefaultTeritoriesActionSheet(button: UIBarButtonItem){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let saveDefaultsAction = UIAlertAction(title: "Save Selected as Default", style: .default) { action -> Void in
            TerritoryMgr.sharedInst.saveSelectedAsDefault()
        }

        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(saveDefaultsAction)
        alertController.addAction(actionCancel)
        Theme.alertController(item: alertController)
        if let popoverController = alertController.popoverPresentationController {
            popoverController.barButtonItem = button
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    func useDefaultTeritoriesActionSheet(button: UIBarButtonItem){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let useDefaultsAction = UIAlertAction(title: "Use Saved Defaults", style: .default) { action -> Void in
            self.clearAll()
            TerritoryMgr.sharedInst.setDefaultCountries()
            self.countries = TerritoryMgr.sharedInst.getArrayOfModels()
            self.tableView.reloadData()
        }
        let useOriginalDefaultsAction = UIAlertAction(title: "Use Original Defaults", style: .default) { action -> Void in
            self.clearAll()
            TerritoryMgr.sharedInst.setOriginalDefaults()
            self.countries = TerritoryMgr.sharedInst.getArrayOfModels()
            self.tableView.reloadData()
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(useDefaultsAction)
        alertController.addAction(useOriginalDefaultsAction)
        alertController.addAction(actionCancel)
        Theme.alertController(item: alertController)
        if let popoverController = alertController.popoverPresentationController {
            popoverController.barButtonItem = button
        }
        self.present(alertController, animated: true, completion: nil)
    }
}
