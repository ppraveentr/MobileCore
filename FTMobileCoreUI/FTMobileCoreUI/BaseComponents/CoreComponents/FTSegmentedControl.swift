//
//  FTSegmentedControl.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 05/03/18.
//  Copyright © 2018 Praveen Prabhakar. All rights reserved.
//

import UIKit

open class FTSegmentedControl: UISegmentedControl {
 
    var handler: ((_ index: Int) -> ())?
    
    public required convenience init(items: [Any], completionHandler: @escaping (Int) -> () ) {
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
