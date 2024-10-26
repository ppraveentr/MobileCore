//
//  ActionBlock.swift
//  MobileCore-CoreUtility
//
//  Created by Praveen Prabhakar on 13/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation
import UIKit

public typealias ActionBlock = () -> Swift.Void
public typealias ActionWithObjectBlock = (_ object: AnyObject?) -> Swift.Void

public extension UIControl {
    private struct AssociatedKey {
        static var actionBlockTapped = Int8(0) // "actionBlockTapped"
    }

    func addTapActionBlock(_ actionBlock: @escaping ActionBlock) {
        AssociatedObject<ActionBlock>.setAssociated(self, value: actionBlock, key: &AssociatedKey.actionBlockTapped)
        self.addTarget(self, action: #selector(actionBlockTapped), for: .touchUpInside)
    }

    @objc func actionBlockTapped() {
        let actionBlock: ActionBlock? = AssociatedObject.getAssociated(self, key: &AssociatedKey.actionBlockTapped)
        actionBlock?()
    }
}
