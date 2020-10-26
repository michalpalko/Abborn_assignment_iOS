//
//  MonthSectionCzech.swift
//  Abborn assignment
//
//  Created by Michal  on 26/10/2020.
//

import Foundation
import RealmSwift

struct MonthSectionCzech : Comparable{
    var month : Date
    var headlinesForCzech: [Cesko]
    
    static func < (lhs: MonthSectionCzech, rhs: MonthSectionCzech) -> Bool {
        return lhs.month < rhs.month
    }
    
    static func == (lhs: MonthSectionCzech, rhs: MonthSectionCzech) -> Bool {
        return lhs.month == rhs.month
    }
}
