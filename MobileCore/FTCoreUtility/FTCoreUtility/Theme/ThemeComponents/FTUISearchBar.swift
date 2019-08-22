//
//  FTUISearchBar.swift
//  FTCoreUtility
//
//  Created by Praveen Prabhakar on 02/10/18.
//  Copyright © 2018 Praveen Prabhakar. All rights reserved.
//

import Foundation

open class FTUISearchBar: UISearchBar, FTThemeProtocol {

    public var preferredFont: UIFont?

    public var preferredTextColor: UIColor?

    public lazy var searchTextField: UITextField? = self.findInSubView()

    public init(frame: CGRect, font: UIFont? = nil, textColor: UIColor? = nil) {
        super.init(frame: frame)

        self.frame = frame
        preferredFont = font
        preferredTextColor = textColor

        searchBarStyle = .prominent
        isTranslucent = false
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override open func draw(_ rect: CGRect) {
        // Drawing code

        // Find the index of the search field in the search bar subviews.
        if let searchField = searchTextField {

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

            if let sting = searchField.attributedPlaceholder?.string, !att.isEmpty {
                searchField.attributedPlaceholder = NSAttributedString(string: sting, attributes: att)
            }

            // Set the background color of the search field.
            searchField.backgroundColor = .clear
        }

        super.draw(rect)
    }
}

public extension FTThemeProtocol where Self: UISearchBar {

    func updateTheme(_ theme: FTThemeModel) {

        var barTintColor: UIColor?
        var tintColor: UIColor?
        var textcolor: UIColor?

        for (kind, value) in theme {
            switch kind {
            case "barTintColor":
                barTintColor = getColor(value as? String)
            case "tintColor":
                tintColor = getColor(value as? String)
            case "textcolor":
                textcolor = getColor(value as? String)
            default:
                break
            }
        }

        configure(barTintColor: barTintColor, tintColor: tintColor, textColor: textcolor)
    }
}

public extension UISearchBar {

    func configure(barTintColor: UIColor? = nil, tintColor: UIColor? = nil, textColor: UIColor? = nil) {

        if let barTintColor = barTintColor {
            self.barTintColor = barTintColor
            self.backgroundImage = UIImage()
            self.backgroundColor = .clear
        }

        if let textColor = textColor, let self = self as? FTUISearchBar {
            self.preferredTextColor = textColor
            //            UILabel.appearance(whenContainedInInstancesOf: UISearchBar.self).textColor = preferredTextColor
        }

        guard let tintColor = tintColor else {
            return
        }

        self.tintColor = tintColor

        guard let textField: UITextField = findInSubView()  else {
            return
        }

        if let glassIconView = textField.leftView as? UIImageView {
            glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
            glassIconView.tintColor = tintColor
        }

        if let clearButton = textField.value(forKey: "clearButton") as? UIButton {
            clearButton.setImage(clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
            clearButton.tintColor = tintColor
        }
    }
}
