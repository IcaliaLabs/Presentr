//
//  KeyboardTranslation.swift
//  Presentr
//
//  Created by Aaron Satterfield on 7/15/16.
//  Copyright © 2016 danielozano. All rights reserved.
//

import Foundation
import UIKit

public protocol PresentrKeyboardDelegate {
    func shouldDismissKeyboard();
}

public enum KeyboardTranslationType {
    case None, MoveUp, Compress
    
    public static func getTranslationFrame (type : KeyboardTranslationType, keyboardFrame : CGRect, presentedFrame : CGRect) -> CGRect {
        switch type {
        case MoveUp:
            let keyboardTop = UIScreen.mainScreen().bounds.height - keyboardFrame.size.height
            let presentedViewBottom = presentedFrame.origin.y + presentedFrame.height + 20 // add a 20 pt buffer
            let offset = presentedViewBottom - keyboardTop
            print(offset)
            if offset > 0 {
                return CGRectMake(presentedFrame.origin.x, presentedFrame.origin.y-offset, presentedFrame.size.width, presentedFrame.size.height)
            }
            return presentedFrame
        case Compress:
            let keyboardTop = UIScreen.mainScreen().bounds.height - keyboardFrame.size.height
            let presentedViewBottom = presentedFrame.origin.y + presentedFrame.height + 20 // add a 20 pt buffer
            let offset = presentedViewBottom - keyboardTop
            print(offset)
            if offset > 0 {
                return CGRectMake(presentedFrame.origin.x, max(presentedFrame.origin.y-offset, presentedFrame.origin.y+20), presentedFrame.size.width, presentedFrame.size.height)
            }
            return presentedFrame
        case None:
            return presentedFrame
        }
    }
}