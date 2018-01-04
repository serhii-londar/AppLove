//
//  ReviewListVC.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-02-24.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  Display reviews for an app, for every territory selected.
// 

import UIKit


private extension Selector {
    static let reloadData = #selector(UITableView.reloadData)
    static let onReviewOptions = #selector(ReviewListVC.onReviewOptions)
}

class ReviewListVC: UIViewController {
    
    var allReviews = [ReviewModel]()
    var refreshControl: UIRefreshControl!
    @IBOutlet var tableView: UITableView!

    // Territory Loading UICollectionView acting as a visual loader.
    @IBOutlet weak var appIcon: UIImageView!
    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var aveRating: UILabel!
    @IBOutlet weak var territoryCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableSetup()
        registerNotifications()
        addRefreshControl()
        registerTerritoryNotificationsForLoader()
        
        if let toolbar = self.navigationController?.toolbar {
            Theme.toolBar(item: toolbar)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let _ = AppList.sharedInst.getSelectedModel() {
            setupCollection()
            ReviewLoadManager.sharedInst.loadReviews()
        }
        else {
            showEmptyView()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ReviewLoadManager.sharedInst.cancelLoading()
    }
    
    func onReviewOptions(notification: NSNotification) {
        guard let dic = notification.userInfo else { return }
        guard let model = dic["reviewModel"] as? ReviewModel else { return }
        guard let button = dic["button"] as? UIButton else { return }
        displayReviewOptions(model: model, button:button)
    }
    
    func registerNotifications() {
        NotificationCenter.addObserver(observer: self, sel: .reloadData, name: Const.load.reloadData)
        NotificationCenter.addObserver(observer: self,sel: .onReviewOptions, name: Const.reviewOptions.showOptions)
    }
    
    func unregisterNotifications() {
        NotificationCenter.default.removeObserver(self)
    }

    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        NotificationCenter.post(aName: Const.load.orientationChange)
    }
    
    @IBAction func onSort(sender: UIBarButtonItem) {
        displaySortActionSheet(sender: sender)
    }
    
    @IBAction func onAppStore(sender: AnyObject) {
        // show loading indicator.
        if let appId = AppList.sharedInst.getSelectedModel()?.appId {
            showStore(id: appId)
        }
    }
    
    @IBAction func onRemoveEmptyTerritories(button: UIBarButtonItem) {
        removeEmptyTerritories(button: button)
    }
    
    deinit {
        unregisterNotifications()
    }
}
