//
//  SegmentedControl+Extension.swift
//  CoreUIExtensions
//
//  Created by Praveen Prabhakar on 05/03/18.
//  Copyright © 2018 Praveen Prabhakar. All rights reserved.
//

import CoreUtility
import UIKit

public typealias SegmentedHandler = ( (_ index: Int) -> Void )

public extension UISegmentedControl {
    private static let aoHandler = AssociatedObject<SegmentedHandler>()

    var handler: SegmentedHandler? {
        get {
            UISegmentedControl.aoHandler[self]
        }
        set {
            UISegmentedControl.aoHandler[self] = newValue
        }
    }
    
    convenience init(items: [Any], completionHandler: SegmentedHandler? ) {
        self.init(items: items)
        selectedSegmentIndex = 0
        handler = completionHandler
        addTarget(self, action: #selector(UISegmentedControl.segmentedControlIndexChanged), for: .valueChanged)
    }
    
    @objc
    func segmentedControlIndexChanged() {
        if let completionBlock = UISegmentedControl.aoHandler[self] {
            completionBlock(self.selectedSegmentIndex)
        }
    }
}
