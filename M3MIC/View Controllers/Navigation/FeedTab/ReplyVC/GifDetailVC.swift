//
//  GifDetailVC.swift
//  M3MIC
//
//  Created by Brian Hersh on 7/15/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

protocol GifDetailVCDelegate: class {
    func reloadTableView()
}

class GifDetailVC: UIViewController {
        
    @IBOutlet weak var gifTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadViewIfNeeded()
        viewSetup()
    }
}

extension GifDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return GifController.shared.gifImageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gifCell") as? GifDetailCell
        let gif = GifController.shared.gifImageArray[indexPath.row]
        cell?.gifImage.image = gif
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
}
