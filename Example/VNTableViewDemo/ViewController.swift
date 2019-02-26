//
//  ViewController.swift
//  VNTableViewDemo
//
//  Created by chen he on 2019/2/26.
//  Copyright © 2019 chen. All rights reserved.
//

import Cocoa
import VNTableView


extension NSUserInterfaceItemIdentifier {
    public static let cellView = NSUserInterfaceItemIdentifier("CellView")
    
    public static let sectionView = NSUserInterfaceItemIdentifier("SectionView")
}


class ViewController: NSViewController {
    @IBOutlet weak var vn_tableview: VNTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        vn_tableview.vn_delegate = self
        vn_tableview.vn_datasource = self
        
        vn_tableview.registerCellNib(CellView.self, forIdentifier: .cellView)
        vn_tableview.registerSectionNib(SectionView.self, forIdentifier: .sectionView)
    }
}

extension ViewController: VNTableViewDelegate {
    func tableView(_ tableView: VNTableView, viewForSection section: Int, tableColumn: NSTableColumn?) -> NSView? {
        guard let sv = tableView.makeView(withIdentifier: .sectionView, owner: nil) as? SectionView else { return nil }
        sv.textLabel.stringValue = "Section \(section)"
        return sv
    }
    
    func tableView(_ tableView: VNTableView, viewForRow row: Int, section: Int, tableColumn: NSTableColumn?) -> NSView? {
        guard let cv = tableView.makeView(withIdentifier: .cellView, owner: nil) as? CellView else { return nil }
        cv.textLabel.stringValue = "I am an row: \(row)"
        return cv
    }
}

extension ViewController: VNTableViewDataSource {
    func numberOfSections(in tableView: VNTableView) -> Int {
        return 10
    }
    
    func numberOfRows(in tableView: VNTableView, section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 2
        case 2: return 3
        case 3: return 4
            
        default: return 2
        }
    }
}

