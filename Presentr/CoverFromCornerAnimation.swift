//
//  CoverRightBottomAnimation.swift
//  LanopticCabinet
//
//  Created by Admin on 16.02.18.
//  Copyright © 2018 LAN-Optic, LLC. All rights reserved.
//

import Foundation
import UIKit

public class CoverFromCornerAnimation: PresentrAnimation {
    
    private var fromBottom: Bool
    private var fromRight: Bool
    
    public init(fromBottom: Bool = false, fromRight: Bool = false) {
        self.fromBottom = fromBottom
        self.fromRight = fromRight
    }
    
    override public func transform(containerFrame: CGRect, finalFrame: CGRect) -> CGRect {
        var initialFrame = finalFrame
        if(fromBottom) {
            initialFrame.origin.y = containerFrame.size.height + initialFrame.size.height
        } else {
            initialFrame.origin.y = 0 - initialFrame.size.height
        }
        if(fromRight) {
            initialFrame.origin.x = containerFrame.size.width + initialFrame.size.width
        } else {
            initialFrame.origin.x = 0 - initialFrame.size.width
        }
        return initialFrame
    }
    
}
