# VNTableView

[![Build Status](https://travis-ci.com/hechen/VNTableView.svg?branch=master)](https://travis-ci.com/hechen/VNTableView)  ![Cocoapods](https://img.shields.io/cocoapods/v/VNTableView.svg)  ![Cocoapods platforms](https://img.shields.io/cocoapods/p/VNTableView.svg)    ![Swift Version](https://img.shields.io/badge/Swift-4.0-F16D39.svg?style=flat)

Subclass of NSTableView, which support multiple sections like UITableView.


![Demo](.assets/demo_01.png)


### API

#### VNTableViewDelegate

``` Swift
    func tableView(_ tableView: VNTableView, heightOfRow row: Int, section: Int) -> CGFloat
    func tableView(_ tableView: VNTableView, viewForRow row: Int, section: Int, tableColumn: NSTableColumn?) -> NSView?
    func tableView(_ tableView: VNTableView, heightOfSection section: Int) -> CGFloat
    func tableView(_ tableView: VNTableView, viewForSection section: Int, tableColumn: NSTableColumn?) -> NSView?
```

#### VNTableViewDataSource

``` Swift
    func numberOfSections(in tableView: VNTableView) -> Int
    func numberOfRows(in tableView: VNTableView, section: Int) -> Int
```
