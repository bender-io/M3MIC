//
//  MemicTV.swift
//  M3MIC
//
//  Created by Brian Hersh on 7/8/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class MemicTV: UITextView {

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() {
        self.cornerRadios()
    }
    
}
