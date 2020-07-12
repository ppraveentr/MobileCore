//
//  ConfigurableCellTests.swift
//  CoreUtilityTests
//
//  Created by Praveen Prabhakar on 05/07/20.
//  Copyright © 2020 Praveen Prabhakar. All rights reserved.
//

@testable import MobileCore
import XCTest

fileprivate final class DummyTableViewCell: UITableViewCell {
    // Mock: object implementation for testing
}

final class ConfigurableCellTests: XCTestCase {
    //private lazy var mockCell: MockTableViewCell?
    private let mockTableView = UITableView()
    
    func testDefaultNib() {
        XCTAssertEqual(MockTableViewCell.defaultNibName, "MockTableViewCell")
        XCTAssertEqual(MockTableViewCell.defaultReuseIdentifier, "MockTableViewCellID")
    }
    
    func testLoadFromDefaultNib() {
        // let
        do {
            let nib = try MockTableViewCell.loadFromDefaultNib()
            XCTAssertNotNil(nib)
        }
        catch {
            XCTAssertNil(error)
        }
    }
    
    func testRegisterCellDefaultReuseID() {
        //let
        let indexPath = IndexPath(row: 0, section: 0)
        // when
        MockTableViewCell.registerClass(for: mockTableView)
        let cell: MockTableViewCell? = try? MockTableViewCell.dequeue(from: mockTableView, for: indexPath)
        // then
        XCTAssertNotNil(cell)
        XCTAssertNotNil(mockTableView.dequeueReusableCell(withIdentifier: MockTableViewCell.defaultReuseIdentifier))
    }
    
    func testRegisterCellCustomReuseID() {
        let customReuseID = "reuseID"
        MockTableViewCell.registerClass(for: mockTableView, reuseIdentifier: customReuseID)
        XCTAssertNil(mockTableView.dequeueReusableCell(withIdentifier: MockTableViewCell.defaultReuseIdentifier))
        XCTAssertNotNil(mockTableView.dequeueReusableCell(withIdentifier: customReuseID))
    }
    
    func testRegisterCellFails() {
        //let
        let indexPath = IndexPath(row: 0, section: 0)
        // when
        do {
            let cell: MockTableViewCell = try MockTableViewCell.dequeue(from: mockTableView, for: indexPath)
            // then
            XCTAssertNil(cell)
        }
        catch {
            XCTAssertNotNil(error)
        }
    }
}
