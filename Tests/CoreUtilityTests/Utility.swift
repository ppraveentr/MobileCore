//
//  File.swift
//  
//
//  Created by Praveen Prabhakar on 16/07/21.
//

import Foundation
import UIKit

final class Utility {
    public static var kMobileCoreBundle = Bundle(for: Utility.self)
    public static var kThemePath = kMobileCoreBundle.path(forResource: "Themes", ofType: "json")
}
