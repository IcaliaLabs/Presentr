//
//  PresentrTransitioningDelegate.Swift
//  OneUP
//
//  Created by Daniel Lozano on 4/27/16.
//  Copyright © 2016 Icalia Labs. All rights reserved.
//

import UIKit

/// <#Description#>
class PresentrDelegate: NSObject {

    /// <#Description#>
    var presentationType: PresentationType?
    /// <#Description#>
    var transitionType: TransitionType?

    /**
     <#Description#>
     
     - parameter presented:  <#presented description#>
     - parameter presenting: <#presenting description#>
     
     - returns: <#return value description#>
     */
    private func presentationController(presented: UIViewController, presenting: UIViewController) -> PresentrController {
        let presentationController = PresentrController(presentedViewController: presented, presentingViewController: presenting)
        if let type = presentationType {
            presentationController.presentationType = type
        }
        return presentationController
    }
    
    /**
     <#Description#>
     
     - returns: <#return value description#>
     */
    private func animation() -> PresentrAnimation?{
        if let animation = transitionType?.animation() {
            return animation
        }else{
            return nil
        }
    }
}

// MARK: UIViewControllerTransitioningDelegate

extension PresentrDelegate: UIViewControllerTransitioningDelegate {
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        return presentationController(presented, presenting: presenting)
    }

    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        return animation()
    }

    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        return animation()
    }
    
}
