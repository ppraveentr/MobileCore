//
//  DownloadedImageTests.swift
//  CoreUtilityTests
//
//  Created by Praveen P on 12/10/19.
//  Copyright © 2019 Praveen Prabhakar. All rights reserved.
//

@testable import MobileCore
import XCTest

final class DownloadedImageTests: XCTestCase {
    
    private lazy var imagePath = kMobileCoreBundle?.path(forResource: "Pixel", ofType: "png")
    private lazy var imageURLPath = URL(fileURLWithPath: imagePath!)
    
    func testURLDownloadImage() {
        let promise = expectation(description: "Download data task completed.")
        imageURLPath.downloadedImage { image in
            XCTAssertNotNil(image)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
    
    func testUIImageView() {
        let imageView = UIImageView()
        let promise = expectation(description: "Download data task completed.")
        imageView.downloadedFrom(url: imageURLPath) { image in
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
