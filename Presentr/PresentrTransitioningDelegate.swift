//
//  PresentrTransitioningDelegate.Swift
//  OneUP
//
//  Created by Daniel Lozano on 4/27/16.
//  Copyright © 2016 Icalia Labs. All rights reserved.
//

import UIKit

class PresentrTransitioningDelegate: NSObject {

    var presentationType: PresentrType?

    func presentationController(presented: UIViewController, presenting: UIViewController) -> PresentrPresentationController {
        let presentationController = PresentrPresentationController(presentedViewController: presented, presentingViewController: presenting)
        if let type = presentationType {
            presentationController.presentationType = type
        }
        return presentationController
    }
}

// MARK: UIViewControllerTransitioningDelegate

extension PresentrTransitioningDelegate: UIViewControllerTransitioningDelegate {
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        return presentationController(presented, presenting: presenting)
    }

//    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?
//    {
//        let animationController = PopupAnimatedTransitioning()
//        animationController.isPresenting = true
//        return animationController
//    }
//
//    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
//    {
//        let animationController = PopupAnimatedTransitioning()
//        animationController.isPresenting = false
//        return animationController
//    }
}
