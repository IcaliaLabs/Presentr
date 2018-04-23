//
//  Presentr+Equatable.swift
//  Presentr
//
//  Created by Daniel Lozano on 7/6/16.
//  Copyright © 2016 danielozano. All rights reserved.
//

import Foundation

extension PresentationType: Equatable { }
public func == (lhs: PresentationType, rhs: PresentationType) -> Bool {
    switch (lhs, rhs) {
    case (let .custom(layoutA), let .custom(layoutB)):
        return false //layout == layout //FIXME: Make layout equatable
    case (.alert, .alert):
        return true
    case (.popup, .popup):
        return true
    case (.topHalf, .topHalf):
        return true
    case (.bottomHalf, .bottomHalf):
        return true
   // case (.dynamic, .dynamic):
   //     return true
    default:
        return false
    }
}



