//
//  ReviewListVC+ActionSheets.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-08-18.
//  Copyright © 2016 Snowpunch. All rights reserved.
//

import UIKit

// action sheets
extension ReviewListVC {
    
    func displaySortActionSheet(sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let ratingSortAction = UIAlertAction(title: "Sort by Rating", style: .default) { action -> Void in
            DispatchQueue.main.async(execute: {
                self.allReviews.sort(by: { (a, b) -> Bool in
                    return a.rating!.localizedCaseInsensitiveCompare(b.rating!) == ComparisonResult.orderedAscending
                })
                self.tableView.reloadData()
                self.tableView.setContentOffset(CGPoint.zero, animated:true)
            })
        }
        let versionSortAction = UIAlertAction(title: "Sort by Version", style: .default) { action -> Void in
            DispatchQueue.main.async(execute: {
                self.allReviews.sort(by: { (a, b) -> Bool in
                    return a.version!.localizedCaseInsensitiveCompare(b.version!) == ComparisonResult.orderedAscending
                })
                self.tableView.reloadData()
                self.tableView.setContentOffset(CGPoint.zero, animated:true)
            })
        }
        let territorySortAction = UIAlertAction(title: "Sort by Territory", style: .default) { action -> Void in
            DispatchQueue.main.async(execute: {
                self.allReviews.sort(by: { (a, b) -> Bool in
                    return a.territory!.localizedCaseInsensitiveCompare(b.territory!) == ComparisonResult.orderedAscending
                })
                self.tableView.reloadData()
                self.tableView.setContentOffset(CGPoint.zero, animated:true)
            })
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(ratingSortAction)
        alertController.addAction(versionSortAction)
        alertController.addAction(territorySortAction)
        alertController.addAction(actionCancel)
        Theme.alertController(item: alertController)
        if let popoverController = alertController.popoverPresentationController {
            popoverController.barButtonItem = sender
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    func removeEmptyTerritories(button: UIBarButtonItem){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let loadAllAction = UIAlertAction(title: "Load All Territories", style: .default) { action -> Void in
            TerritoryMgr.sharedInst.selectAllTerritories()
            self.refresh(sender: "" as AnyObject)
        }
        
        let loadDefaultAction = UIAlertAction(title: "Load Default Territories", style: .default) { action -> Void in
            let defaultTerritories = TerritoryMgr.sharedInst.getDefaultCountryCodes()
            TerritoryMgr.sharedInst.setSelectedTerritories(selectedTerritories: defaultTerritories)
            self.refresh(sender: "" as AnyObject)
        }
        
        let removeEmptyAction = UIAlertAction(title: "Remove Empty Territories", style: .destructive) { action -> Void in
            let nonEmptyTeritories = ReviewLoadManager.sharedInst.getNonEmptyTerritories()
            TerritoryMgr.sharedInst.setSelectedTerritories(selectedTerritories: nonEmptyTeritories)
            self.refresh(sender: "" as AnyObject)
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(loadAllAction)
        alertController.addAction(loadDefaultAction)
        alertController.addAction(removeEmptyAction)
        alertController.addAction(actionCancel)
        Theme.alertController(item: alertController)
        if let popoverController = alertController.popoverPresentationController {
            popoverController.barButtonItem = button
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    func displayReviewOptions(model:ReviewModel, button:UIButton) {
        
        guard let title = model.title else { return }
        let alertController = UIAlertController(title:nil, message: title, preferredStyle: .actionSheet)
        let emailAction = UIAlertAction(title: "Email", style: .default) { action -> Void in
            self.displayReviewEmail(model: model)
        }
        let translateAction = UIAlertAction(title: "Translate", style: .default) { action -> Void in
            self.displayGoogleTranslationViaSafari(model: model)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(emailAction)
        alertController.addAction(translateAction)
        alertController.addAction(cancelAction)
        
        if let popOverPresentationController : UIPopoverPresentationController = alertController.popoverPresentationController {
            popOverPresentationController.sourceView = button
            popOverPresentationController.sourceRect = button.bounds
            popOverPresentationController.permittedArrowDirections = [.right]
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func displayGoogleTranslationViaSafari(model:ReviewModel) {
        guard let title = model.title else  { return }
        guard let reviewText = model.comment else  { return }
        
        let rawUrlStr = ("http://translate.google.ca?text="+title + "\n" + reviewText) as NSString
        if let urlEncoded = rawUrlStr.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed),
            let url = NSURL(string: urlEncoded) {
            UIApplication.shared.openURL(url as URL)
        }
    }
}
