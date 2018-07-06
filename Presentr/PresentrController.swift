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

	/// What should happen when background is tapped.
	let backgroundTap: BackgroundTapAction

	/// What should happen when the area outside the current context is tapped.
	let outsideContextTap: BackgroundTapAction

    /// Should the presented controller dismiss on presented view controller's view Swipe.
    let dismissOnSwipe: Bool

    /// DismissSwipe direction
    let dismissOnSwipeDirection: DismissSwipeDirection
    
    /// Should the presented controller use animation when dismiss on background tap.
    let dismissAnimated: Bool

    /// How the presented view controller should respond in response to keyboard presentation.
    let keyboardTranslationType: KeyboardTranslationType

    /// The corner radius to be set on the presented view controller's view
    let roundedCorners: RoundedCorners

    /// The shadow to be set on the presented view controller's view
    let dropShadow: Shadow?

    /// The frame used for a current context presentation. If nil, normal presentation.
    let contextFrameForPresentation: CGRect?

    /// A custom background view to be added on top of the regular background view.
    let customBackgroundView: UIView?

    fileprivate var conformingPresentedController: PresentrDelegate? {
		if let navigationController = presentedViewController as? UINavigationController,
			let visibleViewController = navigationController.visibleViewController as? PresentrDelegate {
			return visibleViewController
		}
        return presentedViewController as? PresentrDelegate
    }

    fileprivate var shouldObserveKeyboard: Bool {
        let hasConformingPresentedController = conformingPresentedController != nil

        let hasKeyboardTranslationType: Bool
        if case .none = keyboardTranslationType {
            hasKeyboardTranslationType = false
        } else {
            hasKeyboardTranslationType = true
        }

        return hasConformingPresentedController || hasKeyboardTranslationType
    }

    fileprivate var containerFrame: CGRect {
        return contextFrameForPresentation ?? containerView?.bounds ?? CGRect()
    }

    fileprivate var keyboardIsShowing: Bool = false

    // MARK: Background Views

	fileprivate lazy var chromeView: PassthroughView = {
		let view = PassthroughView()
		view.shouldPassthrough = false
		view.passthroughViews = []
		return view
	}()

	fileprivate lazy var backgroundView: PassthroughView = {
		let view = PassthroughView()
		view.shouldPassthrough = false
		view.passthroughViews = []
		return view
	}()

    fileprivate var visualEffect: UIVisualEffect?

    // MARK: Swipe gesture

    fileprivate var presentedViewIsBeingDissmissed: Bool = false

    fileprivate var presentedViewFrame: CGRect = .zero

    fileprivate var presentedViewCenter: CGPoint = .zero

    fileprivate var latestShouldDismiss: Bool = true

    fileprivate lazy var shouldSwipeBottom: Bool = {
		let defaultDirection = dismissOnSwipeDirection == .default
        return defaultDirection ? presentationType != .topHalf : dismissOnSwipeDirection == .bottom
    }()

    fileprivate lazy var shouldSwipeTop: Bool = {
		let defaultDirection = dismissOnSwipeDirection == .default
        return defaultDirection ? presentationType == .topHalf : dismissOnSwipeDirection == .top
    }()

    // MARK: Cache's

    fileprivate var _widthCache: CGFloat?

    fileprivate var _heightCache: CGFloat?

    fileprivate var _originCache: CGPoint?

    // MARK: - Init

    init(presentedViewController: UIViewController,
         presentingViewController: UIViewController?,
         presentationType: PresentationType,
         roundedCorners: RoundedCorners,
         dropShadow: Shadow?,
         backgroundTap: BackgroundTapAction,
         dismissOnSwipe: Bool,
         dismissOnSwipeDirection: DismissSwipeDirection,
         backgroundColor: UIColor,
         backgroundOpacity: Float,
         blurBackground: Bool,
         blurStyle: UIBlurEffectStyle,
         customBackgroundView: UIView?,
         keyboardTranslationType: KeyboardTranslationType,
         dismissAnimated: Bool,
         contextFrameForPresentation: CGRect?,
         outsideContextTap: BackgroundTapAction) {

        self.presentationType = presentationType
        self.roundedCorners = roundedCorners
        self.dropShadow = dropShadow
        self.backgroundTap = backgroundTap
        self.dismissOnSwipe = dismissOnSwipe
        self.dismissOnSwipeDirection = dismissOnSwipeDirection
        self.keyboardTranslationType = keyboardTranslationType
        self.dismissAnimated = dismissAnimated
        self.contextFrameForPresentation = contextFrameForPresentation
        self.outsideContextTap = outsideContextTap
        self.customBackgroundView = customBackgroundView

        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        setupBackground(backgroundColor, backgroundOpacity: backgroundOpacity, blurBackground: blurBackground, blurStyle: blurStyle)
//        setupRoundedCorners()
        setupDropShadow()
        
        if dismissOnSwipe {
            setupDismissOnSwipe()
        }

        if shouldObserveKeyboard {
            registerKeyboardObserver()
        }
    }

    // MARK: - Setup

    private func setupDismissOnSwipe() {
        let swipe = UIPanGestureRecognizer(target: self, action: #selector(presentedViewSwipe))
        presentedViewController.view.addGestureRecognizer(swipe)
    }
    
    private func setupBackground(_ backgroundColor: UIColor, backgroundOpacity: Float, blurBackground: Bool, blurStyle: UIBlurEffectStyle) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(chromeViewTapped))
        chromeView.addGestureRecognizer(tap)

		if outsideContextTap != .passthrough {
			let tap = UITapGestureRecognizer(target: self, action: #selector(chromeViewTapped))
			backgroundView.addGestureRecognizer(tap)
		}

        if blurBackground {
            visualEffect = UIBlurEffect(style: blurStyle)
        } else {
            chromeView.backgroundColor = backgroundColor.withAlphaComponent(CGFloat(backgroundOpacity))
        }
    }

    private func setupRoundedCorners() {
        let clipToBounds: Bool

        if let userClipToBounds = roundedCorners.clipToBounds {
            clipToBounds = userClipToBounds
        } else if dropShadow != nil {
            clipToBounds = false
        } else {
            clipToBounds = true
        }

        presentedViewController.view.clipsToBounds = clipToBounds
        presentedViewController.view.layer.masksToBounds = clipToBounds
        presentedViewController.view.rounded(corners: roundedCorners.corners, radius: roundedCorners.radius)
    }

    private func setupDropShadow() {
        guard let dropShadow = dropShadow else {
            return
        }

        if let shadowColor = dropShadow.shadowColor?.cgColor {
            presentedViewController.view.layer.shadowColor = shadowColor
        }

        if let shadowOpacity = dropShadow.shadowOpacity {
            presentedViewController.view.layer.shadowOpacity = shadowOpacity
        }

        if let shadowOffset = dropShadow.shadowOffset {
            presentedViewController.view.layer.shadowOffset = shadowOffset
        }

        if let shadowRadius = dropShadow.shadowRadius {
            presentedViewController.view.layer.shadowRadius = shadowRadius
        }
    }
    
    fileprivate func registerKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(PresentrController.keyboardWasShown(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PresentrController.keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    fileprivate func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }

}

// MARK: - UIPresentationController

extension PresentrController {
    
    // MARK: Presentation
    
    override var frameOfPresentedViewInContainerView: CGRect {
        let presentedFrameOrigin = getOriginFromPresentationType(parentContainerSize: containerFrame.size)
        let presentedFrameSize = getPresentedFrameSizeWith(parentContainerSize: containerFrame.size)
//        let presentedFrameSize = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerFrame.size)
        return CGRect(origin: presentedFrameOrigin, size: presentedFrameSize)
    }
    
//    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
//        return getPresentedFrameSizeWith(parentContainerSize: parentSize)
//    }

    override func containerViewWillLayoutSubviews() {
        guard !keyboardIsShowing else {
            return // prevent resetting of presented frame when the frame is being translated
        }

        chromeView.frame = containerFrame
//        presentedView!.frame = frameOfPresentedViewInContainerView
    }

    override func containerViewDidLayoutSubviews() {
        setupRoundedCorners()
    }
    
    // MARK: Animation
    
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else {
            return
        }

		if outsideContextTap == .passthrough {
			backgroundView.shouldPassthrough = true
			backgroundView.passthroughViews = presentingViewController.view.subviews
		}

		if backgroundTap == .passthrough {
			chromeView.shouldPassthrough = true
			chromeView.passthroughViews = presentingViewController.view.subviews
		}

		backgroundView.frame = containerView.bounds
        chromeView.frame = containerFrame

        containerView.insertSubview(backgroundView, at: 0)
        containerView.insertSubview(chromeView, at: 1)

        if let customBackgroundView = customBackgroundView {
            chromeView.addSubview(customBackgroundView)
        }

        var blurEffectView: UIVisualEffectView?
        if visualEffect != nil {
            let view = UIVisualEffectView()
            view.frame = chromeView.bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            chromeView.insertSubview(view, at: 0)
            blurEffectView = view
        } else {
            chromeView.alpha = 0.0
        }

        guard let coordinator = presentedViewController.transitionCoordinator else {
            chromeView.alpha = 1.0
            return
        }

        coordinator.animate(alongsideTransition: { context in
            blurEffectView?.effect = self.visualEffect
            self.chromeView.alpha = 1.0
        }, completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            chromeView.alpha = 0.0
            return
        }

        coordinator.animate(alongsideTransition: { context in
            self.chromeView.alpha = 0.0
        }, completion: nil)
    }

}

// MARK: - Sizing, Position Calculation

fileprivate extension PresentrController {

    func getPresentedFrameSizeWith(parentContainerSize: CGSize) -> CGSize {
        let width = getWidthFromPresentationTypeWith(parentContainerSize: parentContainerSize)
        let height = getHeightFromPresentationTypeWith(parentContainerSize: parentContainerSize)
        return CGSize(width: width, height: height)
    }

    func getWidthFromPresentationTypeWith(parentContainerSize: CGSize) -> CGFloat {
        if let width = _widthCache {
            return width
        }

        let width: CGFloat

        if let size = presentationType.size() {
            width = CGFloat(size.width.calculateWidth(parentContainerSize))
        } else {
            if case .dynamic = presentationType {
                width = presentedViewController.view.systemLayoutSizeFitting(UILayoutFittingCompressedSize).width
            } else {
                width = 0
            }
        }

        _widthCache = width
        return width
    }

    func getHeightFromPresentationTypeWith(parentContainerSize: CGSize) -> CGFloat {
        if let height = _heightCache {
            return height
        }

        let height: CGFloat

        if let size = presentationType.size() {
            height = CGFloat(size.height.calculateHeight(parentContainerSize))
        } else {
            if case .dynamic = presentationType {
                height = presentedViewController.view.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
            } else {
                height = 0
            }
        }

        _heightCache = height
        return height
    }

    func getOriginFromPresentationType(parentContainerSize: CGSize) -> CGPoint {
        if let origin = _originCache {
            return origin
        }

        let origin: CGPoint
        let presentedFrameSize = getPresentedFrameSizeWith(parentContainerSize: parentContainerSize)

        switch presentationType.position() {
        case let .origin(originPoint):
            origin = originPoint
        case let .center(centerPosition):
            origin = centerPosition.calculateOriginWith(presentedFrameSize: presentedFrameSize, containerFrame: containerFrame)
        case let .stickTo(edgePosition):
            origin = edgePosition.calculateOriginWith(presentedFrameSize: presentedFrameSize, containerFrame: containerFrame)
        }

        _originCache = origin
        return origin
    }

}

// MARK: - Gesture Handling

extension PresentrController {

    @objc func chromeViewTapped(gesture: UIGestureRecognizer) {
		guard backgroundTap == .dismiss else {
			return
		}

        guard conformingPresentedController?.presentrShouldDismiss?(keyboardShowing: keyboardIsShowing) ?? true else {
            return
        }

        if gesture.state == .ended {
            if shouldObserveKeyboard {
                removeObservers()
            }
            presentingViewController.dismiss(animated: dismissAnimated, completion: nil)
        }
    }

    @objc func presentedViewSwipe(gesture: UIPanGestureRecognizer) {
        guard dismissOnSwipe else {
            return
        }

        if gesture.state == .began {
            presentedViewFrame = presentedViewController.view.frame
            presentedViewCenter = presentedViewController.view.center

            let directionDown = gesture.translation(in: presentedViewController.view).y > 0
            if (shouldSwipeBottom && directionDown) || (shouldSwipeTop && !directionDown) {
                latestShouldDismiss = conformingPresentedController?.presentrShouldDismiss?(keyboardShowing: keyboardIsShowing) ?? true
            }
        } else if gesture.state == .changed {
            swipeGestureChanged(gesture: gesture)
        } else if gesture.state == .ended || gesture.state == .cancelled {
            swipeGestureEnded()
        }
    }

    // MARK: Helper's

    func swipeGestureChanged(gesture: UIPanGestureRecognizer) {
        let amount = gesture.translation(in: presentedViewController.view)

        if shouldSwipeTop && amount.y > 0 {
            return
        } else if shouldSwipeBottom && amount.y < 0 {
            return
        }

        var swipeLimit: CGFloat = 100
        if shouldSwipeTop {
            swipeLimit = -swipeLimit
        }

        presentedViewController.view.center = CGPoint(x: presentedViewCenter.x, y: presentedViewCenter.y + amount.y)

        let dismiss = shouldSwipeTop ? (amount.y < swipeLimit) : ( amount.y > swipeLimit)
        if dismiss && latestShouldDismiss {
            presentedViewIsBeingDissmissed = true
            presentedViewController.dismiss(animated: dismissAnimated, completion: nil)
        }
    }

    func swipeGestureEnded() {
        guard !presentedViewIsBeingDissmissed else {
            return
        }

        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 1,
                       options: [],
                       animations: {
            self.presentedViewController.view.frame = self.presentedViewFrame
        }, completion: nil)
    }

}

// MARK: - Keyboard Handling

extension PresentrController {

    @objc func keyboardWasShown(notification: Notification) {
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

    @objc func keyboardWillHide (notification: Notification) {
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

}
