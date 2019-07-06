//
//  MemicButtonText.swift
//  M3MIC
//
//  Created by Brian Hersh on 7/6/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class MemicButtonText: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() {
        self.backgroundColor = .clear
        self.setTitleColor(.secondary, for: .normal)
    }
}
