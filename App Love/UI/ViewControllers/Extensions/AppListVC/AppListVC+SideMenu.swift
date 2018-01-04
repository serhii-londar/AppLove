//
//  AppListVC+SideMenu.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-08-18.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  Side Menu
//

import Foundation
import MessageUI

private extension Selector {
    static let onTerritoryOptions = #selector(AppListVC.onTerritoryOptions)
    static let onLoadOptions = #selector(AppListVC.onLoadOptions)
    static let onShare = #selector(AppListVC.onShare)
    static let onAskReview = #selector(AppListVC.onAskReview)
    static let onAbout = #selector(AppListVC.onAbout)
    static let onHelp = #selector(AppListVC.onHelp)
}

extension AppListVC {
    
    func addMenuObservers() {
        NotificationCenter.addObserver(observer: self, sel: .onTerritoryOptions, name: Const.sideMenu.territories)
        NotificationCenter.addObserver(observer: self, sel: .onLoadOptions, name: Const.sideMenu.loadOptions)
        NotificationCenter.addObserver(observer: self, sel: .onShare, name: Const.sideMenu.share)
        NotificationCenter.addObserver(observer: self, sel: .onAskReview, name: Const.sideMenu.askReview)
        NotificationCenter.addObserver(observer: self, sel: .onHelp, name: Const.sideMenu.help)
        NotificationCenter.addObserver(observer: self, sel: .onAbout, name: Const.sideMenu.about)
    }
    
    func onLoadOptions() {
        displayElasticOptions(viewControlerId: "loadOptions")
    }
    
    func onHelp() {
        elasticPresentViewController(storyBoardID: "help")
    }
    
    func onAbout() {
        elasticPresentViewController(storyBoardID: "about")
    }
    
    func onMenuOpen() {
        openElasticMenu()
    }
    
    func onTerritoryOptions(sender: AnyObject) {
        performSegue(withIdentifier: "selectCountry", sender: nil)
    }
    
    func onShare(sender: AnyObject) {
        displayAppListComposerEmail()
    }
    
    func doAppReview() {
        let urlStr = "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1099336831";
        
        if let reviewURL =  NSURL(string:urlStr) {
            DispatchQueue.main.async {
                UIApplication.shared.openURL(reviewURL as URL);
            }
        }
    }
    
    func onAskReview(sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "You're Awesome!", message: "Thank you for helping this app.\nApp Love needs your feedback.", preferredStyle: .alert)
        let addReviewAction = UIAlertAction(title: "add review", style: .default) { action -> Void in
            self.doAppReview()
        }
        addReviewAction.setValue(UIImage(named: "heartplus"), forKey: "image")
        let addStarsAction = UIAlertAction(title: "or just tap stars", style: .default) { action -> Void in
            self.doAppReview()
        }
        addStarsAction.setValue(UIImage(named: "rating"), forKey: "image")
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(addReviewAction)
        alertController.addAction(addStarsAction)
        alertController.addAction(cancelAction)
        //Theme.alertController(alertController)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension AppListVC: MFMailComposeViewControllerDelegate {
    
    func displayAppListComposerEmail() {
        if MFMailComposeViewController.canSendMail() {
            let appListMailComposerVC = AppListEmail.generateAppList()
            appListMailComposerVC.mailComposeDelegate = self
            Theme.mailBar(bar: appListMailComposerVC.navigationBar)
            self.present(appListMailComposerVC, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
