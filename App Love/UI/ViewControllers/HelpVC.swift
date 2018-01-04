//
//  HelpVC.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-03-28.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  Help info (includes number of territories selected).
// 

import UIKit
import SpriteKit
import SwiftyGlyphs

class HelpVC: ElasticModalViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var skview: SKView!
    var glyphSprites:SpriteGlyphs? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateHelpText()
    }

    func populateHelpText() {
        let territoriesSelected = TerritoryMgr.sharedInst.getSelectedCountryCodes().count
        let allTerritories = TerritoryMgr.sharedInst.getTerritoryCount()

        let helpText = "TIPS:\n\nCurrently there are \(territoriesSelected) territories selected out of a possible \(allTerritories).\n\nWhen selecting territories manually, the ALL button toggles between ALL and CLEAR.\n\nAfter viewing a translation, return back to this app by tapping the top left corner.\n"

        textView.backgroundColor = .clear
        textView.text = helpText
        textView.isUserInteractionEnabled = false
        textView.isSelectable = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showAnimatedText()
    }
    
    func fixCutOffTextAfterRotation() {
        textView.isScrollEnabled = false
        textView.isScrollEnabled = true
    }
    
    override func willAnimateRotation(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        fixCutOffTextAfterRotation()
    }
    
    func showAnimatedText() {
        if glyphSprites == nil {
            glyphSprites = SpriteGlyphs(fontName: "HelveticaNeue-Light", size:24)
        }
        
        if let glyphs = glyphSprites {
            glyphs.text = "At Your Service!"
            glyphs.setLocation(skview: skview, pos: CGPoint(x:0,y:20))
            glyphs.centerTextToView()
            HelpAnimation().startAnimation(glyphSprites: glyphs, viewWidth:skview.frame.width)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }
}
