//
//  FTSegmentedControl.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 05/03/18.
//  Copyright © 2018 Praveen Prabhakar. All rights reserved.
//

import UIKit

public typealias FTSegmentedHandler = ( (_ index: Int) -> () )

open class FTSegmentedControl: UISegmentedControl {
 
    public var handler: FTSegmentedHandler?

    public required convenience init(items: [Any], completionHandler: FTSegmentedHandler? ) {
        self.init(items: items)
        selectedSegmentIndex = 0
        handler = completionHandler
        addTarget(self, action: #selector(FTSegmentedControl.segmentedControlIndexChanged(_:)), for: .valueChanged)
    }
    
    @objc func segmentedControlIndexChanged(_ sender: UISegmentedControl) {
        if let completionBlock = self.handler {
            completionBlock(self.selectedSegmentIndex)
        }
    }
    
}
