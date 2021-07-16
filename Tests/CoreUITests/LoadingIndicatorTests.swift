//
//  LoadingIndicatorTests.swift
//  MobileCoreTests
//
//  Created by Praveen Prabhakar on 12/07/20.
//  Copyright © 2020 Praveen Prabhakar. All rights reserved.
//

import CoreUtility
import CoreUI
import XCTest

final class LoadingIndicatorTests: XCTestCase {
    func testShowLoadingIndicator() {
        // when
        LoadingIndicator.show()
        // then
        let laodingIndicator: LoadingIndicator? = UIApplication.shared.keyWindow?.findInSubView()
        XCTAssertNotNil(laodingIndicator)
    }
}
