//
//  FTConstrainsTests.swift
//  FTMobileCoreUITests
//
//  Created by Praveen Prabhakar on 13/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import XCTest
@testable import FTMobileCoreUI

class FTConstrainsTests: XCTestCase {
    var mainView: UIView = UIView()
    var viewsArray = [UIView]()
    
    override func setUp() {
        super.setUp()
        
        let label = FTLabel()
        label.backgroundColor = .red
        label.text = "top"
        viewsArray.append(label)
        
        let labelM = FTLabel()
        labelM.backgroundColor = .yellow
        labelM.text = "Middled"
        viewsArray.append(labelM)
        
        let labelM1 = FTLabel()
        labelM1.backgroundColor = .blue
        labelM1.text = "Middle1"
        viewsArray.append(labelM1)
        
        let labelM2 = FTLabel()
        labelM2.backgroundColor = .cyan
        labelM2.text = "Middle2"
        viewsArray.append(labelM2)
        
        let labelM3 = FTLabel()
        labelM3.backgroundColor = .orange
        labelM3.text = "Middle3"
        viewsArray.append(labelM3)
        
        let labelM4 = FTLabel()
        labelM4.backgroundColor = .magenta
        labelM4.text = "Middle4"
        viewsArray.append(labelM4)
        
        let label2 = FTLabel()
        label2.backgroundColor = .green
        label2.text = "bottom"
        viewsArray.append(label2)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            self.mainView.stackView(views: self.viewsArray, paddingBetween: 10, withEdgeInsets:
                [.AutoMargin, .EqualSize, .AutoSize, .LeadingMargin, .TrailingMargin])
        }
    }
    
}
