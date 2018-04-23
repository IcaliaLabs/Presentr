//
//  ModalLayout.swift
//  Presentr
//
//  Created by Toby Brennan on 23/4/18.
//

import Foundation

public struct ModalLayout {
    let width : Size
    let height : Size
    let positionReference : PositioningReference
    let position : Position
    
    public init(width : Size,
                height : Size,
                positionReference : PositioningReference,
                position : Position) {
        self.width = width
        self.height = height
        self.positionReference = positionReference
        self.position = position
    }
    
    func widthIn(presenterSize: CGSize) -> CGFloat? {
        return width.sizeIn(containerSize: presenterSize.width)
    }
    func heightIn(presenterSize: CGSize) -> CGFloat? {
        return height.sizeIn(containerSize: presenterSize.height)
    }
    
    func positionIn(presenterSize: CGSize) -> CGPoint {
        return position.positionIn(presenterSize: presenterSize)
    }
    
    var positionOffsetMultiplier : (x: CGFloat, y: CGFloat) {
        return positionReference.sizeMultiplier
    }

    public enum PositioningReference {
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
    public enum Size {
        case full
        case fraction(multiplier : CGFloat)
        case fixed(size : CGFloat)
        case inset(by : CGFloat)
        //case orientationDependent
        
        static let half = Size.fraction(multiplier: 0.5)
        
        func sizeIn(containerSize: CGFloat) -> CGFloat {
            switch self {
            case .full:
                return containerSize
            case .fraction(let fraction):
                return containerSize * fraction
            case .fixed(let size):
                return size
            case .inset(let inset):
                return containerSize - inset * 2
            }
        }
    }
    public struct Position {
        public static let top = Position(horizontal: .middle, vertical: .top)
        public static let bottom = Position(horizontal: .middle, vertical: .bottom)
        public static let center = Position(horizontal: .middle, vertical: .center)
        
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
        
        let horizontal : Horizontal
        let horizontalOffset : CGFloat
        let vertical : Vertical
        let verticalOffset : CGFloat
        
        private init(horizontal : Horizontal,
             vertical : Vertical,
             horizontalOffset : CGFloat = 0,
             verticalOffset : CGFloat = 0) {
            self.horizontal = horizontal
            self.vertical = vertical
            self.horizontalOffset = horizontalOffset
            self.verticalOffset = verticalOffset
        }
        
        public static func custom(horizontal : Horizontal,
                           vertical : Vertical,
                           horizontalOffset : CGFloat = 0,
                           verticalOffset : CGFloat = 0) -> Position {
            
            return Position.init(horizontal : horizontal,
                                 vertical : vertical,
                                 horizontalOffset : horizontalOffset,
                                 verticalOffset : verticalOffset)
        }
        
        
        func positionIn(presenterSize: CGSize) -> CGPoint {
            return CGPoint(x: presenterSize.width * horizontal.fraction + horizontalOffset,
                           y: presenterSize.height * vertical.fraction + verticalOffset)
        }
    }

}
