//
//  FTUISegmentControll.swift
//  MobileCore
//
//  Created by Praveen P on 24/10/19.
//

import Foundation

extension UISegmentedControl: FTThemeProtocol {
    
    public func updateTheme(_ theme: FTThemeModel) {
        if let text = theme["tintColor"] as? String, let color: UIColor = FTThemesManager.getColor(text) {
            self.tintColor = color
        }
        
        if #available(iOS 13, *), (theme["iOS12Style"] as? Bool) == true {
            // Update with iOS 12 style
            var textFont: UIFont = .systemFont(ofSize: 13, weight: .regular)
            if let text = theme["textfont"] as? String, let font: UIFont = FTThemesManager.getFont(text) {
                textFont = font
            }
            var textcolor: UIColor = .white
            if let text = theme["textcolor"] as? String, let color: UIColor = FTThemesManager.getColor(text) {
                textcolor = color
            }
            ensureiOS12Style(font: textFont, textColor: textcolor)
        }
    }

    func ensureiOS12Style(font: UIFont, textColor: UIColor = .white) {
        self.backgroundColor = UIColor.clear
        
        let tintColorImage = UIImage(color: tintColor)
        // Must set the background image for normal to something (even clear) else the rest won't work
        setBackgroundImage(UIImage(color: backgroundColor ?? .clear), for: .normal, barMetrics: .default)
        setBackgroundImage(tintColorImage, for: .selected, barMetrics: .default)
        setBackgroundImage(tintColor.generateImage(opacity: 0.2), for: .highlighted, barMetrics: .default)
        setBackgroundImage(tintColorImage, for: [.highlighted, .selected], barMetrics: .default)
        setTitleTextAttributes([.foregroundColor: textColor, .font: font], for: .normal)
        setTitleTextAttributes([.foregroundColor: tintColor!, .font: font], for: .selected)
        setDividerImage(tintColorImage, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        layer.borderWidth = 1
        layer.borderColor = tintColor.cgColor
    }
}
