//
//  AppListEmail.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-07-27.
//  Copyright © 2016 Snowpunch. All rights reserved.
//

import UIKit
import MessageUI

class AppListEmail: NSObject {

    class func generateAppList() -> MFMailComposeViewController {
        
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.setSubject("App Links")
        let appModels = AppList.sharedInst.appModels
        var msgBody = "<small><b>Check out these Apps!</b><br></small>"

        for app in appModels {
            let appName = truncateAppName(originalAppName: app.appName)
            msgBody += "<small><a href='https://itunes.apple.com/app/id\(app.appId)'>\(appName)</a></small><br>"
        }
        
        let appLovePlug = "<small><br>List generated by <a href='https://itunes.apple.com/app/id\(Const.appId.AppLove)'>App Love.</a></small>"
        msgBody += appLovePlug

        mailComposerVC.setMessageBody(msgBody, isHTML: true)
        return mailComposerVC
    }
    
    // cut off app name at '-' dash, then limit to 30 characters for email.
    class func truncateAppName(originalAppName:String?) -> String {
//        let fullAppName = originalAppName ?? ""
//        let fullNameArray = fullAppName.characters.split(separator: "-")//.map{ String($0) }
//        var appName = fullNameArray.first ?? ""
//        if appName != fullAppName {
//            appName = appName + "..."
//        }
//        let truncatedAppName = appName.truncate(30)
        return originalAppName ?? ""
    }
}
