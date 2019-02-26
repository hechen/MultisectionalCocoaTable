//
//  VNTableView.swift
//  Venom
//
//  Created by chen he on 2019/2/15.
//  Copyright © 2019 chen he. All rights reserved.
//

#if os(macOS)

import Cocoa

/*
 NSTableView do not support multisection.
 Based on NSTableView, VNTableView support UITableView-like Sections and Cells.
 */
public
class VNTableView: NSTableView {
    public
    weak var vn_delegate: VNTableViewDelegate? {
        didSet {
            self.delegate = self
        }
    }
    public
    weak var vn_datasource: VNTableViewDataSource? {
        didSet {
            self.dataSource = self
        }
    }
    
    
    // MARK: - LifeCycle
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    open override func reloadData() {
        super.reloadData()
    }
    
    private func setup() {
        self.doubleAction = #selector(tableViewDoubleClicked)
    }
}

public extension VNTableView {
    func registerCellNib(_ cellClass: AnyClass, forIdentifier identifier: NSUserInterfaceItemIdentifier) {
        let nibName = String.className(cellClass)
        let nib = NSNib(nibNamed: NSNib.Name(nibName), bundle: nil)
        self.register(nib, forIdentifier: identifier)
    }
    
    /// since NSTableView view-based cell will customize each cell with multiple columns, you can just return view for the first column
    func registerSectionNib(_ sectionClass: AnyClass, forIdentifier identifier: NSUserInterfaceItemIdentifier) {
        let nibName = String.className(sectionClass)
        let nib = NSNib(nibNamed: NSNib.Name(nibName), bundle: nil)
        self.register(nib, forIdentifier: identifier)
    }
}

extension VNTableView: NSTableViewDelegate {
    
    public func tableViewSelectionDidChange(_ notification: Notification) {
        // deselect all rows. (for exam: when you click column header field.)
        if self.selectedRow == -1 {
            vn_delegate?.didDeselectAll(self)
            return
        }
        
        let (section, rowInSection) = sectionFor(row: self.selectedRow)
        
        // section has been disabled.
        assert(rowInSection > 0)
        
        vn_delegate?.tableView(self, didSelectRow: rowInSection - 1, section: section)
    }
    
    public func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let dl = vn_delegate else { return nil }
        
        // which section this row belong to
        let (section, rowInSection) = sectionFor(row: row)
        
        if rowInSection == 0 {
            return dl.tableView(self, viewForSection: section, tableColumn: tableColumn)
        }
        
        // rows contain first line, so before telling delegate, row index must eleminate the first line.
        return dl.tableView(self, viewForRow: rowInSection - 1, section: section, tableColumn: tableColumn)
    }
    
    public func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        guard let dl = vn_delegate else { return 0 }
        // which section this row belong to
        let (section, rowInSection) = sectionFor(row: row)
        
        // first line in this section.
        if rowInSection == 0 {
            return dl.tableView(self, heightOfSection: section)
        }
        
        return dl.tableView(self, heightOfRow: rowInSection, section: section)
    }
    
    public func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        guard let dl = vn_delegate else { return true }
        
        // which section this row belong to
        let (section, rowInSection) = sectionFor(row: row)
        if rowInSection == 0 { return false }
        return dl.tableView(self, shouldSelectRow: rowInSection, section: section)
    }
}

extension VNTableView: NSTableViewDataSource {
    public func numberOfRows(in tableView: NSTableView) -> Int {
        return totalRows()
    }
}


// MARK: - VNTableViewDelegate

public
protocol VNTableViewDelegate: NSObjectProtocol {
    func tableView(_ tableView: VNTableView, heightOfRow row: Int, section: Int) -> CGFloat
    func tableView(_ tableView: VNTableView, viewForRow row: Int, section: Int, tableColumn: NSTableColumn?) -> NSView?
    
    func tableView(_ tableView: VNTableView, heightOfSection section: Int) -> CGFloat
    func tableView(_ tableView: VNTableView, viewForSection section: Int, tableColumn: NSTableColumn?) -> NSView?
    
    func tableView(_ tableView: VNTableView, shouldSelectRow row: Int, section: Int) -> Bool
    func tableView(_ tableView: VNTableView, didSelectRow row: Int, section: Int)
    func didDeselectAll(_ tableView: VNTableView)
    
    func tableView(_ tableView: VNTableView, doubleClickRow row: Int, section: Int)
}

public
extension VNTableViewDelegate {
    func tableView(_ tableView: VNTableView, heightOfRow row: Int, section: Int) -> CGFloat { return 44 }
    func tableView(_ tableView: VNTableView, heightOfSection section: Int) -> CGFloat { return 50 }
    
    func tableView(_ tableView: VNTableView, shouldSelectRow row: Int, section: Int) -> Bool { return true }
    func tableView(_ tableView: VNTableView, didSelectRow row: Int, section: Int) {}
    func didDeselectAll(_ tableView: VNTableView) {}
    
    func tableView(_ tableView: VNTableView, doubleClickRow row: Int, section: Int) {}
}


// MARK: - VNTableViewDataSource

public
protocol VNTableViewDataSource: NSObjectProtocol {
    func numberOfSections(in tableView: VNTableView) -> Int
    func numberOfRows(in tableView: VNTableView, section: Int) -> Int
}


/// MARK: - Private

extension VNTableView {
    private func totalSections() -> Int {
        return flattenSections().count
    }
    
    private func totalRows() -> Int {
        /// sections + rows * section
        return flattenSections().reduce(0) { return $0 + $1 }
    }
    
    private func flattenSections() -> [Int] {
        guard let ds = vn_datasource else { return [] }
        var ret = [Int]()
        let sections = ds.numberOfSections(in: self)
        for section in 0..<sections {
            // each section contain normal rows and section header
            // say, rowCount = (rowsInSection + 1) * sectionCount
            ret.append(ds.numberOfRows(in: self, section: section) + 1)
        }
        return ret
    }
    
    /*
     counts:  rows of each section.
     */
    private func sectionFor(row: Int, counts: [Int]) -> (section: Int?, row: Int?) {
        var lastAccRows = 0
        var currentAccRows = 0
        
        for section in 0..<counts.count {
            currentAccRows += counts[section]
            if lastAccRows..<currentAccRows ~= row {
                // return the row index in current section
                return (section, row - lastAccRows)
            }
            
            // iterate next section
            lastAccRows = currentAccRows
        }
        return (nil, nil)
    }
    
    private func sectionFor(row: Int) -> (section: Int, row: Int) {
        let ret = sectionFor(row: row, counts: flattenSections())
        return (ret.section ?? 0, ret.row ?? 0)
    }
}

extension VNTableView {
    @objc
    func tableViewDoubleClicked() {
        let row = self.clickedRow
        if row == -1 { return }
        
        let (section, rowInSection) = sectionFor(row: row)
        if rowInSection == 0 {
            return
        }
        
        vn_delegate?.tableView(self, doubleClickRow: rowInSection - 1, section: section)
    }
}

#endif
