//
//  AppDelegate.swift
//  FaceDetect
//
//  Created by Nguyen Le Minh on 9/26/19.
//  Copyright © 2019 Nguyen Le Minh. All rights reserved.
//

import UIKit
import Crashlytics
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        Fabric.sharedSDK().debug = true
        
        application.isIdleTimerDisabled = true
        self.window?.makeKeyAndVisible()
        return true
    }
}

