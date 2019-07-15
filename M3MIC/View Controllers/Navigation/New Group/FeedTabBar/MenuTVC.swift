//
//  MenuTVC.swift
//  M3MIC
//
//  Created by Brian Hersh on 7/13/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

protocol MenuDelegate: class {
    func menuButtonTapped()
}

class MenuTVC: UITableViewController {

    weak var delegate: MenuDelegate?
    var showMenu = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.isHidden = true
    }

    func switchMenu() {
        if showMenu {
            view.isHidden = true
        } else {
            view.isHidden = false
        }
        showMenu = !showMenu
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
}
