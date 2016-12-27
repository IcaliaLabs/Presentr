//
//  CustomAnimation.swift
//  PresentrExample
//
//  Created by Daniel Lozano Valdés on 12/27/16.
//  Copyright © 2016 danielozano. All rights reserved.
//

import Foundation
import Presentr

class CustomAnimation: PresentrAnimation {

    override var springDamping: CGFloat {
        return 500
    }

    override var initialSpringVelocity: CGFloat {
        return 1
    }

    override var animationDuration: TimeInterval {
        return 1
    }

    override func transform(containerFrame: CGRect, finalFrame: CGRect) -> CGRect {
        return CGRect(x: 0, y: 0, width: 10, height: 10)
    }

}
