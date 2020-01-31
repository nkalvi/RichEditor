//
//  ViewController.swift
//  RichEditor_Example
//
//  Created by Will Lumley on 30/1/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import AppKit
import RichEditor

class ViewController: NSViewController
{
    @IBOutlet weak var richEditor: RichEditor!
    
    @IBOutlet weak var boldButton: NSButton!
    @IBOutlet weak var italicsButton: NSButton!
    @IBOutlet weak var underlineButton: NSButton!
    
    @IBOutlet var imageButton: NSButton!
    @IBOutlet var textColourTextField: NSTextField!
    @IBOutlet var addLinkButton: NSButton!
    
    @IBOutlet var highlightColourTextField: NSTextField!
    @IBOutlet var strikeButton: NSButton!
    @IBOutlet weak var bulletPointButton: NSButton!
    
    @IBOutlet weak var fontFamiliesPopUpButton: NSPopUpButton!
    @IBOutlet weak var fontSizePopUpButton: NSPopUpButton!
    
    fileprivate var previewTextViewController : PreviewTextViewController?
    fileprivate var previewTextViewController2: PreviewTextViewController?
    fileprivate var previewWebViewController: PreviewWebViewController?
    
    //MARK: - NSViewController
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.configureUI()
        
        self.openPreviewTextWindow()
        self.openPreviewWebWindow()
        self.openPreviewTextWindow2()
    }
    
    override func viewDidAppear()
    {
        super.viewDidAppear()
        
        if let window = self.view.window {
            window.title = "1. Rich Editor"
        }
    }
    
    fileprivate func configureUI()
    {
        //self.textColourButton.delegate = self
        //self.highlightColourButton.delegate = self
        
        self.richEditor.richEditorDelegate = self
        //self.richEditor.textView.string      = "The quick brown fox jumped over the lazy dog."
        //self.richEditor.textView.importsGraphics = false
        
        self.boldButton.title    = "Bold"
        self.italicsButton.title = "Italic"
        
        self.fontFamiliesPopUpButton.menu = NSMenu.fontsMenu(nil)
        self.fontSizePopUpButton.menu     = NSMenu.fontSizesMenu(nil)
    }
    
    fileprivate func setupKeyboardShortcuts()
    {
        
    }

}

//MARK: - Actions
extension ViewController
{
    @IBAction func boldButtonTapped(_ sender: Any)
    {
        self.richEditor.toggleBold()
    }
    
    @IBAction func italicButtonTapped(_ sender: Any)
    {
        self.richEditor.toggleItalic()
    }
    
    @IBAction func underlineButtonTapped(_ sender: Any)
    {
        self.richEditor.toggleUnderline(.single)
    }
    
    @IBAction func linkButtonTapped(_ sender: Any)
    {
        let name = "Google"
        let url  = "https://google.com"
        
        self.richEditor.insert(link: url, with: name, at: nil)
    }
    
    @IBAction func addImageButtonTapped(_ sender: Any)
    {
        self.richEditor.promptUserForAttachments(windowForModal: self.view.window)
    }
    
    @IBAction func strikeButtonTapped(_ sender: Any)
    {
        self.richEditor.toggleStrikethrough(.single)
    }
    
    @IBAction func bulletPointButtonTapped(_ sender: Any)
    {
        self.richEditor.startBulletPoints()
    }
    
    @IBAction func fontFamiliesButtonClicked(_ sender: Any)
    {
        self.applyFont()
    }
    
    @IBAction func fontSizeButtonClicked(_ sender: Any)
    {
        self.applyFont()
    }
}

//MARK: - RichEditorDelegate
extension ViewController: RichEditorDelegate
{
    func fontStylingChanged(_ fontStyling: FontStyling)
    {
        self.configureTextActionButtonsUI()
    }
    
    func richEditorTextChanged(_ richEditor: RichEditor)
    {
        var htmlOpt: String?
        
        do {
            htmlOpt = try richEditor.html()
        }
        catch let error {
            print("Error creating HTML from NSAttributedString: \(error)")
        }
        
        guard let html = htmlOpt else {
            print("HTML from NSAttributedString was nil")
            return
        }
        
        //Parse the HTML into a WebView and display the contents
        self.previewWebViewController?.webView.loadHTMLString(html, baseURL: nil)
        
        //Assign the raw HTML text so we can see the actual HTML content
        self.previewTextViewController?.previewTextView.string = html
        
        //Convert the HTML text back into an NSAttributedString and have it displayed
        _ = self.previewTextViewController2?.previewTextView.set(html: html)

    }
    
    
}

//MARK: - Functions
extension ViewController
{
    fileprivate func configureTextActionButtonsUI()
    {
        let fontStyling = self.richEditor.fontStyling()
        
        //Configure the Bold UI
        switch (fontStyling.boldTrait()) {
            case .hasTrait:
                self.boldButton.title = "Unbold"
            
            case .hasNoTrait:
                self.boldButton.title = "Bold"
            
            case .both:
                self.boldButton.title = "Bold*"
        }
     
        //Configure the Italic UI
        switch (fontStyling.italicsTrait()) {
            case .hasTrait:
                self.italicsButton.title = "Unitalic"
            
            case .hasNoTrait:
                self.italicsButton.title = "Italic"
            
            case .both:
                self.italicsButton.title = "Italic*"
        }
        
        //Configure the Underline UI
        switch (fontStyling.underlineTrait()) {
            case .hasTrait:
                self.underlineButton.title = "Un-underline"
            
            case .hasNoTrait:
                self.underlineButton.title = "Underline"
            
            case .both:
                self.underlineButton.title = "Underline*"
        }
        
        //Configure the Strikethrough UI
        switch (fontStyling.strikethroughTrait()) {
            case .hasTrait:
                self.strikeButton.title = "Un-strikethrough"
                
            case .hasNoTrait:
                self.strikeButton.title = "Strikethrough"
            
            case .both:
                self.strikeButton.title = "Strikethrough*"
        }
        
        //Configure the TextColour UI
        /*
        let textColours = fontInfo.textColours
        switch (textColours.count) {
            case 0:
                self.textColourButton.color = NSColor.black
            
            case 1:
                self.textColourButton.color = textColours[0]
            
            case 2:
                self.textColourButton.color = NSColor.gray
            
            default:()
        }
        */
        
        //Configure the HighlightColour UI
        /*
        let highlightColours = fontInfo.highlightColours
        switch (highlightColours.count) {
            case 0:
                self.highlightColourButton.color = NSColor.white
                
            case 1:
                self.highlightColourButton.color = highlightColours[0]
            
            case 2:
                self.highlightColourButton.color = NSColor.gray
            
            default:()
        }
         */
        
        //Configure the Fonts UI
        let fonts = fontStyling.fonts
        switch (fonts.count) {
            case 0:
                fatalError("Fonts count is somehow 0: \(fonts)")
            
            case 1:
                self.fontFamiliesPopUpButton.title = fonts[0].displayName ?? fonts[0].fontName
                self.fontSizePopUpButton.title     = "\(fonts[0].pointSize.cleanValue)"

            case 2:
                self.fontFamiliesPopUpButton.title = fonts[0].displayName ?? fonts[0].fontName
                self.fontSizePopUpButton.title     = "\(fonts[0].pointSize.cleanValue)"
                
            default:()
        }
        
    }
    
    fileprivate func openPreviewTextWindow()
    {
        let storyboardID = NSStoryboard.SceneIdentifier("PreviewWindowController")
        let previewWindowController = self.storyboard!.instantiateController(withIdentifier: storyboardID) as! NSWindowController
        previewWindowController.window?.title = "2. Raw HTML"
        previewWindowController.showWindow(self)
        
        self.previewTextViewController = previewWindowController.contentViewController as? PreviewTextViewController
    }

    fileprivate func openPreviewWebWindow()
    {
        let storyboardID = NSStoryboard.SceneIdentifier("PreviewWebWindowController")
        let previewWindowController = self.storyboard!.instantiateController(withIdentifier: storyboardID) as! NSWindowController
        previewWindowController.window?.title = "3. Parsed HTML"
        previewWindowController.showWindow(self)
        
        self.previewWebViewController = previewWindowController.contentViewController as? PreviewWebViewController
    }
    
    fileprivate func openPreviewTextWindow2()
    {
        let storyboardID = NSStoryboard.SceneIdentifier("PreviewWindowController")
        let previewWindowController = self.storyboard!.instantiateController(withIdentifier: storyboardID) as! NSWindowController
        previewWindowController.window?.title = "4. Text From HTML"
        previewWindowController.showWindow(self)
        
        self.previewTextViewController2 = previewWindowController.contentViewController as? PreviewTextViewController
    }
    
    /**
     Grabs the selected font title and the selected font size, creates an instance of NSFont from them
     and applies it to the RichTextView
    */
    fileprivate func applyFont()
    {
        guard let selectedFontNameMenuItem = self.fontFamiliesPopUpButton.selectedItem else {
            return
        }
        
        guard let selectedFontSizeMenuItem = self.fontSizePopUpButton.selectedItem else {
            return
        }
        
        let selectedFontTitle = selectedFontNameMenuItem.title
        let selectedFontSize  = CGFloat((selectedFontSizeMenuItem.title as NSString).doubleValue)
        
        guard let font = NSFont(name: selectedFontTitle, size: selectedFontSize) else {
            return
        }
        
        self.richEditor.apply(font: font)
    }
}

/*
        switch (sender) {
            case self.textColourButton:
                self.richTextView.apply(textColour: color)
            
            case self.highlightColourButton:
                self.richTextView.apply(highlightColour: color)
            
            default:()
        }
*/