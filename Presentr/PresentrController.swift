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

    // MARK: - Properties
    // MARK: Input

    let presentationType: PresentationType

    let appearance: AppearanceProxy

    let behavior: BehaviorProxy

    let contextFrameForPresentation: CGRect?

    // MARK: Other

    fileprivate var conformingPresentedController: PresentrDelegate? {
		if let navigationController = presentedViewController as? UINavigationController,
			let visibleViewController = navigationController.visibleViewController as? PresentrDelegate {
			return visibleViewController
		}
        return presentedViewController as? PresentrDelegate
    }

    fileprivate var shouldObserveKeyboard: Bool {
        let hasConformingPresentedController = conformingPresentedController != nil
        let hasKeyboardTranslationType = behavior.keyboardTranslation.translationType != .none
        return hasConformingPresentedController || hasKeyboardTranslationType
    }

    fileprivate var containerFrame: CGRect {
        return contextFrameForPresentation ?? containerView?.bounds ?? CGRect()
    }

    fileprivate var keyboardIsShowing: Bool = false

    // MARK: Custom View's

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

    fileprivate lazy var swipeIndicatorView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 5))
        view.backgroundColor = .white
        view.alpha = 0
        view.rounded(radius: 2.5)
        view.isUserInteractionEnabled = false
        return view
    }()

    // MARK: Swipe gesture

    fileprivate var presentedViewIsBeingDissmissed = false

    fileprivate var initialPresentedViewFrame: CGRect = .zero
    fileprivate var initialPresentedViewCenter: CGPoint = .zero
    fileprivate var initialSwipeIndicatorViewFrame: CGRect = .zero
    fileprivate var initialSwipeIndicatorViewCenter: CGPoint = .zero

    fileprivate var latestShouldDismiss: Bool = true

    fileprivate lazy var shouldSwipeBottom: Bool = {
		let defaultDirection = behavior.dismissOnSwipeDirection == .default
        return defaultDirection ? presentationType != .topHalf : behavior.dismissOnSwipeDirection == .bottom
    }()

    fileprivate lazy var shouldSwipeTop: Bool = {
		let defaultDirection = behavior.dismissOnSwipeDirection == .default
        return defaultDirection ? presentationType == .topHalf : behavior.dismissOnSwipeDirection == .top
    }()

    // MARK: Cache

    fileprivate var _sizeCache: CGSize?

    fileprivate var _widthCache: CGFloat?

    fileprivate var _heightCache: CGFloat?

    fileprivate var _originCache: CGPoint?

    // MARK: - Init

    init(presentedViewController: UIViewController,
         presentingViewController: UIViewController?,
         presentationType: PresentationType,
         appearance: AppearanceProxy,
         behavior: BehaviorProxy,
         contextFrameForPresentation: CGRect?) {
        self.presentationType = presentationType
        self.appearance = appearance
        self.behavior = behavior
        self.contextFrameForPresentation = contextFrameForPresentation
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)

        setupDropShadow()
        setupBackground()

        if behavior.dismissOnSwipe {
            setupDismissOnSwipe()
        }

        if shouldObserveKeyboard {
            registerKeyboardObserver()
        }
    }

}

// MARK: - Setup

extension PresentrController {

    // MARK: UI Setup

    private func setupDismissOnSwipe() {
        let presentedSwipe = UIPanGestureRecognizer(target: self, action: #selector(presentedViewSwipe))
        presentedViewController.view.addGestureRecognizer(presentedSwipe)

        let chromeSwipe = UIPanGestureRecognizer(target: self, action: #selector(presentedViewSwipe))
        chromeView.addGestureRecognizer(chromeSwipe)
    }

    private func setupBackground() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(chromeViewTapped))
        chromeView.addGestureRecognizer(tap)

        if behavior.outsideContextTap != .passthrough {
            let tap = UITapGestureRecognizer(target: self, action: #selector(chromeViewTapped))
            backgroundView.addGestureRecognizer(tap)
        }

        if appearance.blurBackground {
            visualEffect = UIBlurEffect(style: appearance.blurStyle)
        } else {
            chromeView.backgroundColor = appearance.backgroundColor.withAlphaComponent(CGFloat(appearance.backgroundOpacity))
        }
    }

    private func setupRoundedCorners() {
        let roundedCorners = appearance.roundedCorners ?? presentationType.defaultRoundedCorners
        let clipToBounds: Bool

        if let userClipToBounds = roundedCorners.clipToBounds {
            clipToBounds = userClipToBounds
        } else if appearance.dropShadow != nil {
            clipToBounds = false
        } else {
            clipToBounds = true
        }

        presentedViewController.view.clipsToBounds = clipToBounds
        presentedViewController.view.layer.masksToBounds = clipToBounds
        presentedViewController.view.rounded(corners: roundedCorners.corners, radius: roundedCorners.radius)
    }

    private func setupDropShadow() {
        guard let dropShadow = appearance.dropShadow else {
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

    // MARK: Keyboard observation

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

        let presentedFrame = frameOfPresentedViewInContainerView
        swipeIndicatorView.frame.origin = CGPoint(x: presentedFrame.minX + presentedFrame.width / 2 - swipeIndicatorView.frame.width / 2,
                                                  y: presentedFrame.minY - 10)
    }
    
    // MARK: Animation
    
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else {
            return
        }

		if behavior.outsideContextTap == .passthrough {
			backgroundView.shouldPassthrough = true
			backgroundView.passthroughViews = presentingViewController.view.subviews
		}

		if behavior.backgroundTap == .passthrough {
			chromeView.shouldPassthrough = true
			chromeView.passthroughViews = presentingViewController.view.subviews
		}

		backgroundView.frame = containerView.bounds
        chromeView.frame = containerFrame

        containerView.insertSubview(backgroundView, at: 0)
        containerView.insertSubview(chromeView, at: 1)

        chromeView.addSubview(swipeIndicatorView)

        if let customBackgroundView = appearance.customBackgroundView {
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
            swipeIndicatorView.alpha = 0.7
            return
        }

        coordinator.animate(alongsideTransition: { context in
            blurEffectView?.effect = self.visualEffect
            self.chromeView.alpha = 1.0
            self.swipeIndicatorView.alpha = 0.7
        }, completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            chromeView.alpha = 0
            swipeIndicatorView.alpha = 0
            return
        }

        coordinator.animate(alongsideTransition: { context in
            self.chromeView.alpha = 0
            self.swipeIndicatorView.alpha = 0
        }, completion: nil)
    }

}

// MARK: - Sizing, Position Calculation

fileprivate extension PresentrController {

    func getPresentedFrameSizeWith(parentContainerSize: CGSize) -> CGSize {
        if let size = _sizeCache {
            return size
        }

        if let size = presentationType.size {
            return size.calculateSize(parentSize: parentContainerSize)
        } else {
            if case .dynamicSize = presentationType {
                return presentedViewController.view.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
            } else {
                return .zero
            }
        }
//        let width = getWidthFromPresentationTypeWith(parentContainerSize: parentContainerSize)
//        let height = getHeightFromPresentationTypeWith(parentContainerSize: parentContainerSize)
//        return CGSize(width: width, height: height)
    }

    func getWidthFromPresentationTypeWith(parentContainerSize: CGSize) -> CGFloat {
        if let width = _widthCache {
            return width
        }

        let width: CGFloat

        if let size = presentationType.size {
            width = CGFloat(size.calculateWidth(parentSize: parentContainerSize))
        } else {
            if case .dynamicSize = presentationType {
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

        if let size = presentationType.size {
            height = CGFloat(size.calculateHeight(parentSize: parentContainerSize))
        } else {
            if case .dynamicSize = presentationType {
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

        switch presentationType.position {
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
		guard behavior.backgroundTap == .dismiss else {
			return
		}

        guard conformingPresentedController?.presentrShouldDismiss?(keyboardShowing: keyboardIsShowing) ?? true else {
            return
        }

        if gesture.state == .ended {
            if shouldObserveKeyboard {
                removeObservers()
            }
            presentingViewController.dismiss(animated: behavior.dismissAnimated, completion: nil)
        }
    }

    @objc func presentedViewSwipe(gesture: UIPanGestureRecognizer) {
        guard behavior.dismissOnSwipe else {
            return
        }

        if gesture.state == .began {
            initialPresentedViewFrame = presentedViewController.view.frame
            initialPresentedViewCenter = presentedViewController.view.center
            initialSwipeIndicatorViewFrame = swipeIndicatorView.frame
            initialSwipeIndicatorViewCenter = swipeIndicatorView.center

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

        swipeIndicatorView.center = CGPoint(x: initialSwipeIndicatorViewCenter.x, y: initialSwipeIndicatorViewCenter.y + amount.y)
        presentedViewController.view.center = CGPoint(x: initialPresentedViewCenter.x, y: initialPresentedViewCenter.y + amount.y)

        let dismiss = shouldSwipeTop ? (amount.y < swipeLimit) : ( amount.y > swipeLimit)
        if dismiss && latestShouldDismiss {
            presentedViewIsBeingDissmissed = true
            presentedViewController.dismiss(animated: behavior.dismissAnimated, completion: nil)
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
            self.presentedViewController.view.frame = self.initialPresentedViewFrame
            self.swipeIndicatorView.frame = self.initialSwipeIndicatorViewFrame
        }, completion: nil)
    }

}

// MARK: - Keyboard Handling

extension PresentrController {

    @objc func keyboardWasShown(notification: Notification) {
        if let keyboardFrame = notification.keyboardEndFrame() {
            let presentedFrame = frameOfPresentedViewInContainerView
            let translatedFrame = behavior.keyboardTranslation.getTranslationFrame(keyboardFrame: keyboardFrame, presentedFrame: presentedFrame)
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
