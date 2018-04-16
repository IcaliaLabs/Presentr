//
//  CoverRightBottomAnimation.swift
//  LanopticCabinet
//
//  Created by Admin on 16.02.18.
//  Copyright © 2018 LAN-Optic, LLC. All rights reserved.
//

import Foundation
import UIKit

public enum Corner {

	case topLeft
	case topRight
	case bottomLeft
	case bottomRight

	var top: Bool {
		switch self {
		case .topLeft, .topRight:
			return true
		default:
			return false
		}
	}

	var left: Bool {
		switch self {
		case .topLeft, .bottomLeft:
			return true
		case .topRight, .bottomRight:
			return false
		}
	}

}

public class CoverFromCornerAnimation: PresentrAnimation {

	let corner: Corner

	public init(corner: Corner) {
		self.corner = corner
	}
    
    override public func transform(containerFrame: CGRect, finalFrame: CGRect) -> CGRect {
        var initialFrame = finalFrame

		if corner.top {
			initialFrame.origin.y = 0 - initialFrame.size.height
		} else {
			initialFrame.origin.y = containerFrame.size.height + initialFrame.size.height
		}

		if corner.left {
			initialFrame.origin.x = 0 - initialFrame.size.width
		} else {
			initialFrame.origin.x = containerFrame.size.width + initialFrame.size.width
		}

        return initialFrame
    }
    
}
