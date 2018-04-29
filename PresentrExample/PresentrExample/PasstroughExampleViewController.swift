//
//  PasstroughExampleViewController.swift
//  PresentrExample
//
//  Created by Daniel Lozano Valdés on 4/28/18.
//  Copyright © 2018 danielozano. All rights reserved.
//

import UIKit
import Presentr

class PasstroughExampleViewController: UIViewController {

	let alertPresenter: Presentr = {
		let presenter = Presentr(presentationType: .alert)
		presenter.transitionType = .flipHorizontal
		presenter.dismissTransitionType = .flipHorizontal
		presenter.backgroundTap = .passthrough
		return presenter
	}()

	lazy var alertController: AlertViewController = {
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
	}()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

	override func viewDidAppear(_ animated: Bool) {
		customPresentViewController(alertPresenter, viewController: alertController, animated: true)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

	@IBAction func userDidClick(_ sender: Any) {
		print("I WAS CLICKED!")
		dismiss(animated: true) {
			print("DISMISSED!")
		}
	}

}
