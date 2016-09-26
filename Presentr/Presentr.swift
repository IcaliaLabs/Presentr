//
//  Presentr.swift
//  Presentr
//
//  Created by Daniel Lozano on 5/10/16.
//  Copyright © 2016 Icalia Labs. All rights reserved.
//

import Foundation
import UIKit

struct PresentrConstants {
    struct Values {
        static let defaultSideMargin: Float = 30.0
        static let defaultHeightPercentage: Float = 0.66
    }
    struct Strings {
        static let alertTitle = "Alert"
        static let alertBody = "This is an alert."
    }
}

/// Main Presentr class. This is the point of entry for using the framework.
open class Presentr: NSObject {

    // MARK: Public Properties

    /// This must be set during initialization, but can be changed to reuse a Presentr object.
    open var presentationType: PresentationType

    /// The type of transition animation to be used to present the view controller. This is optional, if not provided the default for each presentation type will be used.
    open var transitionType: TransitionType?

    /// The type of transition animation to be used to dismiss the view controller. This is optional, if not provided transitionType or default value will be used.
    open var dismissTransitionType: TransitionType?

    /// Should the presented controller have rounded corners. Default is true, except for .BottomHalf and .TopHalf presentation types.
    open var roundCorners = true

    /// Should the presented controller dismiss on background tap. Default is true.
    open var dismissOnTap = true

    /// Should the presented controller use animation when dismiss on background tap. Default is true.
    open var dismissAnimated = true

    /// Color of the background. Default is Black.
    open var backgroundColor = UIColor.black

    /// Opacity of the background. Default is 0.7.
    open var backgroundOpacity: Float = 0.7

    /// Should the presented controller blur the background. Default is false.
    open var blurBackground = false

    /// The type of blur to be applied to the background. Ignored if blurBackground is set to false. Default is Dark.
    open var blurStyle: UIBlurEffectStyle = .dark

    // MARK: Private Helper Properties

    fileprivate var transitionForPresent: TransitionType {
        return transitionType ?? presentationType.defaultTransitionType()
    }

    fileprivate var transitionForDismiss: TransitionType {
        return dismissTransitionType ?? transitionType ?? presentationType.defaultTransitionType()
    }

    // MARK: Init

    public init(presentationType: PresentationType) {
        self.presentationType = presentationType
    }

    // MARK: Class Helper Methods

    /**
     Public helper class method for creating and configuring an instance of the 'AlertViewController'

     - parameter title: Title to be used in the Alert View Controller.
     - parameter body: Body of the message to be displayed in the Alert View Controller.

     - returns: Returns a configured instance of 'AlertViewController'
     */
    open static func alertViewController(title: String = PresentrConstants.Strings.alertTitle, body: String = PresentrConstants.Strings.alertBody) -> AlertViewController {
        let bundle = Bundle(for: self)
        let alertController = AlertViewController(nibName: "Alert", bundle: bundle)
        alertController.titleText = title
        alertController.bodyText = body
        return alertController
    }

    // MARK: Private Methods

    /**
     Private method for presenting a view controller, using the custom presentation. Called from the UIViewController extension.

     - parameter presentingVC: The view controller which is doing the presenting.
     - parameter presentedVC:  The view controller to be presented.
     - parameter animated:     Animation boolean.
     - parameter completion:   Completion block.
     */
    fileprivate func presentViewController(presentingViewController presentingVC: UIViewController, presentedViewController presentedVC: UIViewController, animated: Bool, completion: (() -> Void)?) {

        if let systemPresentTransition = transitionForPresent.systemTransition() {
            presentedVC.modalTransitionStyle = systemPresentTransition
        }

        presentedVC.transitioningDelegate = self
        presentedVC.modalPresentationStyle = .custom
        presentingVC.present(presentedVC, animated: animated, completion: completion)

        if let systemDismissTransition = transitionForDismiss.systemTransition() {
            presentedVC.modalTransitionStyle = systemDismissTransition
        }

    }

}

// MARK: - UIViewControllerTransitioningDelegate

extension Presentr: UIViewControllerTransitioningDelegate {

    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return presentationController(presented, presenting: presenting!)
    }

    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animation(for: transitionForPresent)
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animation(for: transitionForDismiss)
    }

    // MARK: - Private Helper's

    fileprivate func presentationController(_ presented: UIViewController, presenting: UIViewController) -> PresentrController {
        let presentationController = PresentrController(presentedViewController: presented,
                                                        presentingViewController: presenting,
                                                        presentationType: presentationType,
                                                        roundCorners: roundCorners,
                                                        dismissOnTap: dismissOnTap,
                                                        backgroundColor: backgroundColor,
                                                        backgroundOpacity: backgroundOpacity,
                                                        blurBackground: blurBackground,
                                                        blurStyle: blurStyle,
                                                        dismissAnimated: dismissAnimated)
        return presentationController
    }

    fileprivate func animation(for transition: TransitionType?) -> PresentrAnimation? {
        if let _ = transition?.systemTransition() {
            return nil // If transition is handled by OS then no custom animation. Must return nil.
        }
        return transition?.animation()
    }

}

// MARK: - UIViewController extension to provide customPresentViewController(_:viewController:animated:completion:) method

public extension UIViewController {

    /**
     Public method for presenting a view controller, using the custom presentation. Called from the UIViewController extension.

     - parameter presentr:       Presentr object used for custom presentation.
     - parameter viewController: The view controller to be presented.
     - parameter animated:       Animation boolean.
     - parameter completion:     Completion block.
     */
    func customPresentViewController(_ presentr: Presentr, viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        presentr.presentViewController(presentingViewController: self,
                                       presentedViewController: viewController,
                                       animated: animated,
                                       completion: completion)
    }
}
