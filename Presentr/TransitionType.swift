//
//  TransitionType.swift
//  Presentr
//
//  Created by Daniel Lozano on 7/6/16.
//  Copyright © 2016 danielozano. All rights reserved.
//

import Foundation

/**
 Describes the transition animation for presenting the view controller.
 Includes the default system transitions and custom ones.
 - CoverVertical:            System provided transition style. UIModalTransitionStyle.CoverVertical
 - CrossDissolve:            System provided transition style. UIModalTransitionStyle.CrossDissolve
 - FlipHorizontal:           System provided transition style. UIModalTransitionStyle.FlipHorizontal
 - CoverVerticalFromTop:     Custom transition animation. Slides in vertically from top.
 - CoverHorizontalFromLeft:  Custom transition animation. Slides in horizontally from left.
 - CoverHorizontalFromRight: Custom transition animation. Slides in horizontally from  right.
 */
public enum TransitionType {

    // System provided
    case CoverVertical
    case CrossDissolve
    case FlipHorizontal
    // Custom
    case CoverVerticalFromTop
    case CoverHorizontalFromRight
    case CoverHorizontalFromLeft

    /**
     Maps the 'TransitionType' to the system provided transition.
     If this returns nil it should be taken to mean that it's a custom transition, and should call the animation() method.

     - returns: UIKit transition style
     */
    func systemTransition() -> UIModalTransitionStyle? {
        switch self {
        case .CoverVertical:
            return UIModalTransitionStyle.CoverVertical
        case .CrossDissolve:
            return UIModalTransitionStyle.CrossDissolve
        case .FlipHorizontal:
            return UIModalTransitionStyle.FlipHorizontal
        default:
            return nil
        }
    }

    /**
     Associates a custom transition type to the class responsible for its animation.

     - returns: Object conforming to the 'PresentrAnimation' protocol, which in turn conforms to 'UIViewControllerAnimatedTransitioning'. Use this object for the custom animation.
     */
    func animation() -> PresentrAnimation? {
        switch self {
        case .CoverVerticalFromTop:
            return CoverVerticalFromTopAnimation()
        case .CoverHorizontalFromRight:
            return CoverHorizontalAnimation(fromRight: true)
        case .CoverHorizontalFromLeft:
            return CoverHorizontalAnimation(fromRight: false)
        default:
            return nil
        }
    }

}
