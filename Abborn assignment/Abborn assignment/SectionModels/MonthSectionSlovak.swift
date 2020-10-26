//
//  MonthSection.swift
//  Abborn assignment
//
//  Created by Michal  on 25/10/2020.
//

import Foundation
import RealmSwift

struct MonthSectionSlovak : Comparable{
    var month : Date
    var headlinesForSlovak : [Slovensko]
    
    static func < (lhs: MonthSectionSlovak, rhs: MonthSectionSlovak) -> Bool {
        return lhs.month < rhs.month
    }
    
    static func == (lhs: MonthSectionSlovak, rhs: MonthSectionSlovak) -> Bool {
        return lhs.month == rhs.month
    }
}
