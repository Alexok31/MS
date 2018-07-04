//
//  AppDelegate.swift
//  myMesseger
//
//  Created by Александр Харченко on 15.05.2018.
//  Copyright © 2018 Александр Харченко. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseService.configure()
        return true
    }
}

