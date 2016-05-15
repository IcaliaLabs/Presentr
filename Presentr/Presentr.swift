//
//  Presentr.swift
//  Presentr
//
//  Created by Daniel Lozano on 5/10/16.
//  Copyright © 2016 Icalia Labs. All rights reserved.
//

import Foundation
import UIKit

/**
 This the basic type for Presentr. Its job is to describe the 'type' of presentation. Describes the size and position of the presented view controller in a generic, non device-specific way.
 
 - Alert:      This is a small 270 x 180 alert which is the same size as the default iOS alert.
 - Popup:      This is a average/default size 'popup'.
 - TopHalf:    This takes up half of the screen, on the top side.
 - BottomHalf: This takes up half of the screen, on the bottom side.
 */
public enum PresentrType {

    case Alert
    case Popup
    case TopHalf
    case BottomHalf
    
    /**
     This method decides the sizing for each Presentr type. It is meant to be non device/width specific. Except with the .Custom type which should be for cases when the modal size is very small, i.e. smaller than any device.
     
     - returns: A tuple containing two 'ModalSize' enums, describing its width and height.
     */
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
    
    /**
     This method decides the position for each Presentr type. It is meant to be non device/width specific.
     
     - returns: Returns a 'ModalCenterPosition' enum describing the center point for the presented modal.
     */
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

/**
 Descibes a presented modal's size dimension (width or height). It is meant to be non-specific, but the exact position can be calculated by calling the 'calculate' methods, passing in the 'parentSize' which only the Presentation Controller should be aware of.
 
 - Default: Default.
 - Half:    Half of the screen.
 - Full:    Full screen.
 - Custom:  Custom fixed size. To be used only when we want a specific size, and are sure it wont be bigger than any device's screen, like in a small Alert.
 */
public enum ModalSize {
    case Default
    case Half
    case Full
    case Custom(size: Float)

    func calculateWidth(parentSize: CGSize) -> Float{
        switch self {
        case .Default:
            return floorf(Float(parentSize.width) - (PresentrConstants.Values.defaultSideMargin * 2.0))
        case .Half:
            return floorf(Float(parentSize.width) / 2.0)
        case .Full:
            return Float(parentSize.width)
        case .Custom(let size):
            return size
        }
    }
    
    func calculateHeight(parentSize: CGSize) -> Float{
        switch self {
        case .Default:
            return floorf(Float(parentSize.height) * PresentrConstants.Values.defaultHeightPercentage)
        case .Half:
            return floorf(Float(parentSize.height) / 2.0)
        case .Full:
            return Float(parentSize.height)
        case .Custom(let size):
            return size
        }
    }
    
}

/**
 Describes the presented modal's center position. It is meant to be non-specific, but we can use the 'calculatePoint' method when we want to calculate the exact point by passing in the 'containerBounds' rect that only the presentation controller should be aware of.
 
 - Center:       Center of the screen.
 - TopCenter:    Center of the top half of the screen.
 - BottomCenter: Center of the bottom half of the screen.
 */
public enum ModalCenterPosition {
    case Center
    case TopCenter
    case BottomCenter
    
    func calculatePoint(containerBounds: CGRect) -> CGPoint{
        switch self {
        case .Center:
            return CGPointMake(containerBounds.width / 2, containerBounds.height / 2)
        case .TopCenter:
            return CGPointMake(containerBounds.width / 2, containerBounds.height * (1 / 4))
        case .BottomCenter:
            return CGPointMake(containerBounds.width / 2, containerBounds.height * (3 / 4))
        }
    }
}

private struct PresentrConstants {
    struct Values {
        static let defaultSideMargin: Float = 30.0
        static let defaultHeightPercentage: Float = 0.66
    }
    struct Strings {
        static let alertTitle = "Are you sure?"
        static let alertBody = "If you delete this card you will have to add it again."
    }
}

/// Main Presentr class. This is the point of entry for using the framework.
public class Presentr {

    /// Stores the presentation type. This must be set during initialization, but can be changed to reuse a Presentr object.
    public var presentationType: PresentrType
    
    /// Transitioning delegate which handles providing the presentation controller.
    private var transitionDelegate = PresentrTransitioningDelegate()

    // MARK: Init
    
    public init(presentationType: PresentrType){
        self.presentationType = presentationType
    }
    
    // MARK: Class Helper Methods
    
    /**
     Public helper class method for creating and configuring an instance of the 'AlertViewController'
     
     - parameter title: Title to be used in the Alert View Controller.
     - parameter body: Body of the message to be displayed in the Alert View Controller.
     
     - returns: Returns a configured instance of 'AlertViewController'
     */
    public static func alertViewController(title title: String = PresentrConstants.Strings.alertTitle, body: String = PresentrConstants.Strings.alertBody) -> AlertViewController {
        let bundle = NSBundle(forClass: self)
        let alertController = AlertViewController(nibName: "Alert", bundle: bundle)
        alertController.titleText = title
        alertController.bodyText = body
        return alertController
    }
    
    // MARK: Private Methods

    /**
     Private method for presenting a view controller, using the custom presentation. Called from the UIViewController extension.
     
     - parameter presentingVC: The view controller which is doing the presenting.
     - parameter presentedVC:  The view controller to be presented.
     - parameter animated:     Animation boolean.
     - parameter completion:   Completion block.
     */
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
