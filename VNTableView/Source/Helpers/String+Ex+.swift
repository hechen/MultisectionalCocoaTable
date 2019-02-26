//
//  String+Ex+.swift
//  VNTableView
//
//  Created by chen he on 2019/2/26.
//

import Foundation

extension String {
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
}
