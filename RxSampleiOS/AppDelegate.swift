//
//  AppDelegate.swift
//  RxSampleiOS
//
//  Created by Kyle on 5/17/19.
//  Copyright © 2019 Blue Bottle Coffee. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.makeKeyAndVisible()
    window?.rootViewController = RootViewController()

    return true
  }
}
