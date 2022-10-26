//
//  BackgroundView.swift
//  Pods
//
//  Created by Daniel Lozano Valdés on 3/20/17.
//
//

import UIKit

class PassthroughView: UIView {

    var shouldPassthrough = true

	var passthroughViews: [UIView] = []

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        var view = super.hitTest(point, with: event)

        if view == self && shouldPassthrough {
            for passthroughView in passthroughViews {
                view = passthroughView.hitTest(convert(point, to: passthroughView), with: event)
                if view != nil {
                    break
                }
            }
        }

        return view
    }

}
