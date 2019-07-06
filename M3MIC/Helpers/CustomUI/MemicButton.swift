//
//  MemicButton.swift
//  M3MIC
//
//  Created by Brian Hersh on 7/6/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class MemicButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() {
        self.backgroundColor = .secondary
        self.cornerRadios()
        self.setTitleColor(.white100, for: .normal)
    }
}
