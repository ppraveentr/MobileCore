//
//  FTTestClasses.swift
//  MobileCoreTests
//
//  Created by Praveen P on 12/10/19.
//  Copyright © 2019 Praveen Prabhakar. All rights reserved.
//

@testable import MobileCore
import Foundation

final class TestSwizzling {
    @objc dynamic func getMessage() -> String { return "getMessage" }
    @objc dynamic func swizzledMessage() -> String { return "swizzledMessage" }
    
    // Swizzling out view's layoutSubviews property for Updating Visual theme
    static func swizzleTestMethod() {
        FTInstanceSwizzling(TestSwizzling.self, #selector(TestSwizzling.getMessage), #selector(TestSwizzling.swizzledMessage))
    }
}
