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
        fetchUrls(searchTerm: "wild west")
        setupTabBarUI()
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

// MARK: - Fetch Methods
extension FeedVC {
    
    func fetchUrls(searchTerm: String) {
        
        GifController.shared.fetchGifUrls(searchTerm: searchTerm) { (success) in
            if success {
                DispatchQueue.main.async {
                    print("\(String(describing: GifController.shared.gifs))")
                    self.fetchGifs()
                }
            }
        }
    }
    
    func fetchGifs() {
        guard let gifs = GifController.shared.gifs else { return }
        
        GifController.shared.fetchGifsFromUrls(tinygifs: gifs) { (success) in
            DispatchQueue.main.async {
                if success {
                    print("UIImage \(GifController.shared.gifImageArray.count)")
                }
            }
        }
    }
}
