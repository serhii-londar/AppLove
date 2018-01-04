//
//  ReviewListVC+StoreKit.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-08-18.
//  Copyright © 2016 Snowpunch. All rights reserved.
//

import UIKit
import StoreKit

// app store
extension ReviewListVC: SKStoreProductViewControllerDelegate {
    
    func showStore(id:Int) {
        let storeViewController = SKStoreProductViewController()
        storeViewController.delegate = self
        let parameters = [SKStoreProductParameterITunesItemIdentifier :
            NSNumber(value: id)]
        storeViewController.loadProduct(withParameters: parameters,
                                                      completionBlock: {result, error in
                                                        if result {
                                                            self.present(storeViewController,
                                                                animated: true, completion: nil)
                                                            // remove loading animation
                                                        }
        })
    }
    
    func productViewControllerDidFinish(viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}
