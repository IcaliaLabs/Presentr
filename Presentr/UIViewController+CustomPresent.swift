//
//  UIViewController+CustomPresent.swift
//  Presentr
//
//  Created by Daniel Lozano Valdés on 7/9/18.
//

import Foundation

public protocol CustomPresenting {
    var presenter: Presentr { get }
}

public extension CustomPresenting where Self: UIViewController {

    /// <#Description#>
    ///
    /// - Parameters:
    ///   - viewController: <#viewController description#>
    ///   - animated: <#animated description#>
    ///   - completion: <#completion description#>
    func customPresent(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        presenter.customPresent(presenting: self,
                                presented: viewController,
                                animated: animated,
                                completion: completion)
    }

}

public extension UIViewController {

    /// Present a view controller with a custom presentation provided by the Presentr object.
    ///
    /// - Parameters:
    ///   - viewController: The view controller to be presented.
    ///   - presentr: Presentr object used for custom presentation.
    ///   - animated: Animation setting for the presentation.
    ///   - completion: Completion handler.
    func customPresent(_ viewController: UIViewController, using presentr: Presentr, animated: Bool, completion: (() -> Void)? = nil) {
        presentr.customPresent(presenting: self,
                               presented: viewController,
                               animated: animated,
                               completion: completion)
    }

}
