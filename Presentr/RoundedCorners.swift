//
//  RoundedCorners.swift
//  Presentr
//
//  Created by Daniel Lozano Valdés on 7/5/18.
//

import Foundation

/// Struct thar represents the corner radius properties of the presented ViewController's view
public struct RoundedCorners {

    public let corners: Corners

    public let radius: CGFloat

    public let clipToBounds: Bool?

    public init(corners: Corners, radius: CGFloat = 4.0, clipToBounds: Bool? = nil) {
        self.corners = corners
        self.radius = radius
        self.clipToBounds = clipToBounds
    }

}

/// Enum that represents corners that will have corner radius applied
///
/// - none: No rounded corners
/// - all: All rounded corners
/// - top: Top left and top right corners
/// - bottom: Bottom left and bottom right corners
/// - left: Top left and bottom left corners
/// - right: Top right and bottom right corners
public enum Corners {
    case none
    case all
    case top
    case bottom
    case left
    case right
}

extension RoundedCorners {

    public static let none = RoundedCorners(corners: .none)
    public static let all = RoundedCorners(corners: .all)

}
