//
//  UINavigationBar+Theme.swift
//  MobileCore-AppTheming
//
//  Created by Praveen Prabhakar on 16/09/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation
import UIKit

public extension UINavigationBar {
    
    /**
     *  Configures the navigation bar to use an image as its background.
     */
    static func applyBackgroundImage(
        navigationBar: UINavigationBar?,
        defaultColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
        landScapeColor landScape: UIColor? = nil ) {
        
        self.applyBackgroundImage(
            navigationBar: navigationBar,
            defaultImage: defaultColor.generateImage(),
            landScapeImage: landScape?.generateImage() ?? defaultColor.generateImage()
        )
    }
    
    /**
     *  Configures the navigation bar to use an image as its background.
     */
    static func applyBackgroundImage(
        navigationBar: UINavigationBar?,
        defaultImage: UIImage? = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).generateImage(),
        landScapeImage landScape: UIImage? = nil) {
        
        // These background images contain a small pattern which is displayed
        // in the lower right corner of the navigation bar.
        var defaultImage = defaultImage
        var landScape = landScape ?? defaultImage
        
        // Both of the above images are smaller than the navigation bar's
        // size.  To enable the images to resize gracefully while keeping their
        // content pinned to the bottom right corner of the bar, the images are
        // converted into resizable images width edge insets extending from the
        // bottom up to the second row of pixels from the top, and from the
        // right over to the second column of pixels from the left.  This results
        // in the topmost and leftmost pixels being stretched when the images
        // are resized.  Not coincidentally, the pixels in these rows/columns
        // are empty.
        if let localImage = defaultImage {
            defaultImage = localImage.resizableImage(
                withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: localImage.size.height - 1, right: localImage.size.width - 1)
            )
        }
        
        if let localImage = landScape {
            landScape = localImage.resizableImage(
                withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: localImage.size.height - 1, right: localImage.size.width - 1)
            )
        }
        let navigationBar = navigationBar ??
            UINavigationBar.appearance(whenContainedInInstancesOf: [UINavigationController.self])
        
        // The bar metrics associated with a background image determine when it
        // is used.  The background image associated with the defaultImage bar metrics
        // is used when a more suitable background image can not be found.
        navigationBar.setBackgroundImage(defaultImage, for: .default)
        
        // The background image associated with the LandscapePhone bar metrics
        // is used by the shorter variant of the navigation bar that is used on
        // iPhone when in landscape.
        navigationBar.setBackgroundImage(landScape, for: .compact)
    }
    
    /**
     *  Configures the navigation bar to use a transparent background (see-through
     *  but without any blur).
     */
    static func applyTransparentBackground(navigationBar: UINavigationBar?, _ opacity: CGFloat) {
        
        let navigationBar = navigationBar ??
            UINavigationBar.appearance(whenContainedInInstancesOf: [UINavigationController.self])
        
        // The background of a navigation bar switches from being translucent
        // to transparent when a background image is applied.  The intensity of
        // the background image's alpha channel is inversely related to the
        // transparency of the bar.  That is, a smaller alpha channel intensity
        // results in a more transparent bar and vis-versa.
        // 
        // Below, background image is dynamically generated with the desired
        // opacity.
        if let transparentBackground = UIColor.white.generateImage( opacity: opacity, contentsScale: navigationBar.layer.contentsScale) {
            navigationBar.setBackgroundImage(transparentBackground, for: .default)
        }
    }
    
    /**
     *  Configures the navigation bar to use a custom color as its background.
     *  The navigation bar remains translucent.
     */
    static func applyTintColor(navigationBar: UINavigationBar?, _ color: UIColor) {
        
        let navigationBar = navigationBar ??
            UINavigationBar.appearance(whenContainedInInstancesOf: [UINavigationController.self])
        
        navigationBar.barTintColor = color
        navigationBar.tintColor = color
    }
}
