//
//  SideMenuVC
//  App Love
//
//  Created by Woodie Dovich on 2016-06-08.
//  Copyright © 2016 Snowpunch. All rights reserved.
//

import UIKit
import ElasticTransition

private extension Selector {
    static let onMenuClose = #selector(SideMenuVC.onMenuClose)
}

class SideMenuVC: UIViewController {
    
    // ElasticMenu props
    var contentLength:CGFloat = 160
    var dismissByBackgroundTouch = true
    var dismissByBackgroundDrag = true
    var dismissByForegroundDrag = true
    var transition = ElasticTransition()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Theme.defaultColor
    }

    func onMenuClose() {
        self.dismiss(animated: true, completion:nil)
    }
    
    func sideMenuButtonPressed(notificationStrConst:String) {
        self.dismiss(animated: true) {
            NotificationCenter.post(aName: notificationStrConst)
        }
    }

    @IBAction func onTerritoryOptions(_ sender: AnyObject) {
        sideMenuButtonPressed(notificationStrConst: Const.sideMenu.territories)
    }
    
    @IBAction func onLoadOptions(_ sender: AnyObject) {
        sideMenuButtonPressed(notificationStrConst: Const.sideMenu.loadOptions)
    }
    
    @IBAction func onShareAppList(_ sender: AnyObject) {
        sideMenuButtonPressed(notificationStrConst: Const.sideMenu.share)
    }
    
    @IBAction func onAddAppReview(_ sender: AnyObject) {
        sideMenuButtonPressed(notificationStrConst: Const.sideMenu.askReview)
    }
    
    @IBAction func onHelp(_ sender: AnyObject) {
        sideMenuButtonPressed(notificationStrConst: Const.sideMenu.help)
    }
    
    @IBAction func onAbout(_ sender: AnyObject) {
        sideMenuButtonPressed(notificationStrConst: Const.sideMenu.about)
    }
}

extension SideMenuVC: ElasticMenuTransitionDelegate {
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.post(aName: Const.sideMenu.closeMenu) // makes menu button morph back from arrow
    }
}
