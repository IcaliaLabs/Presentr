//
//  PresentrAnimation.swift
//  Presentr
//
//  Created by Daniel Lozano on 5/14/16.
//  Copyright © 2016 danielozano. All rights reserved.
//

import Foundation

protocol PresentrAnimation: UIViewControllerAnimatedTransitioning{
    var isPresenting: Bool { get set }
}