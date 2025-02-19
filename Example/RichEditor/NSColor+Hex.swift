//
//  NSColor+Hex.swift
//  RichEditor_Example
//
//  Created by William Lumley on 31/1/20.
//  Copyright © 2020 William Lumley. All rights reserved.
//

import AppKit

extension NSColor {

    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue  & 0xff
        
        self.init(
            red: CGFloat(r)   / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b)  / 0xff,
            alpha: 1
        )
    }

}
