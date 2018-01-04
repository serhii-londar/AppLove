//
//  AppListVC.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-08-18.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  The main view. Can reorder or delete apps.
//

import UIKit
import ElasticTransition

private extension Selector {
    static let onMenuClose = #selector(AppListVC.onMenuClose)
    static let onMenuOpen = #selector(AppListVC.onMenuOpen)
}

class AppListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var hamburgerButton: HamburgerButton!
    var transition = ElasticTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        displayAppList()
        initElasticTransitions()
        addObservers()
        addMenuObservers()
        
        if let toolbar = self.navigationController?.toolbar {
            Theme.toolBar(item: toolbar)
        }
        
        self.splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.automatic
    }
    
    func addObservers() {
        NotificationCenter.addObserver(observer: self, sel: .onMenuOpen, name: Const.sideMenu.openMenu)
        NotificationCenter.addObserver(observer: self, sel: .onMenuClose, name: Const.sideMenu.closeMenu)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (SearchList.sharedInst.appModelDic.count > 0) {
            addAppsSelectedFromSearchResults()
        }
        
        if hamburgerButton.showsMenu == false {
            hamburgerButton.showsMenu = true
        }
        self.navigationController?.isToolbarHidden = false
    }
    
    
    
    // apps to display initially, to check out how the app functions
    func loadDefaultApps () {
        let defaultAppIds = [Const.appId.MusketSmoke, Const.appId.AppLove]
        
        for appId:Int in defaultAppIds {
            AppInfo.get(appID: String(appId)) { (model, succeeded, error) -> Void in
                
                // add an app model
                if let appModel = model {
                    AppList.sharedInst.addAppModel(model: appModel)
                }
                
                let finishedLoading = (defaultAppIds.count == AppList.sharedInst.appModels.count)
                if (finishedLoading)
                {
                    DispatchQueue.main.async {
                        AppList.sharedInst.save()
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    @IBAction func onSideMenuButton(button: HamburgerButton) {
        button.showsMenu = false // morphs to arrow
        onMenuOpen()
    }
    
    func onMenuClose() {
        hamburgerButton.showsMenu = true // morphs arrow back to menu button.
    }
    
    func displayAppList() {
        if (AppList.sharedInst.load() == false) {
            loadDefaultApps()
        }
    }
    
    func addAppsSelectedFromSearchResults() {
        let newApps = SearchList.sharedInst.getArray()
        AppList.sharedInst.appModels.append(contentsOf: newApps)
        SearchList.sharedInst.removeAll()
        
        DispatchQueue.main.async {
            AppList.sharedInst.save()
            self.tableView.reloadData()
        }
    }
    
    @IBAction func onSearch(sender: AnyObject) {
        performSegue(withIdentifier: "AppSearch", sender: nil)
    }
    
    @IBAction func editMode(sender: UIBarButtonItem) {
        if (self.tableView.isEditing) {
            sender.title = "Edit"
            self.tableView.setEditing(false, animated: true)
        } else {
            sender.title = "Done"
            self.tableView.setEditing(true, animated: true)
        }
    }
    
    func addSplitViewCollapseButton(segue:UIStoryboardSegue) {
        var destination = segue.destination
        if let nc = destination as? UINavigationController,
            let visibleVC = nc.visibleViewController {
            destination = visibleVC
            destination.navigationItem.leftBarButtonItem =
                self.splitViewController?.displayModeButtonItem
            destination.navigationItem.leftItemsSupplementBackButton = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailReviews" {
            addSplitViewCollapseButton(segue: segue)
            return
        }
        
        let vc = segue.destination
        vc.transitioningDelegate = transition
        vc.modalPresentationStyle = .custom
    }
}
