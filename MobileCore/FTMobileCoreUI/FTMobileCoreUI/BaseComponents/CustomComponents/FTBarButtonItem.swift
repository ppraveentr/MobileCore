//
//  FTBarButtonItem.swift
//  MobileCore
//
//  Created by Praveen P on 29/08/19.
//

import UIKit

public extension UIBarButtonItem {
    
    convenience init?(title: String? = nil,
                      image: UIImage? = nil,
                      action: Selector? = nil,
                      itemType: UIBarButtonItem.SystemItem = .done,
                      customView: UIView? = nil,
                      sender: Any? = nil) {
        
        guard title != nil, image != nil else {
            if let customView = customView {
                self.init(customView: customView)
            }
            self.init(barButtonSystemItem: itemType, target: sender, action: action)
            return
        }
        
        let button = FTButton(type: .custom)
        button.titleLabel?.text = title
        button.imageView?.image = image
        if let buttonAction = action {
            button.target(forAction: buttonAction, withSender: sender)
        }
        
        self.init(customView: button)
    }
}
