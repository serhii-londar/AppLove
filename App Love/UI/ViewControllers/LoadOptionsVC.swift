//
//  LoadOptionsVC.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-07-25.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  Activated from side menu 'Load Options'
//

import UIKit
import ElasticTransition

class LoadOptionsVC: UIViewController, ElasticMenuTransitionDelegate {

    var contentLength:CGFloat = 180
    var dismissByBackgroundTouch = true
    var dismissByBackgroundDrag = false
    var dismissByForegroundDrag = false
    
    @IBOutlet weak var loadVersionSwitch: UISwitch!
    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var sliderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.view.backgroundColor = Theme.lightestDefaultColor
        initUI()
    }
    
    func initUI() {
        slider.maximumValue = 10
        slider.minimumValue = 1
        loadVersionSwitch.isOn = Defaults.getLoadAllBool()
        slider.value = Float(Defaults.getMaxPagesToLoadInt())
        onSliderChanged(slider)
        onSwitchChanged(loadVersionSwitch)
    }
    
    @IBAction func onSwitchChanged(_ button: UISwitch) {
        if button.isOn {
            switchLabel.text = "Load All Versions"
        }
        else {
            switchLabel.text = "Load only the latest Version"
        }
        Defaults.setLoadAll(loadAll: button.isOn)
    }
    
    @IBAction func onSliderChanged(_ slider: UISlider) {
        let sliderIntValue = Int(round(slider.value))
        sliderLabel.text = "Load up to \(sliderIntValue*50) Reviews per territory"
    }
    
    @IBAction func onSliderTouchUpInside(_ sender: UISlider) {
        snapSaveSlider(slider: slider)
    }
    
    @IBAction func onSliderTouchUpOutside(_ slider: UISlider) {
        snapSaveSlider(slider: slider)
    }
    
    func snapSaveSlider(slider:UISlider) {
        let sliderIntValue = Int(round(slider.value))
        let snapValue = Float(sliderIntValue)
        slider.value = snapValue
        Defaults.setMaxPagesToLoad(maxPages: sliderIntValue)
    }
}
