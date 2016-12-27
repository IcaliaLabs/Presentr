//
//  SpringFromBottomAnimation.swift
//  PresentrExample
//
//  Created by Francesco Perrotti-Garcia on 12/26/16.
//  Copyright © 2016 Presentr. All rights reserved.
//

import UIKit

class SpringFromBottomAnimation: PresentrAnimation {

    override var springDamping: CGFloat {
        return 0.5
    }

    override var initialSpringVelocity: CGFloat {
        return 0
    }

    override func transform(containerFrame: CGRect, finalFrame: CGRect) -> CGRect {
        var initialFrame = finalFrame
        initialFrame.origin.y = containerFrame.size.height + initialFrame.size.height
        return initialFrame
    }

}
