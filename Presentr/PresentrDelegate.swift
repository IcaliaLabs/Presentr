//
//  PresentrDelegate.swift
//  Presentr
//
//  Created by Daniel Lozano Valdés on 7/9/18.
//

import Foundation

/// The 'PresentrDelegate' protocol defines methods that you use to respond to changes from the 'PresentrController'. All of the methods of this protocol are optional.
@objc public protocol PresentrDelegate {
    /// Asks the delegate if it should dismiss the presented controller on the tap of the outer chrome view.
    /// Use this method to validate requirments or finish tasks before the dismissal of the presented controller.
    /// After things are wrapped up and verified it may be good to dismiss the presented controller automatically so the user does't have to close it again.
    ///
    /// - Parameter keyboardShowing: Whether or not the keyboard is currently being shown by the presented view.
    /// - Returns: False if the dismissal should be prevented, otherwise, true if the dimissal should occur.
    @objc optional func presentrShouldDismiss(keyboardShowing: Bool) -> Bool
}
