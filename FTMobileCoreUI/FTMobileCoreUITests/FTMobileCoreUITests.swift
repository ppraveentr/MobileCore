//
//  FTMobileCoreUITests.swift
//  FTMobileCoreUITests
//
//  Created by Praveen Prabhakar on 13/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import XCTest
@testable import FTMobileCoreUI

class FTMobileCoreUITests: XCTestCase {
    
    var mainView: UIView? = UIView()
    var viewsArray = [UIView]()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
//        let label = FTLabel()
//        label.backgroundColor = .red
//        label.text = "top"
//        viewsArray?.append(label)
//        
//        let labelM = FTLabel()
//        labelM.backgroundColor = .yellow
//        labelM.text = "Middled"
//        viewsArray?.append(labelM)
//        
//        let labelM1 = FTLabel()
//        labelM1.backgroundColor = .blue
//        labelM1.text = "Middle1"
//        viewsArray?.append(labelM1)
//        
//        let labelM2 = FTLabel()
//        labelM2.backgroundColor = .cyan
//        labelM2.text = "Middle2"
//        viewsArray?.append(labelM2)
//        
//        let labelM3 = FTLabel()
//        labelM3.backgroundColor = .orange
//        labelM3.text = "Middle3"
//        viewsArray?.append(labelM3)
//        
//        let labelM4 = FTLabel()
//        labelM4.backgroundColor = .magenta
//        labelM4.text = "Middle4"
//        viewsArray?.append(labelM4)
//        
//        let label2 = FTLabel()
//        label2.backgroundColor = .green
//        label2.text = "bottom"
//        viewsArray?.append(label2)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
//        self.mainView?.pin(view: label, withEdgeOffsets: FTEdgeOffsets.init(30, 50, 0, 0), withEdgeInsets: [ .None ])
        
//        self.mainView?.stackView(views: [label, labelM, labelM1, labelM2, labelM3, labelM4, label2], paddingBetween: 10, withEdgeInsets: [.AutoMargin, .EqualSize])
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
//            self.mainView?.stackView(views: [label, labelM, labelM1, labelM2, labelM3, labelM4, label2], paddingBetween: 10, withEdgeInsets: [.AutoMargin, .EqualSize])
        }
    }
    
}
