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
    
    /// Should the presented controller have rounded corners.
    let roundCorners: Bool
    
    private var shouldRoundCorners: Bool{
        if presentationType == .BottomHalf || presentationType == .TopHalf {
            return false
        }else{
            return roundCorners
        }
    }

    private var chromeView = UIView()

    // MARK: Init
    
    init(presentedViewController: UIViewController, presentingViewController: UIViewController, presentationType: PresentationType, roundCorners: Bool) {
        self.presentationType = presentationType
        self.roundCorners = roundCorners
        
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
        
        setupChromeView()
        if shouldRoundCorners{
            addCornerRadiusToPresentedView()
        }else{
            removeCornerRadiusFromPresentedView()
        }
    }

    // MARK: Setup

    private func setupChromeView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(chromeViewTapped))
        chromeView.addGestureRecognizer(tap)
        chromeView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        chromeView.alpha = 0
    }
    
    private func addCornerRadiusToPresentedView() {
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
        return CGPointMake(x, y)
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
        if let center = getCenterPointFromType(){
            origin = calculateOrigin(center, size: size)
        }else{
            origin = getOriginFromType() ?? CGPointMake(0, 0)
        }

        presentedViewFrame.size = size
        presentedViewFrame.origin = origin

        return presentedViewFrame
    }

    override func sizeForChildContentContainer(container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        let width = getWidthFromType(parentSize)
        let height = getHeightFromType(parentSize)
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
