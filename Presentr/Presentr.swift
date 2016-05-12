//
//  Presentr.swift
//  OneUP
//
//  Created by Daniel Lozano on 5/10/16.
//  Copyright © 2016 Icalia Labs. All rights reserved.
//

import Foundation
import UIKit

public enum PresentrType {

    case Alert
    case Popup
    case TopHalf
    case BottomHalf

    func size() -> (width: ModalSize, height: ModalSize) {
        switch self {
        case .Alert:
            return (.Custom(size: 270), .Custom(size: 180))
        case .Popup:
            return (.Default, .Default)
        case .TopHalf, .BottomHalf:
            return (.Full, .Half)
        }
    }

    func position() -> ModalCenterPosition {
        switch self {
        case .Alert:
            return .Center
        case .Popup:
            return .Center
        case .TopHalf:
            return .TopCenter
        case .BottomHalf:
            return .BottomCenter
        }
    }
}

public enum ModalSize {
    case Default
    case Half
    case Full
    case Custom(size: Float)
}

public enum ModalCenterPosition {
    case Center
    case TopCenter
    case BottomCenter
}

struct PresentrConstants {
    struct Alert {
        static let defaultTitle = "Are you sure?"
        static let defaultBody = "If you delete this card you will have to add it again."
    }
}

public class Presentr {

    public var presentationType: PresentrType
    var transitionDelegate = PresentrTransitioningDelegate()

    // MARK: Init
    
    public init(presentationType: PresentrType){
        self.presentationType = presentationType
    }
    
    // MARK: Class Helper Methods
    
    public static func alertViewController(title title: String = PresentrConstants.Alert.defaultTitle, body: String = PresentrConstants.Alert.defaultBody) -> AlertViewController {
        let bundle = NSBundle(identifier: "danielozano.Presentr")
        let alertController = AlertViewController(nibName: "Alert", bundle: bundle)
        alertController.titleText = title
        alertController.bodyText = body
        return alertController
    }
    
    // MARK: Private Methods

    private func presentViewController(presentingViewController presentingVC: UIViewController, presentedViewController presentedVC: UIViewController, animated: Bool, completion: (() -> Void)?) {
        presentedVC.modalPresentationStyle = .Custom
        presentedVC.modalTransitionStyle = .CoverVertical
        
        transitionDelegate.presentationType = presentationType
        presentedVC.transitioningDelegate = transitionDelegate
        
        presentingVC.presentViewController(presentedVC, animated: animated, completion: nil)
    }

}

public extension UIViewController {
    func customPresentViewController(presentr: Presentr, viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        presentr.presentViewController(presentingViewController: self,
                                       presentedViewController: viewController,
                                       animated: animated,
                                       completion: completion)
    }
}
