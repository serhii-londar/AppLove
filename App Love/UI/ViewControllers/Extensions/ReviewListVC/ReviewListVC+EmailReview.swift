//
//  ReviewListVC+EmailReview.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-08-18.
//  Copyright © 2016 Snowpunch. All rights reserved.
//

import UIKit
import MessageUI

extension ReviewListVC: MFMailComposeViewControllerDelegate {
    func displayReviewEmail(model:ReviewModel) {
        if MFMailComposeViewController.canSendMail() {
            let reviewMailComposerVC = ReviewEmail.generateSingleReviewEmail(reviewModel: model)
            reviewMailComposerVC.mailComposeDelegate = self
            Theme.mailBar(bar: reviewMailComposerVC.navigationBar)
            self.present(reviewMailComposerVC, animated: true, completion: nil)
        }
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
