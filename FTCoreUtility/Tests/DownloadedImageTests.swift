//
//  DownloadedImageTests.swift
//  MobileCoreTests
//
//  Created by Praveen P on 12/10/19.
//  Copyright © 2019 Praveen Prabhakar. All rights reserved.
//

@testable import MobileCore
import XCTest

final class DownloadedImageTests: XCTestCase {
    
    private lazy var imagePath = kFTMobileCoreBundle?.path(forResource: "upArrow", ofType: "png")
    private lazy var imageURLPath = URL(fileURLWithPath: imagePath!).absoluteString
    
    func testUIImageView() {
        let imageView = UIImageView()
        let promise = expectation(description: "Download data task completed.")
        imageView.downloadedFrom(
            link: imageURLPath,
            comletionHandler: { image in
                XCTAssertNotNil(image)
                XCTAssertNotNil(imageView.image)
                promise.fulfill()
        })
        wait(for: [promise], timeout: 5)
    }
    
//    func testDownloadImageFail() {
//        let promise = expectation(description: "Download data task completed.")
//        UIImageView().downloadedFrom(
//            link: "",
//            comletionHandler: { image in
//                XCTAssertNil(image)
//                promise.fulfill()
//        })
//        wait(for: [promise], timeout: 5)
//    }
}
