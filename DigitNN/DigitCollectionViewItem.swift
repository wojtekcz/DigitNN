//
//  DigitCollectionViewItem.swift
//  DigitNN
//
//  Created by Wojciech Czarnowski on 05.04.2016.
//  Copyright © 2016 JATAR. All rights reserved.
//

import Cocoa

class DigitCollectionViewItem: NSCollectionViewItem {

    @IBOutlet weak var digitTextField: NSTextField!
    @IBOutlet weak var digitImageView: NSImageView!
    
    
    var digit = 0
    var image = NSImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func update() {
        digitTextField.stringValue = "\(digit)"
        digitImageView.image = image
        //print("\(digitImageView.frame)")
    }
}
