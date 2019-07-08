//
//  NewPostVC.swift
//  M3MIC
//
//  Created by Brian Hersh on 7/7/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class PostVC: UIViewController {

    @IBOutlet weak var postTV: MemicTV!
    @IBOutlet weak var publicSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        postTV.becomeFirstResponder()
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        tabBarController?.selectedIndex = 0
    }
    
    @IBAction func publicSwitchTapped(_ sender: Any) {
    }
}
