//
//  AppDelegate.swift
//  M3MIC
//
//  Created by Brian Hersh on 7/6/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseAuth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let login: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
    let navigation: UIStoryboard = UIStoryboard(name: "Navigation", bundle: nil)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        if Auth.auth().currentUser != nil {
            let navigationVC = navigation.instantiateViewController(withIdentifier: "NavigationTBC")
            UIApplication.shared.windows.first!.rootViewController = navigationVC
        } else {
            let loginVC = login.instantiateViewController(withIdentifier: "LoginVC")
            UIApplication.shared.windows.first!.rootViewController = loginVC
        }
        return true
    }
}

