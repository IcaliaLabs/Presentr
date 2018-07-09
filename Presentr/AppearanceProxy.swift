//
//  AppearanceProxy.swift
//  Presentr
//
//  Created by Daniel Lozano Valdés on 7/9/18.
//

import Foundation

/// <#Description#>
public struct AppearanceProxy {

    /// Should the presented controller's view have rounded corners, if nil will use default for chosen presentation type.
    public var roundedCorners: RoundedCorners?

    /// Shadow settings for presented controller.
    public var dropShadow: Shadow?

    /// Color of the background. Default is Black.
    public var backgroundColor: UIColor

    /// Opacity of the background. Default is 0.7.
    public var backgroundOpacity: Float

    /// Should the presented controller blur the background. Default is false.
    public var blurBackground: Bool

    /// The type of blur to be applied to the background. Ignored if blurBackground is set to false. Default is Dark.
    public var blurStyle: UIBlurEffectStyle

    /// A custom background view to be added on top of the regular background view.
    public var customBackgroundView: UIView?

    public init(roundedCorners: RoundedCorners? = nil,
                dropShadow: Shadow? = nil,
                backgroundColor: UIColor = .black,
                backgroundOpacity: Float = 0.7,
                blurBackground: Bool = false,
                blurStyle: UIBlurEffectStyle = .dark,
                customBackgroundView: UIView? = nil) {
        self.roundedCorners = roundedCorners
        self.dropShadow = dropShadow
        self.backgroundColor = backgroundColor
        self.backgroundOpacity = backgroundOpacity
        self.blurBackground = blurBackground
        self.blurStyle = blurStyle
        self.customBackgroundView = customBackgroundView
    }

}
