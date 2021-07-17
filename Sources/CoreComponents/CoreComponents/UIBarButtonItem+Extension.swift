//
//  BarButtonItem+Extension.swift
//  MobileCore-CoreComponents
//
//  Created by Praveen P on 29/08/19.
//

import UIKit

public extension UIBarButtonItem {
    
    convenience init?(title: String? = nil,
                      image: UIImage? = nil,
                      action: Selector? = nil,
                      itemType: UIBarButtonItem.SystemItem = .done,
                      target: Any? = nil) {
        
        guard title != nil, image != nil else {
            self.init(barButtonSystemItem: itemType, target: target, action: action)
            return
        }
        
        let button = UIButton(type: .custom)
        button.titleLabel?.text = title
        button.imageView?.image = image
        if let buttonAction = action {
            button.addTarget(target, action: buttonAction, for: .touchUpInside)
        }
        
        self.init(customView: button)
    }
}
