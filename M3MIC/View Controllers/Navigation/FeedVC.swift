//
//  FeedVC.swift
//  M3MIC
//
//  Created by Brian Hersh on 7/7/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
        setupTabBarUI()
        GifController.shared.fetchGifURL(searchTerm: "puppy") { (success) in
            if success {
                DispatchQueue.main.async {
                    print(GifController.shared.tinyGifs as Any)
                }
            }
        }
    }
    
    func setupTabBarUI() {
        tabBarController?.tabBar.barStyle = .black
        tabBarController?.tabBar.isTranslucent = true
    }
}
