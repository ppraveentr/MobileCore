//
//  AppThemingTestsUtility.swift
//  
//
//  Created by Praveen Prabhakar on 16/07/21.
//

#if canImport(AppTheming)
@testable import AppTheming
#endif
import Foundation
import UIKit

final class AppThemingTestsUtility {
    static var kMobileCoreBundle: Bundle = {
        #if canImport(AppTheming)
        return Bundle.module
        #else
        return Bundle(for: AppThemingTestsUtility.self)
        #endif
    }()
    static var kThemePath = kMobileCoreBundle.url(forResource: "Themes", withExtension: "json")?.absoluteString
}
