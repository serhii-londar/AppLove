//
//  AppListVC+elastic.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-08-18.
//  Copyright © 2016 Snowpunch. All rights reserved.
//

import Foundation
import ElasticTransition

// elastic extensions
extension AppListVC {

    func initElasticTransitions(){
        transition.stiffness = 0.7
        transition.damping = 0.40
        transition.stiffness = 1
        transition.damping = 0.75
        transition.transformType = .translateMid
    }

    func displayElasticOptions(viewControlerId:String) {
        if let storyboard = self.storyboard {
            let aboutVC = storyboard.instantiateViewController(withIdentifier: viewControlerId)
            aboutVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            transition.edge = .bottom
            transition.startingPoint = CGPoint(x:30,y:70)
            transition.stiffness = 1
            transition.damping = 0.75
            transition.showShadow = true
            transition.transformType = .rotate
            aboutVC.transitioningDelegate = transition
            aboutVC.modalPresentationStyle = .custom
            present(aboutVC, animated: true, completion: nil)
        }
    }

    func elasticPresentViewController(storyBoardID:String) {
        if let storyboard = self.storyboard {
            let aboutVC = storyboard.instantiateViewController(withIdentifier: storyBoardID)
            transition.edge = .right
            transition.startingPoint = CGPoint(x:30,y:70)
            transition.stiffness = 1
            transition.damping = 0.75
            aboutVC.transitioningDelegate = transition
            aboutVC.modalPresentationStyle = .custom
            present(aboutVC, animated: true, completion: nil)
        }
    }

    func openElasticMenu() {
        transition.edge = .left
        transition.startingPoint = CGPoint(x:30,y:70)
        transition.showShadow = false
        transition.transformType = .translateMid
        performSegue(withIdentifier: "menu", sender: self)
    }
}
