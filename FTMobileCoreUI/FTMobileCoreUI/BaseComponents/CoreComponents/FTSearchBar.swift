//
//  FTSearchBar.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 25/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import UIKit

open class FTSearchBar: UISearchBar {
    
    var preferredFont: UIFont?
    
    var preferredTextColor: UIColor?
    
    public init(frame: CGRect, font: UIFont? = nil, textColor: UIColor? = nil) {
        super.init(frame: frame)
        
        self.frame = frame
        preferredFont = font
        preferredTextColor = textColor
        
        searchBarStyle = .prominent
        isTranslucent = false
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override open func draw(_ rect: CGRect) {
        // Drawing code

        // Find the index of the search field in the search bar subviews.
        if let searchField: UITextField =  self.findInSubView() {
            
            // Set its frame.
            searchField.frame = CGRect(x: 5.0, y: 5.0, width: frame.width - 10.0, height: frame.height - 10.0)
            
            var att: [NSAttributedString.Key:AnyObject] = [:]
            
            // Set the font and text color of the search field.
            if preferredFont != nil {
                 searchField.font = preferredFont
            }
            
            if let font = searchField.font?.withSize((searchField.font?.pointSize)! - 1) {
                att[.font] = font
            }
            
            if preferredTextColor != nil {
                searchField.textColor = preferredTextColor
                att[.foregroundColor] = preferredTextColor
            }
            
            if let sting = searchField.attributedPlaceholder?.string, att.count > 0 {
                searchField.attributedPlaceholder = NSAttributedString(string:sting , attributes:att)
            }

            
            // Set the background color of the search field.
            searchField.backgroundColor = .clear
        }
        
//        if let preferredTextColor = preferredTextColor {
        
//            self.layer.borderColor = preferredTextColor.cgColor
//            self.layer.borderWidth = 0.2
//            self.layer.cornerRadius = 5.0
//
//            let startPoint = CGPoint(x: 0.0, y: frame.size.height)
//            let endPoint = CGPoint(x: frame.size.width, y: frame.size.height)
//            let path = UIBezierPath()
//            path.move(to: startPoint)
//            path.addLine(to: endPoint)
//            
//            let shapeLayer = CAShapeLayer()
//            shapeLayer.path = path.cgPath
//            shapeLayer.strokeColor = preferredTextColor.cgColor
//            shapeLayer.lineWidth = 2.5
//            
//            layer.addSublayer(shapeLayer)
//        }
        
        super.draw(rect)
    }
    
    public func configure(barTintColor: UIColor? = nil, tintColor: UIColor? = nil, textColor: UIColor? = nil) {
        
        if let barTintColor = barTintColor {
            self.barTintColor = barTintColor
            self.backgroundImage = UIImage()
            self.backgroundColor = .clear
        }
        
        if let textColor = textColor {
            preferredTextColor = textColor
//            UILabel.appearance(whenContainedInInstancesOf: UISearchBar.self).textColor = preferredTextColor
        }
        
        guard let tintColor = tintColor else {
            return
        }
        
        self.tintColor = tintColor
        
        let textField = self.value(forKey: "searchField") as! UITextField
        
        if let glassIconView = textField.leftView as? UIImageView {
            glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
            glassIconView.tintColor = tintColor
        }
        
        if let clearButton = textField.value(forKey: "clearButton") as? UIButton {
            clearButton.setImage(clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
            clearButton.tintColor = tintColor
        }
    }

    func searchFieldInSubviews() -> UITextField? {
        let textField: UITextField? =  self.findInSubView()
        return textField
    }
}

