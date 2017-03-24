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

    override func transform(containerFrame: CGRect, finalFrame: CGRect) -> CGRect {
        return CGRect(x: 0, y: 0, width: 10, height: 10)
    }

}
