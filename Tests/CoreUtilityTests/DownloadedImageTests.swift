//
//  DownloadedImageTests.swift
//  CoreUtilityTests
//
//  Created by Praveen P on 12/10/19.
//  Copyright © 2019 Praveen Prabhakar. All rights reserved.
//

#if canImport(CoreUtility)
@testable import CoreUtility
#endif
import XCTest

final class DownloadedImageTests: XCTestCase {
    private lazy var imagePath = CoreUtilityTestsUtility.kMobileCoreBundle.path(forResource: "TestImage", ofType: "png")
    private lazy var imageURLPath = CoreUtilityTestsUtility.kMobileCoreBundle.url(forResource: "TestImage", withExtension: "png")
    
    func testURLDownloadImage() {
        guard let path = imageURLPath else { return }
        let promise = expectation(description: "Download data task completed.")
        path.downloadedImage { image in
            XCTAssertNotNil(image)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
    
    func testUIImageView() {
        guard let path = imageURLPath else { return }
        let imageView = UIImageView()
        let promise = expectation(description: "Download data task completed.")
        imageView.downloadedFrom(path) { image in
            XCTAssertNotNil(image)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
    
    func testDownloadImageFail() {
        let promise = expectation(description: "Download data task completed.")
        URL(fileURLWithPath: "").downloadedImage { image in
            XCTAssertNil(image)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
}
