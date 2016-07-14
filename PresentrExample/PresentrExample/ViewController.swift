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
    
    var alertController: AlertViewController = {
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

    @IBAction func alertDefault(sender: AnyObject) {
        presenter.presentationType = .Alert
        // For default transitions you do not need to set this, this is to reset it just in case it was already changed by another presentation below.
        presenter.transitionType = .CoverVertical
        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }
    
    @IBAction func alertCustom(sender: AnyObject) {
        presenter.presentationType = .Alert
        presenter.transitionType = .CoverHorizontalFromLeft
        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }

    @IBAction func popupDefault(sender: AnyObject) {
        presenter.presentationType = .Popup
        presenter.transitionType = .CoverVertical
        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }
    
    @IBAction func popupCustom(sender: AnyObject) {
        presenter.presentationType = .Popup
        presenter.transitionType = .CoverHorizontalFromRight
        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }
    
    @IBAction func topHalfDefault(sender: AnyObject) {
        presenter.presentationType = .TopHalf
        presenter.transitionType = .CoverVertical
        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }
    
    @IBAction func topHalfCustom(sender: AnyObject) {
        presenter.presentationType = .TopHalf
        presenter.transitionType = .CoverVerticalFromTop
        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }
    
    @IBAction func bottomHalfDefault(sender: AnyObject) {
        presenter.presentationType = .BottomHalf
        presenter.transitionType = .CoverVertical
        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }
    
    @IBAction func bottomHalfCustom(sender: AnyObject) {
        presenter.presentationType = .BottomHalf
        presenter.transitionType = .CoverHorizontalFromLeft
        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }
    
    @IBAction func customPresentation(sender: AnyObject) {
        customPresentViewController(customPresenter, viewController: alertController, animated: true, completion: nil)
    }
    
}

