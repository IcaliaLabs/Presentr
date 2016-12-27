//
//  CoverHorizontalAnimation.swift
//  Presentr
//
//  Created by Daniel Lozano on 5/15/16.
//  Copyright © 2016 danielozano. All rights reserved.
//

import Foundation

class CoverHorizontalAnimation: PresentrAnimation {

    private var fromRight: Bool

    init(fromRight: Bool = true) {
        self.fromRight = fromRight
    }

    override func transform(containerFrame: CGRect, finalFrame: CGRect) -> CGRect {
        var initialFrame = finalFrame
        if fromRight {
            initialFrame.origin.x = containerFrame.size.width + initialFrame.size.width
        } else {
            initialFrame.origin.x = 0 - initialFrame.size.width
        }
        return initialFrame
    }

}
