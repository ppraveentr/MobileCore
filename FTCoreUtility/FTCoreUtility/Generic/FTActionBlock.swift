//
//  FTActionBlock.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 13/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

public typealias FTActionBlock = () -> Swift.Void

public extension UIControl {

    private struct AssociatedKey {
        static var actionBlockTapped = "actionBlockTapped"
    }

    func addObserverActionBlock(_ actionBlock: @escaping FTActionBlock) {
        objc_setAssociatedObject(self, &AssociatedKey.actionBlockTapped, actionBlock, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        self.addTarget(self, action: #selector(actionBlockTapped), for: .touchUpInside)
    }


    func addTapActionBlock(_ actionBlock: @escaping FTActionBlock) {
        objc_setAssociatedObject(self, &AssociatedKey.actionBlockTapped, actionBlock, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        self.addTarget(self, action: #selector(actionBlockTapped), for: .touchUpInside)
    }

    @objc func actionBlockTapped(_ sender: UIControl) {
        let actionBlock: FTActionBlock? = objc_getAssociatedObject(self, &AssociatedKey.actionBlockTapped) as? FTActionBlock
        actionBlock?()
    }

}
