//
//  ModalLayout.swift
//  Presentr
//
//  Created by Apptek Studios on 23/4/18.
//

import Foundation

public struct ModalLayout {
    let width : Size
    let height : Size
    let positionAnchor : PositionAnchor
    let screenPosition : ScreenPosition
    
    public init(width : Size,
                height : Size,
                positionAnchor : PositionAnchor,
                screenPosition : ScreenPosition) {
        self.width = width
        self.height = height
        self.positionAnchor = positionAnchor
        self.screenPosition = screenPosition
    }
    
    func widthIn(presenterSize: CGSize) -> CGFloat? {
        return width.sizeIn(containerSize: presenterSize.width)
    }
    func heightIn(presenterSize: CGSize) -> CGFloat? {
        return height.sizeIn(containerSize: presenterSize.height)
    }
    
    func positionIn(presenterSize: CGSize) -> CGPoint {
        return screenPosition.positionIn(presenterSize: presenterSize)
    }
    
    var positionOffsetMultiplier : (x: CGFloat, y: CGFloat) {
        return positionAnchor.sizeMultiplier
    }

    //The position on the modal view for which we're specifying the position
    public enum PositionAnchor {
        case center
        case topLeft
        case topMiddle
        case topRight
        case bottomLeft
        case bottomMiddle
        case bottomRight
        case leftCenter
        case rightCenter
        case custom(x: CGFloat, y: CGFloat)
        
        var sizeMultiplier : (x: CGFloat, y: CGFloat) { ///Used to calculate origin using size
            switch self {
            case .center:
                return (x:0.5, y:0.5)
            case .topLeft:
                return (x:0, y:0)
            case .topMiddle:
                return (x:0.5, y:0)
            case .topRight:
                return (x:1.0, y:0)
            case .bottomLeft:
                return (x:0, y:1.0)
            case .bottomMiddle:
                return (x:0.5, y:1.0)
            case .bottomRight:
                return (x:1.0, y:1.0)
            case .leftCenter:
                return (x:0, y:0.5)
            case .rightCenter:
                return (x:1.0, y:0.5)
            case .custom(let x, let y):
                return (x:x, y:y)
            }
        }
    }
    
    //Sizing of modal
    public enum Size {
        case full
        case fraction(multiplier : CGFloat)
        case fixed(size : CGFloat)
        case inset(by : CGFloat)
        case autolayout //Determine required size using autolayout, capped to screen size
        
        //Extra default cases
        static let half = Size.fraction(multiplier: 0.5)
        
        func sizeIn(containerSize: CGFloat) -> CGFloat? {
            switch self {
            case .full:
                return containerSize
            case .fraction(let fraction):
                return containerSize * fraction
            case .fixed(let size):
                return size
            case .inset(let inset):
                return containerSize - inset * 2
            case .autolayout:
                return nil
            }
        }
    }
    
    /// Position of the modal view on the screen, using the 'PositionAnchor'
    public struct ScreenPosition {
        ////Predefined cases
        public static let topMiddle = ScreenPosition(horizontal: .middle, vertical: .top)
        public static let bottomMiddle = ScreenPosition(horizontal: .middle, vertical: .bottom)
        public static let center = ScreenPosition(horizontal: .middle, vertical: .center)
        
        /// Custom Case
        public static func custom(horizontalPosition : Horizontal,
                                  verticalPosition : Vertical,
                                  horizontalOffset : CGFloat = 0,
                                  verticalOffset : CGFloat = 0) -> ScreenPosition {
            
            return ScreenPosition.init(horizontal : horizontalPosition,
                                 vertical : verticalPosition,
                                 horizontalOffset : horizontalOffset,
                                 verticalOffset : verticalOffset)
        }
        
        
        /// Vars
        let horizontal : Horizontal
        let horizontalOffset : CGFloat
        let vertical : Vertical
        let verticalOffset : CGFloat
        
        
        
        
        
        
        public enum Vertical {
            case top
            case bottom
            case center
            case customFraction(fraction: CGFloat)
            
            var fraction : CGFloat {
                switch self {
                case .top:
                    return 0
                case .bottom:
                    return 1.0
                case .center:
                    return 0.5
                case .customFraction(let fraction):
                    return fraction
                }
            }
        }
        public enum Horizontal {
            case left
            case middle
            case right
            case customFraction(fraction: CGFloat)
            var fraction : CGFloat {
                switch self {
                case .left:
                    return 0
                case .right:
                    return 1.0
                case .middle:
                    return 0.5
                case .customFraction(let fraction):
                    return fraction
                }
            }
        }
        
        
        
        private init(horizontal : Horizontal,
                     vertical : Vertical,
                     horizontalOffset : CGFloat = 0,
                     verticalOffset : CGFloat = 0) {
            self.horizontal = horizontal
            self.vertical = vertical
            self.horizontalOffset = horizontalOffset
            self.verticalOffset = verticalOffset
        }
        
        
        
        
        func positionIn(presenterSize: CGSize) -> CGPoint {
            return CGPoint(x: presenterSize.width * horizontal.fraction + horizontalOffset,
                           y: presenterSize.height * vertical.fraction + verticalOffset)
        }
    }
    
}
