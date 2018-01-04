//
//  HelpAnimation.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-04-24.
//  Copyright © 2016 Snowpunch. All rights reserved.
//

import SpriteKit
import SwiftyGlyphs

class HelpAnimation {
    
    func startAnimation(glyphSprites:SpriteGlyphs, viewWidth:CGFloat) {
        let sprites = glyphSprites.getSprites()
        let rotate = SKAction.rotate(byAngle: CGFloat(-M_PI*2), duration: 1)
        rotate.timingFunction = Timing.circularEaseInOut
        let scaleUp = SKAction.scale(to: 1.0,  duration: 0.9)
        scaleUp.timingFunction = Timing.circularEaseInOut
        
        glyphSprites.centerTextToView()
        glyphSprites.getWidthOfText()
        
        var wait:Double = 0
        for glyph in sprites {
            glyph.setScale(0.0)
            glyph.position = CGPoint(x: viewWidth/2,y: 50)
            wait += 0.03
            let delay = SKAction.wait(forDuration: wait)
            let pos = glyph.userData?["homeX"] as! CGFloat
            let move = SKAction.move(to: CGPoint(x: pos,y: 25),duration: 0.8)
            move.timingFunction = Timing.circularEaseInOut
            let group = SKAction.group([rotate,move,scaleUp])
            let seq = SKAction.sequence([delay, group])
            
            glyph.run(seq) {
                if glyph == sprites.last {
                    self.wavingExclamationAnimation(exclamation: glyph)
                }
            }
        }
    }
    
    private func wavingExclamationAnimation(exclamation:SKSpriteNode) {
        let rotateRight = SKAction.rotate(toAngle: CGFloat(-M_PI/12), duration: 0.5)
        rotateRight.timingFunction = Timing.snappyEaseOut
        let rotateLeft = SKAction.rotate(toAngle: CGFloat(M_PI/12), duration: 0.5)
        rotateLeft.timingFunction = Timing.snappyEaseOut
        let rotateReset = SKAction.rotate(toAngle: 0, duration: 0.0)
        let wave = SKAction.repeatForever(SKAction.sequence([rotateLeft,rotateRight]))
        
        exclamation.run(rotateReset) {
            exclamation.position.y = exclamation.position.y - 8
            exclamation.anchorPoint = CGPoint(x: 0.5,y: 0.2)
            exclamation.run(wave)
        }
    }
}
