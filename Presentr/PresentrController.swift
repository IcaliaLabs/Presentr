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

    /// Should the presented controller use animation when dismiss on background tap.
    let dismissAnimated: Bool

    fileprivate var shouldRoundCorners: Bool {
        switch presentationType {
        case .bottomHalf, .topHalf, .fullScreen:
            return false
        default:
            return roundCorners
        }
    }

    fileprivate var chromeView = UIView()

    // MARK: Init

    init(presentedViewController: UIViewController,
         presentingViewController: UIViewController?,
         presentationType: PresentationType,
         roundCorners: Bool,
         dismissOnTap: Bool,
         backgroundColor: UIColor,
         backgroundOpacity: Float,
         blurBackground: Bool,
         blurStyle: UIBlurEffectStyle,
         dismissAnimated: Bool) {

        self.presentationType = presentationType
        self.roundCorners = roundCorners
        self.dismissOnTap = dismissOnTap
        self.dismissAnimated = dismissAnimated

        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)

        setupChromeView(backgroundColor, backgroundOpacity: backgroundOpacity, blurBackground: blurBackground, blurStyle: blurStyle)

        if shouldRoundCorners {
            addCornerRadiusToPresentedView()
        } else {
            removeCornerRadiusFromPresentedView()
        }
    }

    // MARK: Setup

    fileprivate func setupChromeView(_ backgroundColor: UIColor, backgroundOpacity: Float, blurBackground: Bool, blurStyle: UIBlurEffectStyle) {
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

    fileprivate func addCornerRadiusToPresentedView() {
        presentedViewController.view.layer.cornerRadius = 4
        presentedViewController.view.layer.masksToBounds = true
    }

    fileprivate func removeCornerRadiusFromPresentedView() {
        presentedViewController.view.layer.cornerRadius = 0
    }

    // MARK: Actions

    func chromeViewTapped(_ gesture: UIGestureRecognizer) {
        if gesture.state == .ended && dismissOnTap {
            presentingViewController.dismiss(animated: dismissAnimated, completion: nil)
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
