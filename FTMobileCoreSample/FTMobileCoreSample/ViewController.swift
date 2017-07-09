//
//  ViewController.swift
//  FTMobileCoreSample
//
//  Created by Praveen Prabhakar on 15/06/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import UIKit

class ViewController: FTBaseViewController {

    override func viewWillAppear(_ animated: Bool) {
    
        let label = FTLabel()
        label.backgroundColor = .red
        label.text = "top"
        
        
        let label2 = FTLabel()
        label2.backgroundColor = .green
        label2.text = "bottom"
        
        self.mainView.mainPinnedView.stackView(views: [label, label2], paddingBetween: 10, withEdgeOffsets: EdgeOffsets.init(0, 10, 0, 10), withEdgeInsets: .AutoMargin)
        
//        self.view.pin(view: label, withEdgeOffsets: EdgeOffsets.init(30, 50, 0, 0), withEdgeInsets: [.Left, .Top])
        
//        self.view.stackView(views: [label, label2], paddingBetween: 15, withEdgeOffsets: EdgeOffsets.init(30, 50, 0, 10), withEdgeInsets: [.AutoMargin, .LeadingMargin])

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let bundle = Bundle(identifier: "com.company.bundle.LiveUI")
    
        try? FTModelConfig.loadModelSchema(["MDASample": ["identifier":"id"] ])
        
        let sample = FTDataModel.createDataModelOfType("MDASample", fromDictionary: ["id":"sample"]) as? MDASample
        sample?.identifier = "jgj"
        
    
        
    }

}

