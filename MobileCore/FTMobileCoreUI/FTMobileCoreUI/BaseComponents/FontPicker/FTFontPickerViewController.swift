//
//  FTPo.swift
//  NovelReader
//
//  Created by Praveen Prabhakar on 26/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

open class FTFontPickerViewController: FTBaseViewController {
    
    var pickerView = FTFontPickerView.fromNib() as? FTFontPickerView
    
    open var fontPickerViewDelegate: FTFontPickerViewprotocol? = nil {
        didSet {
            pickerView?.pickerDelegate = fontPickerViewDelegate
        }
    }

    open var fontPickerModel: FTFontPickerModel? {
        set {
            if let model = newValue {
                pickerView?.fontPickerModel = model
            }
        }
        get {
            return pickerView?.fontPickerModel
        }
    }

    override open func loadView() {
        super.loadView()
        
        if let pickerView = pickerView {
         self.mainView?.pin(view: pickerView)
        }
    }
    
}
