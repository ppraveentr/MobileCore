//
//  ViewController.swift
//  FTMobileCoreSample
//
//  Created by Praveen Prabhakar on 15/06/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import UIKit

class ViewController: FTBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        let bundle = Bundle(identifier: "com.company.bundle.LiveUI")
    
        try? FTModelConfig.loadModelSchema(["MDASample": ["identifier":"id"] ])
        
        let sample = FTDataModel.createDataModelOfType("MDASample", fromDictionary: ["id":"sample"]) as? MDASample
        sample?.identifier = "jgj"
        
    }

}

