//
//  FTTableViewTests.swift
//  FTMobileCoreTests
//
//  Created by Praveen P on 07/10/19.
//  Copyright © 2019 Praveen Prabhakar. All rights reserved.
//

@testable import MobileCoreExample
@testable import MobileCore
import XCTest

final class TestTableViewHeader: UIView {
    // Temp class extending Protocol for testing
}

final class DefaultTableViewController: UIViewController, FTTableViewControllerProtocol {
    // Temp class extending Protocol for testing
}

final class TestTableViewController: UIViewController, FTTableViewControllerProtocol {
    var tableStyle: UITableView.Style = .grouped
    var tableViewEdgeOffsets: FTEdgeOffsets = .init(40, 40, 40, 40)
}

class FTTableViewTests: XCTestCase {
    
    var tableViewC: TestTableViewController?
    var oldRootVC: UIViewController?
    override func setUp() {
        super.setUp()
        oldRootVC = UIApplication.keyWindow()?.rootViewController
        tableViewC = TestTableViewController()
        UIApplication.keyWindow()?.rootViewController = tableViewC
    }
    
    override func tearDown() {
        super.tearDown()
        UIApplication.keyWindow()?.rootViewController = oldRootVC
    }
    
    func testTableViewController() {
        XCTAssertNotNil(tableViewC)
        XCTAssertNotNil(tableViewC?.tableView)
        XCTAssertEqual(tableViewC?.tableViewController, tableViewC?.tableViewController)
        
        XCTAssertEqual(tableViewC?.tableStyle, UITableView.Style.grouped)
        XCTAssertEqual(tableViewC?.tableViewEdgeOffsets, FTEdgeOffsets(40, 40, 40, 40))
    }

    func testDefaultTableViewC() {
        let defaultTableV = DefaultTableViewController()
        XCTAssertNotNil(defaultTableV)
        XCTAssertEqual(defaultTableV.tableStyle, UITableView.Style.plain)
        XCTAssertEqual(defaultTableV.tableViewEdgeOffsets, FTEdgeOffsets.zero)
    }
    
    func testSsetupTableController() {
        let defaultTableV = DefaultTableViewController()
        XCTAssertNotNil(defaultTableV.tableViewController)
        
        let controller = defaultTableV.getCoreTableViewController()
        defaultTableV.tableViewController = controller
        XCTAssertEqual(defaultTableV.tableViewController, controller)
    }
    
    
    func testTableHeaderView() {
        let headerView = TestTableViewHeader()
        XCTAssertNotNil(headerView)
        tableViewC?.tableView.setTableHeaderView(view: headerView)
        
        let footerView = TestTableViewHeader()
        XCTAssertNotNil(footerView)
        tableViewC?.tableView.setTableFooterView(view: footerView)
        
        tableViewC?.postNotification(name: .kFTMobileCoreDidLayoutSubviews)
        
        let tableHeaderView = tableViewC?.tableView.tableHeaderView
        XCTAssertNotNil(tableHeaderView)
        //XCTAssertEqual(tableHeaderView?.embView, headerView)
        
        let tableFooterView = tableViewC?.tableView.tableFooterView
        XCTAssertNotNil(tableFooterView)
        //XCTAssertEqual(tableFooterView?.embView, footerView)
    }
    
     func testTableHeaderFooterView() {
        let defaultTableV = DefaultTableViewController()
        let headerView = UIView()
        
        defaultTableV.tableView.setTableHeaderView(view: headerView)
        
        let tableHeaderView = defaultTableV.tableView.tableHeaderView
        XCTAssertNotNil(tableHeaderView)
        //XCTAssertEqual(tableHeaderView?.embView, headerView)
    }
}
