//
//  AboutVC.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-04-01.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  About with version number.
// 

import UIKit
import SpriteKit
import SwiftyGlyphs
import ElasticTransition

class AboutVC: ElasticModalViewController {

    @IBOutlet weak var skview: SKView!
    @IBOutlet weak var textView: UITextView!
    var glyphSprites:SpriteGlyphs? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func getVersion() -> String? {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        return nil
    }

    func populateText() {
        let aboutText = "\nLet me know what you think of this app!\n\nCheers,\nWoodie Dovich\n\n"
        
        textView.backgroundColor = .clear
        textView.text = aboutText
        textView.isUserInteractionEnabled = false
        textView.isSelectable = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        populateText()
        showAnimatedVersion()
    }
 
    func showAnimatedVersion() {
        guard let version = getVersion() else { return }
        if glyphSprites == nil {
            glyphSprites = SpriteGlyphs(fontName: "HelveticaNeue-Light", size:24)
        }
        
        if let glyphs = glyphSprites {
            glyphs.text = "Version "+version
            glyphs.setLocation(skview: skview, pos: CGPoint(x:0,y:30))
            glyphs.centerTextToView()
            AboutAnimation().startAnimation(glyphSprites: glyphs)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }
}
