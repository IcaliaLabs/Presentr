//
//  PresentrPresentationController.swift
//  OneUP
//
//  Created by Daniel Lozano on 4/27/16.
//  Copyright © 2016 Icalia Labs. All rights reserved.
//

import UIKit

/// Presentr's custom presentation controller. Handles the position and sizing for the view controller's.
class PresentrController: UIPresentationController, UIAdaptivePresentationControllerDelegate {
    /// Presentation type must be passed in to make all the sizing and position decisions.
    let presentationType: PresentationType

    /// Should the presented controller's view have rounded corners.
    let roundCorners: Bool
    
    /// Radius of rounded corners if roundCorners is true.
    let cornerRadius: CGFloat

    /// Shadow settings
    let dropShadow: PresentrShadow?

    /// Should the presented controller dismiss on background tap.
    let dismissOnTap: Bool

    /// Should the presented controller dismiss on background Swipe.
    let dismissOnSwipe: Bool

    /// The factor to be used on Swipeging animations
    let swipeElasticityFactor: CGFloat = 0.5

    /// Where in the Swipe should the view dismiss
    let swipeLimitPoint: CGFloat = 200

    /// Should the presented controller use animation when dismiss on background tap.
    let dismissAnimated: Bool

    // How the presented view controller should respond in response to keyboard presentation.
    let keyboardTranslationType: KeyboardTranslationType

    fileprivate var shouldRoundCorners: Bool {
        switch presentationType {
        case .bottomHalf, .topHalf, .fullScreen:
            return false
        default:
            return roundCorners
        }
    }

    /// Determines if the presenting conroller conforms to `PresentrDelegate`
    private var conformingPresentedController: PresentrDelegate? {
        return presentedViewController as? PresentrDelegate
    }

    /// Checks to see if the keyboard should be observed
    private var shouldObserveKeyboard: Bool {
        return conformingPresentedController != nil ||
            ((keyboardTranslationType != .none) && presentationType == .popup)
    }

    fileprivate var chromeView = UIView()
    fileprivate var keyboardIsShowing: Bool = false
    private var translationStart: CGPoint = CGPoint.zero
    
    private var presentedViewIsBeingDissmissed: Bool = false

    // MARK: Init
    init(presentedViewController: UIViewController,
         presentingViewController: UIViewController?,
         presentationType: PresentationType,
         roundCorners: Bool,
         cornerRadius: CGFloat,
         dropShadow: PresentrShadow?,
         dismissOnTap: Bool,
         dismissOnSwipe: Bool,
         backgroundColor: UIColor,
         backgroundOpacity: Float,
         blurBackground: Bool,
         blurStyle: UIBlurEffectStyle,
         keyboardTranslationType: KeyboardTranslationType,
         dismissAnimated: Bool) {

        self.presentationType = presentationType
        self.roundCorners = roundCorners
        self.cornerRadius = cornerRadius
        self.dropShadow = dropShadow
        self.dismissOnTap = dismissOnTap
        self.dismissOnSwipe = dismissOnSwipe
        self.keyboardTranslationType = keyboardTranslationType
        self.dismissAnimated = dismissAnimated

        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)

        setupChromeView(backgroundColor, backgroundOpacity: backgroundOpacity, blurBackground: blurBackground, blurStyle: blurStyle)

        if shouldRoundCorners {
            addCornerRadiusToPresentedView()
        } else {
            removeCornerRadiusFromPresentedView()
        }
        
        if dropShadow != nil {
            addDropShadowToPresentedView()
        } else {
            removeDropShadowFromPresentedView()
        }
        
        if dismissOnSwipe {
            setupDismissOnSwipe()
        }

        if shouldObserveKeyboard {
            registerKeyboardObserver()
        }
    }

    // MARK: Setup
    private func setupDismissOnSwipe() {
        let swipe = UIPanGestureRecognizer(target: self, action: #selector(presentingViewSwipe))
        presentedViewController.view.addGestureRecognizer(swipe)
    }

    private func setupChromeView(_ backgroundColor: UIColor, backgroundOpacity: Float, blurBackground: Bool, blurStyle: UIBlurEffectStyle) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(chromeViewTapped))
        chromeView.addGestureRecognizer(tap)

        if blurBackground {
            let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
            blurEffectView.frame = chromeView.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            chromeView.addSubview(blurEffectView)
        } else {
            chromeView.backgroundColor = backgroundColor.withAlphaComponent(CGFloat(backgroundOpacity))
        }
    }

    private func addCornerRadiusToPresentedView() {
        presentedViewController.view.layer.cornerRadius = cornerRadius
        presentedViewController.view.layer.masksToBounds = true
    }

    private func removeCornerRadiusFromPresentedView() {
        presentedViewController.view.layer.cornerRadius = 0
    }
    
    private func addDropShadowToPresentedView() {
        guard let shadow = self.dropShadow else { return }
        presentedViewController.view.layer.masksToBounds = false
        if let shadowColor = shadow.shadowColor?.cgColor {
            presentedViewController.view.layer.shadowColor = shadowColor
        }
        if let shadowOpacity = shadow.shadowOpacity {
            presentedViewController.view.layer.shadowOpacity = shadowOpacity
        }
        if let shadowOffset = shadow.shadowOffset {
            presentedViewController.view.layer.shadowOffset = shadowOffset
        }
        if let shadowRadius = shadow.shadowRadius {
            presentedViewController.view.layer.shadowRadius = shadowRadius
        }
    }
    
    private func removeDropShadowFromPresentedView() {
        presentedViewController.view.layer.masksToBounds = true
        presentedViewController.view.layer.shadowOpacity = 0
    }
    
    private func registerKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(PresentrController.keyboardWasShown(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PresentrController.keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
    }

    private func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }

    // MARK: Actions
    func chromeViewTapped(gesture: UIGestureRecognizer) {
        // get the presented controller conforming to the protocol and if it exists, ask presented if we should dismiss the controller.
        guard conformingPresentedController?.presentrShouldDismiss?(keyboardShowing: keyboardIsShowing) ?? true else {
            return
        }
        if gesture.state == .ended && dismissOnTap {
            if shouldObserveKeyboard {
                removeObservers()
            }
            presentingViewController.dismiss(animated: dismissAnimated, completion: nil)
        }
    }

    func presentingViewSwipe(gesture: UIPanGestureRecognizer) {
        let gestureState: (UIGestureRecognizerState) -> Bool = {
            return gesture.state == $0 && self.dismissOnSwipe
        }

        guard conformingPresentedController?.presentrShouldDismiss?(keyboardShowing: keyboardIsShowing) ?? true else {
            return
        }

        if gestureState(.began) {
            translationStart = gesture.location(in: presentedViewController.view)
        } else if gestureState(.changed) {
            let amount = gesture.translation(in: presentedViewController.view)
            if amount.y < 0 { return }

            let translation = swipeElasticityFactor * 2
            let center = presentedViewController.view.center
            presentedViewController.view.center = CGPoint(x: center.x, y: center.y + translation)

            if amount.y > swipeLimitPoint {
                presentedViewIsBeingDissmissed = true
                presentedViewController.dismiss(animated: true, completion: nil)
            }
        } else if gestureState(.ended) || gestureState(.cancelled) {
            if presentedViewIsBeingDissmissed {return}
            var point: CGPoint
            let screenWidth = UIScreen.main.bounds.width
            let screenHeight = UIScreen.main.bounds.height
            switch presentationType.position() {
            case .center:
                point = CGPoint(x: screenWidth / 2, y: screenHeight / 2)
            case .topCenter:
                point = CGPoint(x: screenWidth / 2, y: presentedViewController.view.bounds.height / 2)
            case .bottomCenter:
                point = CGPoint(x: screenWidth / 2, y: screenHeight - presentedViewController.view.bounds.height / 2)
            default:
                point = CGPoint.zero
            }

            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: swipeElasticityFactor, initialSpringVelocity: 1, options: [], animations: {
                self.presentedViewController.view.center = point
                }, completion: nil)
        }
    }

    // MARK: Keyboard Observation
    func keyboardWasShown(notification: Notification) {
        // gets the keyboard frame and compares it to the presented view so the view gets moved up with the keyboard.
        if let keyboardFrame = notification.keyboardEndFrame() {
            let presentedFrame = frameOfPresentedViewInContainerView
            let translatedFrame = keyboardTranslationType.getTranslationFrame(keyboardFrame: keyboardFrame, presentedFrame: presentedFrame)
            if translatedFrame != presentedFrame {
                UIView.animate(withDuration: notification.keyboardAnimationDuration() ?? 0.5, animations: {
                    self.presentedView?.frame = translatedFrame
                })
            }
            keyboardIsShowing = true
        }
    }

    func keyboardWillHide (notification: Notification) {
        if keyboardIsShowing {
            let presentedFrame = frameOfPresentedViewInContainerView
            if self.presentedView?.frame !=  presentedFrame {
                UIView.animate(withDuration: notification.keyboardAnimationDuration() ?? 0.5, animations: {
                    self.presentedView?.frame = presentedFrame
                })
            }
            keyboardIsShowing = false
        }
    }

    // MARK: Sizing Helper's

    fileprivate func getWidthFromType(_ parentSize: CGSize) -> Float {
        let width = presentationType.size().width
        return width.calculateWidth(parentSize)
    }

    fileprivate func getHeightFromType(_ parentSize: CGSize) -> Float {
        let height = presentationType.size().height
        return height.calculateHeight(parentSize)
    }

    fileprivate func getCenterPointFromType() -> CGPoint? {
        let containerBounds = containerView!.bounds
        let position = presentationType.position()
        return position.calculatePoint(containerBounds)
    }

    fileprivate func getOriginFromType() -> CGPoint? {
        let position = presentationType.position()
        return position.calculateOrigin()
    }

    fileprivate func calculateOrigin(_ center: CGPoint, size: CGSize) -> CGPoint {
        let x: CGFloat = center.x - size.width / 2
        let y: CGFloat = center.y - size.height / 2
        return CGPoint(x: x, y: y)
    }

}

// MARK: - UIPresentationController

extension PresentrController {

    // MARK: Presentation

    override var frameOfPresentedViewInContainerView: CGRect {
        var presentedViewFrame = CGRect.zero
        let containerBounds = containerView!.bounds

        let size = self.size(forChildContentContainer: presentedViewController, withParentContainerSize: containerBounds.size)

        let origin: CGPoint
        // If the Presentation Type's calculate center point returns nil, this means that the user provided the origin, not a center point.
        if let center = getCenterPointFromType() {
            origin = calculateOrigin(center, size: size)
        } else {
            origin = getOriginFromType() ?? CGPoint(x: 0, y: 0)
        }

        presentedViewFrame.size = size
        presentedViewFrame.origin = origin

        return presentedViewFrame
    }

    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        let width = getWidthFromType(parentSize)
        let height = getHeightFromType(parentSize)
        return CGSize(width: CGFloat(width), height: CGFloat(height))
    }

    override func containerViewWillLayoutSubviews() {
        guard !keyboardIsShowing else { return } // prevent resetting of presented frame when the frame is being translated
        chromeView.frame = containerView!.bounds
        presentedView!.frame = frameOfPresentedViewInContainerView
    }
    
    // MARK: Animation

    override func presentationTransitionWillBegin() {
        chromeView.frame = containerView!.bounds
        chromeView.alpha = 0.0
        containerView?.insertSubview(chromeView, at: 0)

        if let coordinator = presentedViewController.transitionCoordinator {

            coordinator.animate(alongsideTransition: { context in
                self.chromeView.alpha = 1.0
                }, completion: nil)

        } else {
            chromeView.alpha = 1.0
        }
    }

    override func dismissalTransitionWillBegin() {
        if let coordinator = presentedViewController.transitionCoordinator {

            coordinator.animate(alongsideTransition: { context in
                self.chromeView.alpha = 0.0
                }, completion: nil)

        } else {
            chromeView.alpha = 0.0
        }
    }
}
