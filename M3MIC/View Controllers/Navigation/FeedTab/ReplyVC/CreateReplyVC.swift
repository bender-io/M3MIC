//
//  CreateReplyVC.swift
//  M3MIC
//
//  Created by Brian Hersh on 7/17/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class CreateReplyVC: UIViewController {

    var image: UIImage?
    
    @IBOutlet weak var gifImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
        gifImage.image = image
    }
    
}
