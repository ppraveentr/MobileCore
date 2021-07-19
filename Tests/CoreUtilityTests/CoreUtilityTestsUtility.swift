//
//  CoreUtilityTestsUtility.swift
//  
//
//  Created by Praveen Prabhakar on 16/07/21.
//

#if canImport(CoreUtility)
@testable import CoreUtility
#endif
import Foundation
import UIKit

final class CoreUtilityTestsUtility {
    static var kMobileCoreBundle: Bundle = {
        #if canImport(CoreUtility)
        return Bundle.module
        #else
        return Bundle(for: CoreUtilityTestsUtility.self)
        #endif
    }()
    static var kThemePath = kMobileCoreBundle.path(forResource: "Themes", ofType: "json")
}
