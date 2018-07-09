//
//  Presentr.swift
//  Presentr
//
//  Created by Daniel Lozano on 5/10/16.
//  Copyright © 2016 Icalia Labs. All rights reserved.
//

import Foundation
import UIKit

/// Main Presentr class. This is the point of entry for using the framework.
public final class Presentr: NSObject {

    /// This must be set during initialization, but can be changed to reuse a Presentr object.
    public var presentationType: PresentationType

    /// The type of transition animation to be used to present the view controller. This is optional, if not provided the default for each presentation type will be used.
    public var transitionType: TransitionType?

    /// The type of transition animation to be used to dismiss the view controller. This is optional, if not provided transitionType or default value will be used.
    public var dismissTransitionType: TransitionType?

    /// <#Description#>
    public var appearance: AppearanceProxy

    /// <#Description#>
    public var behavior: BehaviorProxy

    /// Uses the ViewController's frame as context for the presentation. Imitates UIModalPresentation.currentContext
    public weak var viewControllerForContext: UIViewController? {
        didSet {
            guard let viewController = viewControllerForContext, let view = viewController.view else {
                contextFrameForPresentation = nil
                return
            }
            let correctedOrigin = view.convert(view.frame.origin, to: nil) // Correct origin in relation to UIWindow
            contextFrameForPresentation = CGRect(x: correctedOrigin.x, y: correctedOrigin.y, width: view.bounds.width, height: view.bounds.height)
        }
    }

    fileprivate var contextFrameForPresentation: CGRect?

    // MARK: Init

    public init(presentationType: PresentationType,
                appearance: AppearanceProxy = AppearanceProxy(),
                behavior: BehaviorProxy = BehaviorProxy()) {
        self.presentationType = presentationType
        self.appearance = appearance
        self.behavior = behavior
    }

    /// Method for presenting a view controller, using the custom presentation.
    ///
    /// - Parameters:
    ///   - presentingViewController: The view controller which is doing the presenting.
    ///   - presentedViewController: The view controller to be presented.
    ///   - animated: Animation boolean.
    ///   - completion: Completion block.
    func customPresent(presenting presentingViewController: UIViewController,
                       presented presentedViewController: UIViewController,
                       animated: Bool,
                       completion: (() -> Void)?) {
        presentedViewController.transitioningDelegate = self
        presentedViewController.modalPresentationStyle = .custom
        presentingViewController.present(presentedViewController, animated: animated, completion: completion)
    }

    private var transitionForPresent: TransitionType {
        return transitionType ?? presentationType.defaultTransitionType()
    }

    private var transitionForDismiss: TransitionType {
        return dismissTransitionType ?? transitionType ?? presentationType.defaultTransitionType()
    }

}

// MARK: - UIViewControllerTransitioningDelegate

extension Presentr: UIViewControllerTransitioningDelegate {

    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentrController(presentedViewController: presented,
                                  presentingViewController: presenting,
                                  presentationType: presentationType,
                                  appearance: appearance,
                                  behavior: behavior,
                                  contextFrameForPresentation: contextFrameForPresentation)
    }

    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transitionForPresent.animation()
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transitionForDismiss.animation()
    }

}
