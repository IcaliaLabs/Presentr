//
//  FirstViewController.swift
//  PresentrExample
//
//  Created by Daniel Lozano Valdés on 3/20/17.
//  Copyright © 2017 danielozano. All rights reserved.
//

import UIKit
import Presentr

class FirstViewController: UIViewController {

    let presenter: Presentr = {
        let presenter = Presentr(presentationType: .alert)
        presenter.transitionType = .coverHorizontalFromLeft
        presenter.dismissTransitionType = .coverHorizontalFromRight
        return presenter
    }()

    var alertController: AlertViewController {
		let alertController = AlertViewController(title: "Are you sure? ⚠️", body: "This action can't be undone!")
        let cancelAction = AlertAction(title: "NO, SORRY! 😱", style: .cancel) {
            print("CANCEL!!")
        }
        let okAction = AlertAction(title: "DO IT! 🤘", style: .destructive) { 
            print("OK!!")
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        return alertController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func didSelectShowAlert(_ sender: Any) {
        presenter.viewControllerForContext = self
        presenter.outsideContextTap = .passthrough
        customPresentViewController(presenter, viewController: alertController, animated: true)
    }

}
