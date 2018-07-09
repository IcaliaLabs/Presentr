//
//  BackgroundTapAction.swift
//  Presentr
//
//  Created by Daniel Lozano Valdés on 7/9/18.
//

import Foundation

/// The action that should happen when the background is tapped.
///
/// - noAction: Nothing happens.
/// - dismiss: The presented view controller is dismissed.
/// - passthrough: The touch passes through to the presenting view controller.
public enum BackgroundTapAction {
    case noAction
    case dismiss
    case passthrough
}
