//
//  DownloadedImageTests.swift
//  CoreUtilityTests
//
//  Created by Praveen P on 12/10/19.
//  Copyright © 2019 Praveen Prabhakar. All rights reserved.
//

import XCTest

final class DownloadedImageTests: XCTestCase {
    private lazy var imagePath = Utility.kMobileCoreBundle.path(forResource: "TestImage", ofType: "png")
    private lazy var imageURLPath = Utility.kMobileCoreBundle.url(forResource: "TestImage", withExtension: "png")
    
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
        imageView.downloadedFrom(url: path) { image in
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
