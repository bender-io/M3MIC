//
//  MemicTF.swift
//  M3MIC
//
//  Created by Brian Hersh on 7/6/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class MemicTF: UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func updatePlaceholderColor() {
        let currentPlaceholderText = self.placeholder
        self.attributedPlaceholder = NSAttributedString(string: currentPlaceholderText ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white100 as Any])
    }
    
    func updateFontTo(fontName: String) {
        guard (self.font?.pointSize) != nil else { return }
        self.font = UIFont(name: fontName, size: 13)
    }
    
    func setupUI() {
        updatePlaceholderColor()
        keyboardAppearance = UIKeyboardAppearance.dark
        self.textColor = .white100
        self.backgroundColor = .gradiantMedium
        self.cornerRadios(10)
    }
}
