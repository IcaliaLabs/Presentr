//
//  CoverVerticalFromTopAnimation.swift
//  Presentr
//
//  Created by Daniel Lozano on 5/14/16.
//  Copyright © 2016 danielozano. All rights reserved.
//

import Foundation

class CoverVerticalFromTopAnimation: PresentrAnimation {

    override func transform(containerFrame: CGRect, finalFrame: CGRect) -> CGRect {
        var initialFrame = finalFrame
        initialFrame.origin.y = 0 - initialFrame.size.height
        return initialFrame
    }

}
