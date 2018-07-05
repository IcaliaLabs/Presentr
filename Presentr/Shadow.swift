//
//  PresentrShadow.swift
//  Pods
//
//  Created by Daniel Lozano Valdés on 3/21/17.
//
//

import UIKit

/// Struct that represents the shadow properties for the presented ViewController's view
public struct Shadow {

    public let shadowColor: UIColor?

    public let shadowOpacity: Float?

    public let shadowOffset: CGSize?

    public let shadowRadius: CGFloat?

    public init(shadowColor: UIColor?, shadowOpacity: Float?, shadowOffset: CGSize?, shadowRadius: CGFloat?) {
        self.shadowColor = shadowColor
        self.shadowOpacity = shadowOpacity
        self.shadowOffset = shadowOffset
        self.shadowRadius = shadowRadius
    }

}
