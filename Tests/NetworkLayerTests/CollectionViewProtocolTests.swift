//
//  CollectionViewProtocolTests.swift
//  MobileCoreTests
//
//  Created by Praveen P on 09/11/19.
//  Copyright © 2019 Praveen Prabhakar. All rights reserved.
//

#if canImport(NetworkLayer)
@testable import CoreComponents
@testable import CoreUtility
@testable import NetworkLayer
#endif
import XCTest

private final class MockCollectionViewController: UIViewController, CollectionViewControllerProtocol {
    // Mock: object implementation for testing
}

final class CollectionViewProtocolTests: XCTestCase {
    
    private let collectionVC = MockCollectionViewController()
    
    func testCollectionViewDefaults() {
        XCTAssertNotNil(collectionVC)
        XCTAssertEqual(collectionVC.estimatedItemSize(), CGSize.zero)
        XCTAssertEqual(collectionVC.sectionInset(), UIEdgeInsets.zero)
        XCTAssertEqual(collectionVC.collectionViewController, collectionVC.collectionViewController)
        XCTAssertEqual(collectionVC.collectionView, collectionVC.collectionView)
        
        // Custom CollectionView
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionVC.collectionView = collectionView
        XCTAssertEqual(collectionVC.collectionView, collectionView)
    }
}
