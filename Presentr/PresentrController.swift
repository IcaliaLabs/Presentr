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

    private var shouldRoundCorners: Bool {
        switch presentationType {
        case .BottomHalf, .TopHalf, .FullScreen:
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
            ((keyboardTranslationType != .None) && presentationType == .Popup)
    }
    
    private var keyboardIsShowing: Bool = false

    private var chromeView = UIView()
    
    private var translationStart: CGPoint = CGPointZero
    
    private var presentedViewIsBeingDissmissed: Bool = false

    // MARK: Init

    init(presentedViewController: UIViewController,
         presentingViewController: UIViewController,
         presentationType: PresentationType,
         roundCorners: Bool,
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
        self.dismissOnTap = dismissOnTap
        self.dismissOnSwipe = dismissOnSwipe
        self.keyboardTranslationType = keyboardTranslationType
        self.dismissAnimated = dismissAnimated

        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)

        setupChromeView(backgroundColor, backgroundOpacity: backgroundOpacity, blurBackground: blurBackground, blurStyle: blurStyle)

        if shouldRoundCorners {
            addCornerRadiusToPresentedView()
        } else {
            removeCornerRadiusFromPresentedView()
        }
        
        if shouldObserveKeyboard {
            registerKeyboardObserver()
        }
    }

    // MARK: Setup

    private func setupChromeView(backgroundColor: UIColor, backgroundOpacity: Float, blurBackground: Bool, blurStyle: UIBlurEffectStyle) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(chromeViewTapped))
        chromeView.addGestureRecognizer(tap)
        
        let swipe = UIPanGestureRecognizer(target: self, action: #selector(presentingViewSwipe))
        presentedViewController.view.addGestureRecognizer(swipe)

        if blurBackground {
            let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
            blurEffectView.frame = chromeView.bounds
            blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            chromeView.addSubview(blurEffectView)
        } else {
            chromeView.backgroundColor = backgroundColor.colorWithAlphaComponent(CGFloat(backgroundOpacity))
        }
    }

    private func addCornerRadiusToPresentedView() {
        presentedViewController.view.layer.cornerRadius = 4
        presentedViewController.view.layer.masksToBounds = true
    }

    private func removeCornerRadiusFromPresentedView() {
        presentedViewController.view.layer.cornerRadius = 0
    }
    
    private func registerKeyboardObserver() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PresentrController.keyboardWasShown(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PresentrController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    private func removeObservers() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)

    }

    // MARK: Actions

    func chromeViewTapped(gesture: UIGestureRecognizer) {
        // get the presented controller conforming to the protocol and if it exists, ask presented if we should dismiss the controller.
        guard (conformingPresentedController?.presentrShouldDismiss?(keyboardIsShowing) ?? true) else {
            return
        }
        if gesture.state == .Ended && dismissOnTap {
            if shouldObserveKeyboard {
                removeObservers()
            }
            presentingViewController.dismissViewControllerAnimated(dismissAnimated, completion: nil)
        }
    }
    
    func presentingViewSwipe(gesture: UIPanGestureRecognizer){
        let gestureState: (UIGestureRecognizerState) -> Bool = {
            return gesture.state == $0 && self.dismissOnSwipe
        }
        guard (conformingPresentedController?.presentrShouldDismiss?(keyboardIsShowing) ?? true) else {
            return
        }
        if gestureState(.Began) {
            translationStart = gesture.locationInView(presentedViewController.view)
        }else if gestureState(.Changed) {
            let amount = gesture.translationInView(presentedViewController.view)
            if amount.y < 0 {return}
            
            let translation = swipeElasticityFactor * 2
            let center = presentedViewController.view.center
            presentedViewController.view.center = CGPointMake(center.x, center.y + translation)
            
            if amount.y > swipeLimitPoint{
                presentedViewIsBeingDissmissed = true
                presentedViewController.dismissViewControllerAnimated(true, completion: nil)
            }
            
        }else if gestureState(.Ended) || gestureState(.Cancelled){
            if presentedViewIsBeingDissmissed {return}
            var point: CGPoint
            switch presentationType.position()
            {
            case .Center:
                point = CGPointMake((UIScreen.mainScreen().bounds.width / 2), (UIScreen.mainScreen().bounds.height / 2))
            case .TopCenter:
                point = CGPointMake((UIScreen.mainScreen().bounds.width / 2), (presentedViewController.view.bounds.height / 2))
            case .BottomCenter:
                point = CGPointMake((UIScreen.mainScreen().bounds.width / 2), (UIScreen.mainScreen().bounds.height) - (presentedViewController.view.bounds.height / 2))
            case .Custom:
                point = CGPointZero
            default:
                point = CGPointZero
            }
            
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: swipeElasticityFactor, initialSpringVelocity: 1, options: [], animations: {
                self.presentedViewController.view.center = point
                }, completion: nil)
        }
    }
    
    // MARK: Keyboard Observation
    
    func keyboardWasShown (notification: NSNotification) {
        // gets the keyboard frame and compares it to the presented view so the view gets moved up with the keyboard.
        if let keyboardFrame = notification.keyboardEndFrame() {
            let presentedFrame = frameOfPresentedViewInContainerView()
            let translatedFrame = keyboardTranslationType.getTranslationFrame(keyboardFrame, presentedFrame: presentedFrame)
            if translatedFrame != presentedFrame {
                UIView.animateWithDuration(notification.keyboardAnimationDuration() ?? 0.5, animations: {
                    self.presentedView()!.frame = translatedFrame
                })
            }
            keyboardIsShowing = true
        }
    }
    
    func keyboardWillHide (notification: NSNotification) {
        if keyboardIsShowing {
            let presentedFrame = frameOfPresentedViewInContainerView()
            if self.presentedView()!.frame !=  presentedFrame {
                UIView.animateWithDuration(notification.keyboardAnimationDuration() ?? 0.5, animations: {
                    self.presentedView()!.frame = presentedFrame
                })
            }
            keyboardIsShowing = false
        }
    }

    // MARK: Sizing Helper's

    private func getWidthFromType(parentSize: CGSize) -> Float {
        let width = presentationType.size().width
        return width.calculateWidth(parentSize)
    }

    private func getHeightFromType(parentSize: CGSize) -> Float {
        let height = presentationType.size().height
        return height.calculateHeight(parentSize)
    }

    private func getCenterPointFromType() -> CGPoint? {
        let containerBounds = containerView!.bounds
        let position = presentationType.position()
        return position.calculatePoint(containerBounds)
    }

    private func getOriginFromType() -> CGPoint? {
        let position = presentationType.position()
        return position.calculateOrigin()
    }

    private func calculateOrigin(center: CGPoint, size: CGSize) -> CGPoint {
        let x: CGFloat = center.x - size.width / 2
        let y: CGFloat = center.y - size.height / 2
        return CGPoint(x: x, y: y)
    }

}

// MARK: - UIPresentationController

extension PresentrController {

    // MARK: Presentation

    override func frameOfPresentedViewInContainerView() -> CGRect {
        var presentedViewFrame = CGRect.zero
        let containerBounds = containerView!.bounds

        let size = sizeForChildContentContainer(presentedViewController, withParentContainerSize: containerBounds.size)

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

    override func sizeForChildContentContainer(container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        let width = getWidthFromType(parentSize)
        let height = getHeightFromType(parentSize)
        return CGSize(width: CGFloat(width), height: CGFloat(height))
    }

    override func containerViewWillLayoutSubviews() {
        guard !keyboardIsShowing else { return } // prevent resetting of presented frame when the frame is being translated
        chromeView.frame = containerView!.bounds
        presentedView()!.frame = frameOfPresentedViewInContainerView()
    }

    // MARK: Animation

    override func presentationTransitionWillBegin() {
        chromeView.frame = containerView!.bounds
        chromeView.alpha = 0.0
        containerView?.insertSubview(chromeView, atIndex: 0)

        if let coordinator = presentedViewController.transitionCoordinator() {

            coordinator.animateAlongsideTransition({ context in
                self.chromeView.alpha = 1.0
                }, completion: nil)

        } else {
            chromeView.alpha = 1.0
        }
    }

    override func dismissalTransitionWillBegin() {
        if let coordinator = presentedViewController.transitionCoordinator() {
            coordinator.animateAlongsideTransition({ context in
                self.chromeView.alpha = 0.0
                }, completion: nil)

        } else {
            chromeView.alpha = 0.0
        }
    }
}
