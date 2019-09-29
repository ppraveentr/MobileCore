//
//  FTUICollectionView.swift
//  FTCoreUtility
//
//  Created by Praveen Prabhakar on 22/10/18.
//  Copyright © 2018 Praveen Prabhakar. All rights reserved.
//

import Foundation

let kBackgroundViewTheme = "backgroundViewTheme"

extension UICollectionView: FTThemeProtocol {

    // Force update theme attibute
    public func updateTheme(_ theme: FTThemeModel) {
        if let view = self.backgroundView {
            if let bgTheme = theme[kBackgroundViewTheme] as? String {
                view.theme = bgTheme
            }
            else {
                view.theme = self.theme
            }
        }
    }
}
