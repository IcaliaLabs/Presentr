//
//  BehaviorProxy.swift
//  Presentr
//
//  Created by Daniel Lozano Valdés on 7/9/18.
//

import Foundation

/// <#Description#>
public struct BehaviorProxy {

    /// What should happen when background is tapped. Default is dismiss which dismisses the presented ViewController.
    public var backgroundTap: BackgroundTapAction

    /// Should the presented controller dismiss on Swipe inside the presented view controller. Default is false.
    public var dismissOnSwipe: Bool

    /// If dismissOnSwipe is true, the direction for the swipe. Default depends on presentation type.
    public var dismissOnSwipeDirection: DismissSwipeDirection

    /// Should the presented controller use animation when dismiss on background tap or swipe. Default is true.
    public var dismissAnimated: Bool

    /// How the presented view controller should respond to keyboard presentation.
    public var keyboardTranslation: KeyboardTranslation

    /// When a ViewController for context is set this handles what happens to a tap when it is outside the context. Default is passing it through to the background ViewController's. If this is set to anything but the default (.passthrough), the normal background tap cannot passthrough.
    public var outsideContextTap: BackgroundTapAction

    public init(backgroundTap: BackgroundTapAction = .dismiss,
                dismissOnSwipe: Bool = false,
                dismissOnSwipeDirection: DismissSwipeDirection = .default,
                dismissAnimated: Bool = true,
                keyboardTranslation: KeyboardTranslation = .init(.none),
                outsideContextTap: BackgroundTapAction = .passthrough) {
        self.backgroundTap = backgroundTap
        self.dismissOnSwipe = dismissOnSwipe
        self.dismissOnSwipeDirection = dismissOnSwipeDirection
        self.dismissAnimated = dismissAnimated
        self.keyboardTranslation = keyboardTranslation
        self.outsideContextTap = outsideContextTap
    }

}
