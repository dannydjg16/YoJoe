//
//  smallViewInBigView.swift
//  MoJoe
//
//  Created by Daniel Grant on 2/6/19.
//  Copyright © 2019 Daniel Grant. All rights reserved.
//

import Foundation
import UIKit

//This is the class that i want to use for when i am presenting a modal vc to help with reviews. It could also have other uses for times when i want there to be a modal popover type thing that covers like 2/3 of the screen.
class smallViewInBigView: UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        get {
            guard let view = containerView else {
                return CGRect.zero
            }
            return CGRect(x: 0, y: view.bounds.height/3, width: view.bounds.width, height: view.bounds.height )
        }
    }
}
