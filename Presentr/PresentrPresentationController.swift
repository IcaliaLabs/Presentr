//
//  PresentrPresentationController.swift
//  OneUP
//
//  Created by Daniel Lozano on 4/27/16.
//  Copyright © 2016 Icalia Labs. All rights reserved.
//

import UIKit

class PresentrPresentationController: UIPresentationController, UIAdaptivePresentationControllerDelegate {

    var defaultSideMargin: Float = 30.0
    var defaultHeightPercentage: Float = 0.66

    var presentationType: PresentrType = .Popup {
        didSet {
            if presentationType == .BottomHalf || presentationType == .TopHalf {
                removeCornerRadiusFromPresentedView()
            }
        }
    }

    private var chromeView = UIView()

    // MARK: Init

    override init(presentedViewController: UIViewController, presentingViewController: UIViewController) {
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
        setupChromeView()
        addCornerRadiusToPresentedView()
    }

    // MARK: Setup

    private func setupChromeView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(chromeViewTapped))
        chromeView.addGestureRecognizer(tap)
        chromeView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        chromeView.alpha = 0
    }

    private func addCornerRadiusToPresentedView() {
        guard presentationType != .BottomHalf || presentationType != .TopHalf else {
            return
        }
        presentedViewController.view.layer.cornerRadius = 4
        presentedViewController.view.layer.masksToBounds = true
    }

    private func removeCornerRadiusFromPresentedView() {
        presentedViewController.view.layer.cornerRadius = 0
    }

    // MARK: Actions

    func chromeViewTapped(gesture: UIGestureRecognizer) {
        if gesture.state == .Ended {
            presentingViewController.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    // MARK: Sizing Helper's

    private func calculateWidth(parentSize: CGSize) -> Float {
        switch presentationType.size().width {
        case .Default:
            return floorf(Float(parentSize.width) - (defaultSideMargin * 2.0))
        case .Half:
            return floorf(Float(parentSize.width) / 2.0)
        case .Full:
            return Float(parentSize.width)
        case .Custom(let size):
            return size
        }
    }

    private func calculateHeight(parentSize: CGSize) -> Float {
        switch presentationType.size().height {
        case .Default:
            return floorf(Float(parentSize.height) * defaultHeightPercentage)
        case .Half:
            return floorf(Float(parentSize.height) / 2.0)
        case .Full:
            return Float(parentSize.height)
        case .Custom(let size):
            return size
        }
    }

    private func calculateCenterPoint() -> CGPoint {
        let containerBounds = containerView!.bounds
        switch presentationType.position() {
        case .Center:
            return CGPointMake(containerBounds.width / 2, containerBounds.height / 2)
        case .TopCenter:
            return CGPointMake(containerBounds.width / 2, containerBounds.height * (1 / 4))
        case .BottomCenter:
            return CGPointMake(containerBounds.width / 2, containerBounds.height * (3 / 4))
        }
    }

    private func calculateOrigin(center: CGPoint, size: CGSize) -> CGPoint {
        let x: CGFloat = center.x - size.width / 2
        let y: CGFloat = center.y - size.height / 2
        return CGPointMake(x, y)
    }

}

// MARK: UIPresentationController

extension PresentrPresentationController {

    // MARK: Presentation

    override func frameOfPresentedViewInContainerView() -> CGRect {
        var presentedViewFrame = CGRect.zero
        let containerBounds = containerView!.bounds

        let size = sizeForChildContentContainer(presentedViewController, withParentContainerSize: containerBounds.size)
        let center = calculateCenterPoint()
        let origin = calculateOrigin(center, size: size)

        presentedViewFrame.size = size
        presentedViewFrame.origin = origin

        return presentedViewFrame
    }

    override func sizeForChildContentContainer(container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        let width = calculateWidth(parentSize)
        let height = calculateHeight(parentSize)
        return CGSizeMake(CGFloat(width), CGFloat(height))
    }

    override func containerViewWillLayoutSubviews() {
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
