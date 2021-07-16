//
//  FontPickerTests.swift
//  MobileCoreTests
//
//  Created by Praveen P on 09/09/19.
//  Copyright © 2019 Praveen Prabhakar. All rights reserved.
//

@testable import CoreUtility
@testable import CoreUI
import UIKit
import XCTest

final class MockFontPickerViewProtocol: FontPickerViewProtocol {
    func pickerColor(textColor: UIColor, backgroundColor: UIColor) {
        XCTAssert(true)
    }
    
    func fontSize(_ size: Float) {
        XCTAssert(true)
    }
    
    func fontFamily(_ fontName: String?) {
        XCTAssert(true)
    }
}

final class FontPickerTests: XCTestCase {
    
    private let model = FontPickerModel()
    private lazy var pickerView: FontPickerView? = try? FontPickerView.loadNibFromBundle()

    var testPickerModel: FontPickerModel {
        let localModel = FontPickerModel()
        localModel.fontSize = 120.0
        localModel.fontColor = .red
        localModel.backgroundColor = .blue
        localModel.fontFamily = "Courier"
        return localModel
    }
    
    func assertPickerView(pickerView: FontPickerView?) {
        XCTAssertTrue(pickerView?.fontPickerModel.fontColor == UIColor.red)
        XCTAssertTrue(pickerView?.fontPickerModel.backgroundColor == UIColor.blue)
        XCTAssertTrue(pickerView?.fontPickerModel.fontSize == 120.0)
    }
    
    func testFontPickerModel() {
        XCTAssertTrue(model.fontColor == UIColor.black)
        XCTAssertTrue(model.backgroundColor == UIColor.white)
        XCTAssertTrue(model.fontSize == 140.0)
        
        XCTAssertEqual(model.fontSizeString, "140.0")
        // Increase size
        model.increaseSize()
        XCTAssertTrue(model.fontSize == 150.0)
        
        // decrease size
        model.decreaseSize()
        XCTAssertTrue(model.fontSize == 140.0)
    }
    
    func testFontPickerView() {
        // Picker model
        XCTAssertNotNil(pickerView?.fontPickerModel)
        let fontTypes = pickerView?.fontTypes
        XCTAssertNotNil(fontTypes)
        XCTAssertEqual(pickerView?.fontPickerModel.fontSizeString, "140.0")
        
        // Increase size
        XCTAssertNotNil(pickerView?.incrementFontButton)
        pickerView?.fontSizeChanged(pickerView?.incrementFontButton)
        XCTAssertTrue(pickerView?.fontPickerModel.fontSize == 150.0)
        XCTAssertEqual(pickerView?.fontPickerModel.fontSizeString, "150.0")
        
        // decrease size
        XCTAssertNotNil(pickerView?.decrementFontButton)
        pickerView?.fontSizeChanged(pickerView?.decrementFontButton)
        XCTAssertTrue(pickerView?.fontPickerModel.fontSize == 140.0)
        XCTAssertEqual(pickerView?.fontPickerModel.fontSizeString, "140.0")

        // Font
        XCTAssertNil(pickerView?.selectedFont)
        if let firstFont = fontTypes?.first {
            pickerView?.selectedFont = firstFont
            XCTAssertEqual(pickerView?.selectedFont, firstFont)
        }
        
        // Color
        XCTAssertNil(pickerView?.selectedColorButton)
        XCTAssertNotNil(pickerView?.whiteColorButton)
        if let button = pickerView?.whiteColorButton {
            pickerView?.fontColorSelected(button)
        }
        XCTAssertNotNil(pickerView?.selectedColorButton)
        XCTAssertEqual(pickerView?.selectedColorButton, pickerView?.whiteColorButton)
    }
    
    func testFontPickerTableView() {
        let fontTypes = pickerView?.fontTypes
        XCTAssertNotNil(pickerView?.fontTableView)
        let selectedIndexPath = IndexPath(row: 0, section: 2)
        let selectedFontType = fontTypes?[2]

        if let tableView = pickerView?.fontTableView {
            let noSection = pickerView?.numberOfSections(in: tableView)
            XCTAssertEqual(noSection, fontTypes?.count)

            // Font Selection
            pickerView?.tableView(tableView, didSelectRowAt: selectedIndexPath)
            XCTAssertEqual(pickerView?.selectedFont, selectedFontType)
            
            // Cell
            // Font Selection
            let cell = pickerView?.tableView(tableView, cellForRowAt: selectedIndexPath)
            XCTAssertNotNil(cell)
            XCTAssertEqual(cell?.accessoryType, UITableViewCell.AccessoryType.checkmark)
            XCTAssertEqual(cell?.textLabel?.text, selectedFontType)
            
            // Font de-Selection
            pickerView?.tableView(tableView, didSelectRowAt: selectedIndexPath)
            XCTAssertNil(pickerView?.selectedFont)
            
            // Font Selection - revalidation
            let reloadedCell = pickerView?.tableView(tableView, cellForRowAt: selectedIndexPath)
            XCTAssertNotNil(reloadedCell)
            XCTAssertEqual(reloadedCell?.accessoryType, UITableViewCell.AccessoryType.none)
        }
    }
    
    func testFontPickerViewUpdateModel() {
        let localPickerView: FontPickerView? = try? FontPickerView.loadNibFromBundle()
        localPickerView?.fontPickerModel = testPickerModel
        assertPickerView(pickerView: localPickerView)
    }
    
    func testFontPickerViewController() {
        let pickerVC = FontPickerViewController()
        XCTAssertNotNil(pickerVC.pickerView)
        XCTAssertNotNil(pickerVC.fontPickerModel)
        
        // Picker Delegate
        pickerVC.fontPickerViewDelegate = MockFontPickerViewProtocol()
        XCTAssertNotNil(pickerVC.pickerView?.pickerDelegate)

        // PickerView Model
        let localModel = testPickerModel
        pickerVC.fontPickerModel = localModel
        assertPickerView(pickerView: pickerVC.pickerView)
        
        // loadView
        pickerVC.loadView()
        let subView: FontPickerView? = pickerVC.mainView?.findInSubView()
        XCTAssertNotNil(subView)
    }
}
