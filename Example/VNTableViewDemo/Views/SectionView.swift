//
//  SectionView.swift
//  VNTableViewDemo
//
//  Created by chen he on 2019/2/26.
//  Copyright © 2019 chen. All rights reserved.
//

import Cocoa

class SectionView: NSView {
    
    @IBOutlet weak var textLabel: NSTextField!
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        backgroundColor = NSColor.darkGray
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        backgroundColor = NSColor.darkGray
    }
}

extension SectionView {
    var backgroundColor: NSColor? {
        set {
            wantsLayer = true
            layer?.backgroundColor = newValue?.cgColor
        }
        
        get {
            guard let layer = layer, let backgroundColor = layer.backgroundColor else { return nil }
            return NSColor(cgColor: backgroundColor)
        }
    }
}


