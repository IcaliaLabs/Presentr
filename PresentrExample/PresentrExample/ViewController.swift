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

    var presenter: Presentr = {
        let presenter = Presentr(presentationType: .alert)
        presenter.transitionType = TransitionType.coverHorizontalFromRight
        return presenter
    }()
    
    var alertController: AlertViewController = {
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

    @IBAction func alertDefault(sender: AnyObject) {
        presenter.presentationType = .alert
        // For default transitions you do not need to set this, this is to reset it just in case it was already changed by another presentation below.
        presenter.transitionType = .coverVertical
        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }
    
    @IBAction func alertCustom(sender: AnyObject) {
        presenter.presentationType = .alert
        presenter.transitionType = .coverHorizontalFromLeft
        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }

    @IBAction func popupDefault(sender: AnyObject) {
        presenter.presentationType = .popup
        presenter.transitionType = .coverVertical
        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }
    
    @IBAction func popupCustom(sender: AnyObject) {
        presenter.presentationType = .popup
        presenter.transitionType = .coverHorizontalFromRight
        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }
    
    @IBAction func topHalfDefault(sender: AnyObject) {
        presenter.presentationType = .topHalf
        presenter.transitionType = .coverVertical
        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }
    
    @IBAction func topHalfCustom(sender: AnyObject) {
        presenter.presentationType = .topHalf
        presenter.transitionType = .coverVerticalFromTop
        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }
    
    @IBAction func bottomHalfDefault(sender: AnyObject) {
        presenter.presentationType = .bottomHalf
        presenter.transitionType = .coverVertical
        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }
    
    @IBAction func bottomHalfCustom(sender: AnyObject) {
        presenter.presentationType = .bottomHalf
        presenter.transitionType = .coverHorizontalFromLeft
        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }
    
}

