//
//  ConfigurableCellTests.swift
//  CoreUtilityTests
//
//  Created by Praveen Prabhakar on 05/07/20.
//  Copyright © 2020 Praveen Prabhakar. All rights reserved.
//

@testable import MobileCore
import XCTest

fileprivate final class MockViewCellWithoutNib: UIView {
}

final class ConfigurableCellTests: XCTestCase {
    // private lazy var mockCell: MockTableViewCell?
    private let mockTableView = UITableView()
    private let mockCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())

    func testDefaultNib() {
        XCTAssertEqual(MockTableViewCell.defaultNibName, "MockTableViewCell")
        XCTAssertEqual(MockTableViewCell.defaultReuseIdentifier, "MockTableViewCellID")
        // Cell without nib
        do {
            let errorNib = try MockViewCellWithoutNib.loadNibFromBundle()
            XCTAssertNil(errorNib, "Should have failed to load nib")
        }
        catch {
            XCTAssertNotNil(error, "Should have failed to load nib")
        }
    }
    
    // MARK: TableView
    func testTableViewLoadNib() {
        // let
        let mockCell = try? MockTableViewCell.loadNibFromBundle()
        XCTAssertNotNil(mockCell, "Should have loaded nib")
        // Cell with nib file
        let mockNib = MockTableViewCell.getNib()
        XCTAssertNotNil(mockNib, "Should have loaded nib")
    }
    
    func testTableViewRegisterNib() {
        // let
        let indexPath = IndexPath(row: 0, section: 0)
        // when
        MockTableViewCell.registerNib(for: mockTableView)
        let cell: MockTableViewCell? = try? .dequeue(from: mockTableView, for: indexPath)
        // then
        XCTAssertNotNil(cell, "Should have dequeue cell")
        XCTAssertNotNil(mockTableView.dequeueReusableCell(withIdentifier: MockTableViewCell.defaultReuseIdentifier))
    }
    
    func testTableViewRegisterCell() {
        // let
        let indexPath = IndexPath(row: 0, section: 0)
        // when
        MockTableViewCell.registerClass(for: mockTableView)
        let cell: MockTableViewCell? = try? .dequeue(from: mockTableView, for: indexPath)
        // then
        XCTAssertNotNil(cell, "Should have dequeue cell")
        XCTAssertNotNil(mockTableView.dequeueReusableCell(withIdentifier: MockTableViewCell.defaultReuseIdentifier))
    }
    
    func testTableViewCellCustomReuseID() {
        // let
        let customReuseID = "reuseID"
        // when Register cell with Custom reuseIdentifier
        MockTableViewCell.registerClass(for: mockTableView, reuseIdentifier: customReuseID)
        // then
        XCTAssertNil(mockTableView.dequeueReusableCell(withIdentifier: MockTableViewCell.defaultReuseIdentifier),
                     "Should not have dequeue cell as reuseIdentifier not found")
        XCTAssertNotNil(mockTableView.dequeueReusableCell(withIdentifier: customReuseID),
                        "Should have dequeue cell as with \(customReuseID) reuseIdentifier")
    }
    
    // MARK: CollectionView
    func testCollectionViewLoadNib() {
        // let
        let mockCell = try? MockCollectionViewCell.loadNibFromBundle()
        XCTAssertNotNil(mockCell, "Should have loaded nib")
        // Cell with nib file
        let mockNib = MockCollectionViewCell.getNib()
        XCTAssertNotNil(mockNib, "Should have loaded nib")
    }
    
    func testCollectionViewRegisterNib() {
        // let
        let indexPath = IndexPath(row: 0, section: 0)
        // when
        MockCollectionViewCell.registerNib(for: mockCollectionView)
        let cell: MockCollectionViewCell? = try? .dequeue(from: mockCollectionView, for: indexPath)
        // then
        XCTAssertNotNil(cell, "Should have dequeue cell")
        // let
        let cellMock = mockCollectionView.dequeueReusableCell(withReuseIdentifier: MockCollectionViewCell.defaultReuseIdentifier, for: indexPath)
        XCTAssertNotNil(cellMock, "Should have dequeue cell")
    }
    
    func testCollectionViewRegisterCell() {
        // let
        let indexPath = IndexPath(row: 0, section: 0)
        // when
        MockCollectionViewCell.registerClass(for: mockCollectionView)
        let cell: MockCollectionViewCell? = try? .dequeue(from: mockCollectionView, for: indexPath)
        // then
        XCTAssertNotNil(cell, "Should have dequeue cell")
        // let
        let cellMock = mockCollectionView.dequeueReusableCell(withReuseIdentifier: MockCollectionViewCell.defaultReuseIdentifier, for: indexPath)
        XCTAssertNotNil(cellMock, "Should have dequeue cell")
    }
    
    func testCollectionViewCellCustomReuseID() {
        // let
        let indexPath = IndexPath(row: 0, section: 0)
        let customReuseID = "reuseID"
        // when Register cell with Custom reuseIdentifier
        MockCollectionViewCell.registerClass(for: mockCollectionView, reuseIdentifier: customReuseID)
        // then
        XCTAssertNotNil(mockCollectionView.dequeueReusableCell(withReuseIdentifier: customReuseID, for: indexPath),
                        "Should have dequeue cell as with \(customReuseID) reuseIdentifier")
    }
}
