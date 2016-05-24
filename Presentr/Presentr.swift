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
 Basic Presentr type. Its job is to describe the 'type' of presentation. The type describes the size and position of the presented view controller.
 
 - Alert:      This is a small 270 x 180 alert which is the same size as the default iOS alert.
 - Popup:      This is a average/default size 'popup' modal.
 - TopHalf:    This takes up half of the screen, on the top side.
 - BottomHalf: This takes up half of the screen, on the bottom side.
 */
public enum PresentationType {

    case Alert
    case Popup
    case TopHalf
    case BottomHalf
    
    /**
     Describes the sizing for each Presentr type. It is meant to be non device/width specific. Except with the .Custom type which should be for cases when the modal size is very small, i.e. smaller than any device.
     
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
     Describes the position for each Presentr type. It is meant to be non device/width specific.
     
     - returns: Returns a 'ModalCenterPosition' enum describing the center point for the presented modal.
     */
    func position() -> ModalCenterPosition {
        switch self {
        case .Alert, .Popup:
            return .Center
        case .TopHalf:
            return .TopCenter
        case .BottomHalf:
            return .BottomCenter
        }
    }
    
    /**
     Associates each Presentr type with a default transition type, in case one is not provided to the Presentr object.
     
     - returns: Return a 'TransitionType' which describes a system provided or custom transition animation.
     */
    func defaultTransitionType() -> TransitionType{
        switch self {
        case .Alert, .Popup, .BottomHalf:
            return .CoverVertical
        case .TopHalf:
            return .CoverVerticalFromTop
        }
    }
    
}

/**
 Describes the transition animation for presenting the view controller. Includes the default system transitions and custom ones.
 
 - CoverVertical:            System provided transition style. UIModalTransitionStyle.CoverVertical
 - CrossDissolve:            System provided transition style. UIModalTransitionStyle.CrossDissolve
 - FlipHorizontal:           System provided transition style. UIModalTransitionStyle.FlipHorizontal
 - CoverVerticalFromTop:     Custom transition animation. Slides in vertically from top.
 - CoverHorizontalFromLeft:  Custom transition animation. Slides in horizontally from left.
 - CoverHorizontalFromRight: Custom transition animation. Slides in horizontally from  right.
 */
public enum TransitionType{
    
    // System provided
    case CoverVertical
    case CrossDissolve
    case FlipHorizontal
    // Custom
    case CoverVerticalFromTop
    case CoverHorizontalFromRight
    case CoverHorizontalFromLeft
    
    /**
     Matches the 'TransitionType' to the system provided transition. If this returns nil it should be taken to mean that it's a custom transition, and should call the animation() method.
     
     - returns: UIKit transition style
     */
    func systemTransition() -> UIModalTransitionStyle?{
        switch self {
        case .CoverVertical:
            return UIModalTransitionStyle.CoverVertical
        case .CrossDissolve:
            return UIModalTransitionStyle.CrossDissolve
        case .FlipHorizontal:
            return UIModalTransitionStyle.FlipHorizontal
        default:
            return nil
        }
    }
    
    /**
     Associates a custom transition type to the class responsible for its animation.
     
     - returns: Object conforming to the 'PresentrAnimation' protocol, which in turn conforms to 'UIViewControllerAnimatedTransitioning'. Use this object for the custom animation.
     */
    func animation() -> PresentrAnimation?{
        switch self {
        case .CoverVerticalFromTop:
            return CoverVerticalFromTopAnimation()
        case .CoverHorizontalFromRight:
            return CoverHorizontalAnimation(fromRight: true)
        case .CoverHorizontalFromLeft:
            return CoverHorizontalAnimation(fromRight: false)
        default:
            return nil
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

    /**
     Calculates the exact width value for the presented view controller.
     
     - parameter parentSize: The presenting view controller's size. Provided by the presentation controller.
     
     - returns: Exact float width value.
     */
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
    
    /**
     Calculates the exact height value for the presented view controller.
     
     - parameter parentSize: The presenting view controller's size. Provided by the presentation controller.
     
     - returns: Exact float height value.
     */
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
 Describes the presented presented view controller's center position. It is meant to be non-specific, but we can use the 'calculatePoint' method when we want to calculate the exact point by passing in the 'containerBounds' rect that only the presentation controller should be aware of.
 
 - Center:       Center of the screen.
 - TopCenter:    Center of the top half of the screen.
 - BottomCenter: Center of the bottom half of the screen.
 */
public enum ModalCenterPosition {
    
    case Center
    case TopCenter
    case BottomCenter
    
    /**
     Calculates the exact position for the presented view controller center.
     
     - parameter containerBounds: The container bounds the controller is being presented in.
     
     - returns: CGPoint representing the presented view controller's center point.
     */
    func calculatePoint(containerBounds: CGRect) -> CGPoint{
        switch self {
        case .Center:
            return CGPointMake(containerBounds.width / 2, containerBounds.height / 2)
        case .TopCenter:
            return CGPointMake(containerBounds.width / 2, containerBounds.height * (1 / 4) - 1)
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
        static let alertTitle = "Alert"
        static let alertBody = "This is an alert."
    }
}

/// Main Presentr class. This is the point of entry for using the framework.
public class Presentr: NSObject {

    /// This must be set during initialization, but can be changed to reuse a Presentr object.
    public var presentationType: PresentationType
    
    /// The type of transition animation to be used to present the view controller. This is optional, if not provided the default for each presentation type will be used.
    public var transitionType: TransitionType?

    // MARK: Init
    
    public init(presentationType: PresentationType){
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
    private func presentViewController(presentingViewController presentingVC: UIViewController, presentedViewController presentedVC: UIViewController, animated: Bool, completion: (() -> Void)?){
        let transition = transitionType ?? presentationType.defaultTransitionType()
        if let systemTransition = transition.systemTransition(){
            presentedVC.modalTransitionStyle = systemTransition
        }
        presentedVC.transitioningDelegate = self
        presentedVC.modalPresentationStyle = .Custom
        presentingVC.presentViewController(presentedVC, animated: animated, completion: nil)
    }

}

// MARK: - UIViewController extension to provide customPresentViewController(_:viewController:animated:completion:) method

public extension UIViewController {
    func customPresentViewController(presentr: Presentr, viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        presentr.presentViewController(presentingViewController: self,
                                       presentedViewController: viewController,
                                       animated: animated,
                                       completion: completion)
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension Presentr: UIViewControllerTransitioningDelegate{
    
    public func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        return presentationController(presented, presenting: presenting)
    }
    
    public func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        return animation()
    }
    
    public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        return animation()
    }
    
    // MARK: - Private Helper's
    
    private func presentationController(presented: UIViewController, presenting: UIViewController) -> PresentrController {
        let presentationController = PresentrController(presentedViewController: presented, presentingViewController: presenting)
        presentationController.presentationType = presentationType
        return presentationController
    }
    
    private func animation() -> PresentrAnimation?{
        if let animation = transitionType?.animation() {
            return animation
        }else{
            return nil
        }
    }
    
}
