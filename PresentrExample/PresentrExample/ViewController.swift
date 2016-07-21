//
//  ViewController.swift
//  PresentrExample
//
//  Created by Daniel Lozano on 5/23/16.
//  Copyright © 2016 danielozano. All rights reserved.
//

import UIKit
import Presentr

class ViewController: UIViewController {

    let presenter: Presentr = {
        let presenter = Presentr(presentationType: .Alert)
        presenter.transitionType = TransitionType.CoverHorizontalFromRight
        return presenter
    }()
    
    let customPresenter: Presentr = {
        let width = ModalSize.Full
        let height = ModalSize.Custom(size: 150)
        let center = ModalCenterPosition.CustomOrigin(origin: CGPoint(x: 0, y: 0))
        let customType = PresentationType.Custom(width: width, height: height, center: center)
        
        let customPresenter = Presentr(presentationType: customType)
        customPresenter.transitionType = .CoverVerticalFromTop
        customPresenter.dismissTransitionType = .CoverVertical
        customPresenter.roundCorners = false
        return customPresenter
    }()
    
    lazy var alertController: AlertViewController = {
        let alertController = Presentr.alertViewController(title: "Are you sure? ⚠️", body: "This action can't be undone!")
        let cancelAction = AlertAction(title: "NO, SORRY! 😱", style: .Cancel) { alert in
            print("CANCEL!!")
        }
        let okAction = AlertAction(title: "DO IT! 🤘", style: .Destructive) { alert in
            print("OK!!")
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        return alertController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - IBAction's
    
    @IBAction func alertDefault(sender: UIButton) {
        presenter.presentationType = .Alert
        presenter.transitionType = nil
        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }
    
    @IBAction func alertCustom(sender: UIButton) {
        presenter.presentationType = .Alert
        presenter.transitionType = .CoverHorizontalFromLeft
        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }
    
    @IBAction func alertDefaultWithoutAnimation(sender: UIButton) {
        let animated = false
        let nonAnimatedAlertController = self.alertController
        nonAnimatedAlertController.dismissAnimated = animated
        presenter.presentationType = .Alert
        presenter.transitionType = nil
        customPresentViewController(presenter, viewController: alertController, animated: animated, completion: self.completition)
    }
    
    private func completition() {
        print("the alert controller has been presented")
    }

    @IBAction func popupDefault(sender: UIButton) {
        presenter.presentationType = .Popup
        presenter.transitionType = nil
        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }
    
    @IBAction func popupCustom(sender: UIButton) {
        presenter.presentationType = .Popup
        presenter.transitionType = .CoverHorizontalFromRight
        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }
    
    @IBAction func topHalfDefault(sender: UIButton) {
        presenter.presentationType = .TopHalf
        presenter.transitionType = nil
        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }
    
    @IBAction func topHalfCustom(sender: UIButton) {
        presenter.presentationType = .TopHalf
        presenter.transitionType = .CoverHorizontalFromLeft
        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }
    
    @IBAction func bottomHalfDefault(sender: UIButton) {
        presenter.presentationType = .BottomHalf
        presenter.transitionType = nil
        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }
    
    @IBAction func bottomHalfCustom(sender: UIButton) {
        presenter.presentationType = .BottomHalf
        presenter.transitionType = .CoverHorizontalFromLeft
        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }
    
    @IBAction func customPresentation(sender: UIButton) {
        customPresentViewController(customPresenter, viewController: alertController, animated: true, completion: nil)
    }
    
}

