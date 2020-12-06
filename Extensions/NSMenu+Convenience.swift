//
//  NSMenu+Generics.swift
//  RichEditor
//
//  Created by William Lumley on 1/4/18.
//  Copyright © 2018 Kampana. All rights reserved.
//

import Foundation
import AppKit

extension NSMenu
{
    public static func fontsMenu(_ title: String?) -> NSMenu
    {
        let menu = NSMenu(title: title ?? "Select a Font Family")
        
        let allFontFamilyNames = NSFontManager.shared.availableFontFamilies
        for fontName in allFontFamilyNames {
            
            let font       = NSFont(name: fontName, size: NSFont.systemFontSize)!
            let attributes = [NSAttributedString.Key.font: font]
            let attrStr    = NSAttributedString(string: fontName, attributes: attributes)
            
            let menuItem = NSMenuItem()
            menuItem.attributedTitle = attrStr
            
            menu.addItem(menuItem)
        }
        
        return menu
    }
    
    public static func fontSizesMenu(_ title: String?) -> NSMenu
    {
        let menu = NSMenu(title: title ?? "Select a Font Size")
        
        let allFontSizes = ["9", "10", "11", "12", "13", "14", "18", "24", "36", "48", "64", "72", "96", "144", "288"]
        for fontSize in allFontSizes {
            
            let font       = NSFont.systemFont(ofSize: 12)
            let attributes = [NSAttributedString.Key.font: font]
            let attrStr    = NSAttributedString(string: fontSize, attributes: attributes)
            
            let menuItem = NSMenuItem()
            menuItem.attributedTitle = attrStr
            
            menu.addItem(menuItem)
        }
        
        return menu
    }
}
