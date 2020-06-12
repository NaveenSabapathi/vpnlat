//
//  AppDelegate.swift
//  VPN.lat
//
//  Created by user173177 on 5/29/20.tr
//  Copyright © 2020 user173177. All rights reserved.
//

import UIKit
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window:UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
     
         GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        return true
    }

}

