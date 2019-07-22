//
//  DateFormatter.swift
//  M3MIC
//
//  Created by Brian Hersh on 7/22/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import Foundation

extension Date {
    func stringWith(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        return formatter.string(from: self)
    }
}
