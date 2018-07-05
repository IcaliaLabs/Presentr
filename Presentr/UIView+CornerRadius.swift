//
//  UIView+CornerRadius.swift
//  Presentr
//
//  Created by Daniel Lozano Valdés on 7/5/18.
//

import Foundation

extension UIView {

    func rounded(corners: Corners, radius: CGFloat) {
        switch corners {
        case .none:
            rounded(radius: 0)
        case .all:
            rounded(radius: radius)
        case .top:
            roundedTop(radius: radius)
        case .bottom:
            roundedBottom(radius: radius)
        case .left:
            roundedLeft(radius: radius)
        case .right:
            roundedRight(radius: radius)
        }
    }

    func roundedTop(radius: CGFloat) {
        rounded(corners: [.topLeft, .topRight], radius: radius)
    }

    func roundedBottom(radius: CGFloat) {
        rounded(corners: [.bottomLeft, .bottomRight], radius: radius)
    }

    func roundedLeft(radius: CGFloat) {
        rounded(corners: [.topLeft, .bottomLeft], radius: radius)
    }

    func roundedRight(radius: CGFloat) {
        rounded(corners: [.topRight, .bottomRight], radius: radius)
    }

    func rounded(corners: UIRectCorner, radius: CGFloat) {
        let cornerRadii = CGSize(width: radius, height: radius)
        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: cornerRadii)
        let mask = CAShapeLayer()
        mask.path = maskPath.cgPath
        layer.mask = mask
    }

    func rounded(radius: CGFloat) {
        layer.cornerRadius = radius
    }

}
