//
//  FTPo.swift
//  NovelReader
//
//  Created by Praveen Prabhakar on 26/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

open class FTFontPickerViewController: UIViewController {
    
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
         // Setup MobileCore
        setupCoreView()
        if let pickerView = pickerView {
         self.mainView?.pin(view: pickerView)
        }
    }
    
    @discardableResult
    open func setUpPopoverPresentation(from sender: UIView?, delegate: UIPopoverPresentationControllerDelegate? = nil, contentSize: CGSize = CGSize(width: 250, height: 300)) -> UIPopoverPresentationController? {
        self.modalPresentationStyle = .popover
        self.preferredContentSize = contentSize
        
        let ppc = self.popoverPresentationController
        ppc?.permittedArrowDirections = .any
        ppc?.delegate = delegate ?? self

        if let sender = sender {
            ppc?.sourceView = sender
            ppc?.sourceRect = sender.bounds
        }
        
        return ppc
    }
}

extension FTFontPickerViewController: UIPopoverPresentationControllerDelegate {
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
