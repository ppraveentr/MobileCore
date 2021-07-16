//
//  LoadingIndicatorTests.swift
//  MobileCoreTests
//
//  Created by Praveen Prabhakar on 12/07/20.
//  Copyright © 2020 Praveen Prabhakar. All rights reserved.
//

#if canImport(CoreUI)
import CoreUI
import CoreUtility
#endif
import XCTest

final class LoadingIndicatorTests: XCTestCase {
    func testShowLoadingIndicator() {
        // when
        LoadingIndicator.show()
        // then
        #if !canImport(CoreUI)
        let laodingIndicator: LoadingIndicator? = UIApplication.shared.keyWindow?.findInSubView()
        XCTAssertNotNil(laodingIndicator)
        #endif
    }
}
