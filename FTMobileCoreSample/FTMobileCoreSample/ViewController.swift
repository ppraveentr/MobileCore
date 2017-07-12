//
//  ViewController.swift
//  FTMobileCoreSample
//
//  Created by Praveen Prabhakar on 15/06/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import UIKit

class ViewController: FTBaseViewController {
    
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        UIApplication.shared.setStatusBarHidden(true, with: UIStatusBarAnimation.none)

        self.baseView.backgroundColor = UIColor.clear
        
        let label = FTLabel()
        label.backgroundColor = .red
        label.text = "top"
        
        let labelM = FTLabel()
        labelM.backgroundColor = .yellow
        labelM.text = "Middled"
        
        let labelM1 = FTLabel()
        labelM1.backgroundColor = .blue
        labelM1.text = "Middle1"
        
        let labelM2 = FTLabel()
        labelM2.backgroundColor = .cyan
        labelM2.text = "Middle2"
        
        let labelM3 = FTLabel()
        labelM3.backgroundColor = .orange
        labelM3.text = "Middle3"

        
        let labelM4 = FTLabel()
        labelM4.backgroundColor = .magenta
        labelM4.text = "Middle4"

        
        let label2 = FTLabel()
        label2.backgroundColor = .green
        label2.text = "bottom"
        

        
        self.mainView?.pin(view: label, withEdgeOffsets: EdgeOffsets.init(30, 50, 0, 0), withEdgeInsets: [ .None ])

        self.mainView?.stackView(views: [label, labelM, labelM1, labelM2, labelM3, labelM4, label2], paddingBetween: 10, withEdgeInsets: [.AutoMargin])
        
        label.addSizeConstraint(100,100)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            label.removeFromSuperview()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            labelM2.removeFromSuperview()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
            labelM1.removeFromSuperview()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 11) {
            labelM4.removeFromSuperview()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 13) {
            labelM.removeFromSuperview()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let bundle = Bundle(identifier: "com.company.bundle.LiveUI")
    
        try? FTModelConfig.loadModelSchema(["MDASample": ["identifier":"id"] ])
        
        let sample = FTDataModel.createDataModelOfType("MDASample", fromDictionary: ["id":"sample"]) as? MDASample
        sample?.identifier = "jgj"
        
    
        
    }

}

