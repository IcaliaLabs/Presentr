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
        let presenter = Presentr(presentationType: .alert)
        presenter.transitionType = TransitionType.coverHorizontalFromRight
        return presenter
    }()

    let customPresenter: Presentr = {
        let width = ModalSize.full
        let height = ModalSize.custom(size: 150)
        let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: 0, y: 0))
        let customType = PresentationType.custom(width: width, height: height, center: center)

        let customPresenter = Presentr(presentationType: customType)
        customPresenter.transitionType = .coverVerticalFromTop
        customPresenter.dismissTransitionType = .coverVerticalFromTop
        customPresenter.roundCorners = false
        customPresenter.backgroundColor = UIColor.green
        customPresenter.backgroundOpacity = 0.5
        return customPresenter
    }()

    lazy var alertController: AlertViewController = {
        let alertController = Presentr.alertViewController(title: "Are you sure? ⚠️", body: "This action can't be undone!")
        let cancelAction = AlertAction(title: "NO, SORRY! 😱", style: .cancel) { alert in
            print("CANCEL!!")
        }
        let okAction = AlertAction(title: "DO IT! 🤘", style: .destructive) { alert in
            print("OK!!")
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        return alertController
    }()
    
    lazy var popupViewController: PopupViewController = {
        let popupViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PopupViewController")
        return popupViewController as! PopupViewController
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - IBAction's

    @IBAction func alertDefault(_ sender: UIButton) {
        presenter.presentationType = .alert
        presenter.transitionType = nil
        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }

    @IBAction func alertCustom(_ sender: UIButton) {
        presenter.presentationType = .alert
        presenter.transitionType = .coverHorizontalFromLeft
        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }

    @IBAction func alertDefaultWithoutAnimation(_ sender: UIButton) {
        let animated = false
        let nonAnimatedAlertController = self.alertController
        nonAnimatedAlertController.dismissAnimated = animated
        presenter.presentationType = .alert
        presenter.transitionType = nil
        customPresentViewController(presenter, viewController: alertController, animated: animated, completion: nil)
    }

    @IBAction func popupDefault(_ sender: UIButton) {
        presenter.presentationType = .popup
        presenter.transitionType = nil
        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }

    @IBAction func popupCustom(_ sender: UIButton) {
        presenter.presentationType = .popup
        presenter.transitionType = .coverHorizontalFromRight
        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }

    @IBAction func topHalfDefault(_ sender: UIButton) {
        presenter.presentationType = .topHalf
        presenter.transitionType = nil
        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }

    @IBAction func topHalfCustom(_ sender: UIButton) {
        presenter.presentationType = .topHalf
        presenter.transitionType = .coverHorizontalFromLeft
        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }

    @IBAction func bottomHalfDefault(_ sender: UIButton) {
        presenter.presentationType = .bottomHalf
        presenter.transitionType = nil
        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }

    @IBAction func bottomHalfCustom(_ sender: UIButton) {
        presenter.presentationType = .bottomHalf
        presenter.transitionType = .coverHorizontalFromLeft
        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }

    @IBAction func customPresentation(_ sender: UIButton) {
        customPresentViewController(customPresenter, viewController: alertController, animated: true, completion: nil)
    }

    @IBAction func fullScreenPresentation(_ sender: UIButton) {
        let animated = true
        let nonAnimatedAlertController = self.alertController
        nonAnimatedAlertController.dismissAnimated = animated
        presenter.presentationType = .fullScreen
        presenter.transitionType = .coverVertical
        customPresentViewController(presenter, viewController: alertController, animated: animated, completion: nil)
    }
    
    @IBAction func keyboardTranslationDelegate(sender: AnyObject) {
        presenter.presentationType = .popup
        presenter.keyboardTranslationType = .Compress
        customPresentViewController(presenter, viewController: popupViewController, animated: true, completion: nil)
    }
    
}
