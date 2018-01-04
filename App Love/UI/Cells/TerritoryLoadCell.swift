//
//  TerritoryLoadCell.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-08-10.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  A flag/count cell as part of a UICollectionView that doubles as a loading
//  indicator. Up to 4 will load at once via NSOperation. You can scroll this
//  UICollectionView left and right.
//

import UIKit

class TerritoryLoadCell: UICollectionViewCell {

    @IBOutlet weak var bar: UIView!
    @IBOutlet weak var flagIcon: UIImageView!
    @IBOutlet weak var countLabel: UILabel!
    var territory = ""
   

    func setup(loadState:LoadState) {
        countLabel.text = "0" //loadState.territory
        flagIcon.image = nil
        flagIcon.image = UIImage(named:loadState.territory)
        self.territory = loadState.territory
        bar.layer.cornerRadius = 8

        registerNotifications()
        
        if let loadState = ReviewLoadManager.sharedInst.loadStates[territory] {
            countLabel.text = "\(loadState.count)"
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        bar.alpha = 1
        bar.backgroundColor = UIColor.white
        countLabel.text = "0"
        flagIcon.image = nil
    }
    
    func registerNotifications() {
        unregisterNotifications()
        NotificationCenter.addObserver(observer: self,sel:.loadStart, name: Const.load.loadStart)
        NotificationCenter.addObserver(observer: self,sel:.updateAmount, name: Const.load.updateAmount)
        NotificationCenter.addObserver(observer: self,sel:.dataError, name: Const.load.dataError)
        NotificationCenter.addObserver(observer: self,sel:.territoryStarted, name: Const.load.territoryStart)
        NotificationCenter.addObserver(observer: self,sel:.territoryCompleted, name: Const.load.territoryDone)
    }
    
    func updateAmount(notification: NSNotification) {
        guard let dic = notification.userInfo else { return }
        guard let ter = dic["territory"] as? String else { return }
        
        if territory == ter {
            guard let loadState = dic["loadState"] as? LoadState else { return }
            bar.backgroundColor = UIColor.green
            countLabel.text = "\(loadState.count)"
        }
    }
    
    func territoryStarted(notification: NSNotification) {
        guard let dic = notification.userInfo else { return }
        guard let ter = dic["territory"] as? String else { return }
        if territory == ter {
            bar.backgroundColor = UIColor.green
            self.bar.alpha = 1
        }
    }
    
    func territoryCompleted(notification: NSNotification) {
        guard let dic = notification.userInfo else { return }
        guard let ter = dic["territory"] as? String else { return }
        if territory == ter {
            bar.backgroundColor = UIColor.green
            UIView.animate(withDuration: 0.5, animations: { () -> Void in // shift down
                self.bar.alpha = 0
            })
        }
    }
    
    func dataError(notification: NSNotification) {
        guard let dic = notification.userInfo else { return }
        guard let ter = dic["territory"] as? String else { return }
        if territory == ter {
            bar.backgroundColor = UIColor.red
        }
    }
    
    func loadStart() {
        registerNotifications()
        bar.backgroundColor = UIColor.white
    }
    
    func unregisterNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    deinit {
        unregisterNotifications()
        flagIcon.image = nil
    }

}

private extension Selector {
    static let loadStart = #selector(TerritoryLoadCell.loadStart)
    static let dataError = #selector(TerritoryLoadCell.dataError(notification:))
    static let territoryStarted = #selector(TerritoryLoadCell.territoryStarted(notification:))
    static let territoryCompleted = #selector(TerritoryLoadCell.territoryCompleted(notification:))
    static let updateAmount = #selector(TerritoryLoadCell.updateAmount(notification:))
}
