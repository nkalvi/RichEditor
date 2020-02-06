//
//  RichTextView.swift
//  RichEditor
//
//  Created by William Lumley on 6/2/20.
//

import Foundation

public enum CommandShortcut: String
{
    case b = "b"
    case i = "i"
    case u = "u"
    case plus  = "+"
    case minus = "-"
}

public protocol KeyboardShortcutDelegate
{
    func commandPressed(character: CommandShortcut)
}

public class RichTextView: NSTextView
{
    //MARK: - Properties
    public fileprivate(set) var keyboardShortcutDelegate: KeyboardShortcutDelegate?
    
    //MARK: - NSTextView
    init(frame frameRect: NSRect, textContainer container: NSTextContainer?, delegate: KeyboardShortcutDelegate)
    {
        self.keyboardShortcutDelegate = delegate
        super.init(frame: frameRect, textContainer: container)
    }
    
    override init(frame frameRect: NSRect, textContainer container: NSTextContainer?)
    {
        super.init(frame: frameRect, textContainer: container)
    }
    
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
    }
    
    override init(frame frameRect: NSRect)
    {
        super.init(frame: frameRect)
    }
    
    override public func performKeyEquivalent(with event: NSEvent) -> Bool
    {
        //Only process our event if it's a keydown event
        if event.type != .keyDown {
            return super.performKeyEquivalent(with: event)
        }
        
        //If the command button was NOT pressed down
        if !event.modifierFlags.contains(.command) {
            return super.performKeyEquivalent(with: event)
        }
        
        guard let characters = event.charactersIgnoringModifiers else { return super.performKeyEquivalent(with: event) }
        guard let shortcut = CommandShortcut(rawValue: characters) else { return super.performKeyEquivalent(with: event) }
        
        self.keyboardShortcutDelegate?.commandPressed(character: shortcut)
        
        return super.performKeyEquivalent(with: event)
    }
}
