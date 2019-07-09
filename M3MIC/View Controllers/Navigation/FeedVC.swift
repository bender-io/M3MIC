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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        pushToDetailVC()
    }
    
    func setupTabBarUI() {
        tabBarController?.tabBar.barStyle = .black
        tabBarController?.tabBar.isTranslucent = true
    }
    
    func pushToDetailVC() {
        let feedDetailVC = UIStoryboard.init(name: "Feed", bundle: Bundle.main).instantiateViewController(withIdentifier: "FeedDetailVC") as? FeedDetailVC
        
        if PostController.shared.postWasCreated {
            
            PostController.shared.postWasCreated = false
            navigationController?.pushViewController(feedDetailVC ?? UIViewController(), animated: true)
        }
    }
}
