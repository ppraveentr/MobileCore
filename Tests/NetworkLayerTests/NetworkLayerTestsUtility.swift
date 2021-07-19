//
//  NetworkLayerTestsUtility.swift
//  
//
//  Created by Praveen Prabhakar on 16/07/21.
//

import Foundation
#if canImport(NetworkLayer)
@testable import NetworkLayer
#endif
import UIKit

final class NetworkLayerTestsUtility {
    static var kMobileCoreBundle: Bundle = {
        #if canImport(NetworkLayer)
        return Bundle.module
        #else
        return Bundle(for: NetworkLayerTestsUtility.self)
        #endif
    }()
    static var kThemePath = kMobileCoreBundle.path(forResource: "Themes", ofType: "json")
}
