//
//  FTUISearchBar.swift
//  FTCoreUtility
//
//  Created by Praveen Prabhakar on 02/10/18.
//  Copyright © 2018 Praveen Prabhakar. All rights reserved.
//

import Foundation

// MARK: FTAssociatedKey
private extension FTAssociatedKey {
    static var searchUITextField = "searchUITextField"
    static var searchBarAttributes = "searchBarAttributes"
}

private typealias SearchBarAttributes = [NSAttributedString.Key: AnyObject]

// MARK: UISearchBar
extension UISearchBar: FTThemeProtocol {

    public func updateTheme(_ theme: FTThemeModel) {
        searchBarStyle = .prominent
        isTranslucent = false        
        var tintColor: UIColor?
        var textcolor: UIColor?
        var font: UIFont?
        
        for (kind, value) in theme {
            switch kind {
            case "barTintColor":
                if let barTintColor = getColor(value as? String) {
                    self.barTintColor = barTintColor
                    self.backgroundImage = UIImage()
                    self.backgroundColor = .clear
                }
            case "tintColor":
                tintColor = getColor(value as? String)
            case "textcolor":
                textcolor = getColor(value as? String)
            case "textfont":
                font = getFont(value as? String)
            default:
                break
            }
        }
        
        addObserver(self, forKeyPath: #keyPath(UISearchBar.placeholder), options: [.new], context: nil)
        
        configure(tintColor: tintColor, textColor: textcolor, font: font)
    }
    
    // MARK: - Key-Value Observing
    // swiftlint:disable block_based_kvo
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard let searchField = searchUITextField, let att = searchBarAttributes, !att.isEmpty else {
            return
        }
        if keyPath == #keyPath(UISearchBar.placeholder),
            let sting = searchField.attributedPlaceholder?.string {
            // Update placeHolder
            searchField.attributedPlaceholder = NSAttributedString(string: sting, attributes: att)
        }
    }
    // swiftlint:enable block_based_kvo
}

// MARK: UISearchBar
private extension UISearchBar {
    // MARK: SearchTextField
    var searchUITextField: UITextField? {
        get {
            if let textField: UITextField = FTAssociatedObject.getAssociated(self, key: &FTAssociatedKey.searchUITextField) {
                return textField
            }
            let textField: UITextField? = self.findInSubView()
            self.searchUITextField = textField
            return textField
        }
        set {
            FTAssociatedObject<UITextField>.setAssociated(self, value: newValue, key: &FTAssociatedKey.searchUITextField)
        }
    }
    
    // MARK: SearchTextField
    var searchBarAttributes: SearchBarAttributes? {
        get {
            return  FTAssociatedObject.getAssociated(self, key: &FTAssociatedKey.searchBarAttributes)
        }
        set {
            FTAssociatedObject<SearchBarAttributes>.setAssociated(self, value: newValue, key: &FTAssociatedKey.searchBarAttributes)
        }
    }
    
    func configure(tintColor: UIColor? = nil, textColor: UIColor? = nil, font: UIFont? = nil) {
        guard let tintColor = tintColor else { return }
        self.tintColor = tintColor
        
        guard let textField: UITextField = searchUITextField else { return }
        
        if let glassIconView = textField.leftView as? UIImageView {
            glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
            glassIconView.tintColor = tintColor
        }
        
        if let clearButton = textField.value(forKey: "clearButton") as? UIButton {
            clearButton.setImage(clearButton.imageView?.image?.withRenderingMode(.automatic), for: .normal)
            clearButton.tintColor = tintColor
        }
        
        update(font: font, textColor: textColor)
    }
    
    func update(font: UIFont?, textColor: UIColor?) {
        
        // Find the index of the search field in the search bar subviews.
        if let searchField = searchUITextField {
            // Set its frame.
            searchField.frame = CGRect(x: 5.0, y: 5.0, width: frame.width - 10.0, height: frame.height - 10.0)
            
            var att = SearchBarAttributes()
            // Set the font and text color of the search field.
            if font != nil {
                searchField.font = font
            }
            if let font = searchField.font?.withSize((searchField.font?.pointSize)! - 1) {
                att[.font] = font
            }
            if textColor != nil {
                searchField.textColor = textColor
                att[.foregroundColor] = textColor
                //let label = UILabel.appearance(whenContainedInInstancesOf: [UISearchBar.self])
                //label.textColor = textColor
            }
            if let sting = searchField.attributedPlaceholder?.string, !att.isEmpty {
                searchField.attributedPlaceholder = NSAttributedString(string: sting, attributes: att)
            }
            
            // Save preference
            self.searchBarAttributes = att
            // Set the background color of the search field.
            searchField.backgroundColor = .clear
        }
    }
}
