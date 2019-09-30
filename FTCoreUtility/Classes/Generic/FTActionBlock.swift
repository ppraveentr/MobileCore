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

    func addTapActionBlock(_ actionBlock: @escaping FTActionBlock) {
        FTAssociatedObject<FTActionBlock>.setAssociated(instance: self, value: actionBlock, key: &AssociatedKey.actionBlockTapped)
        self.addTarget(self, action: #selector(actionBlockTapped), for: .touchUpInside)
    }

    @objc func actionBlockTapped() {
        let actionBlock: FTActionBlock? = FTAssociatedObject.getAssociated(instance: self, key: &AssociatedKey.actionBlockTapped)
        actionBlock?()
    }
}
