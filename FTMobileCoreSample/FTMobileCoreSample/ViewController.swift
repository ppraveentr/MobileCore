
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: TopView
        let button = FTButton()
        button.theme = "button14R"
        button.setTitle("Tap me", for: .normal)
        //        button.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 10, 5)
        //        button.setImage(UIImage(named: "Pp"), for: .normal)
        
        let buttonD = FTButton()
        buttonD.theme = "button14R"
        buttonD.setTitle("Disabled", for: .normal)
        buttonD.isEnabled = false
        
        let topView = FTView()
        topView.pin(view: button, withEdgeOffsets: FTEdgeOffsets(20, 20, 20, 20), withEdgeInsets: [ .Left, .Vertical ])
        topView.stackView(views: [button, buttonD],
                          layoutDirection: .LeftToRight,
                          spacing: 10,
                          edgeInsets: [ .CenterYMargin, .EqualSize ])
        
        self.baseView?.topPinnedView = topView
        
        
        //MARK: MainView
        
        let scrollView = FTScrollView()
        self.mainView?.pin(view: scrollView, withEdgeInsets: [.TopMargin, .Horizontal])

        let label = FTLabel()
        label.text = "top"
        label.theme = "system14AA"
        
        let labelM = FTLabel()
        labelM.text = "Middledasd s asd "
        labelM.theme = "system14R"
        
        let labelM1 = FTLabel()
        labelM1.text = "Middle1 ad dfadf af ad"
        labelM1.theme = "system14B"
        
        let labelM2 = FTLabel()
        labelM2.text = "Middle2 ad"
        labelM2.theme = "system14G"
        
        let bottomL = FTLabel()
        bottomL.text = "bottom"
        bottomL.theme = "system14Y"
        
        scrollView.contentView.pin(view: label, withEdgeOffsets: FTEdgeOffsets(20, 20, 20, 20), withEdgeInsets: [ .Left, .Vertical ])
        
        scrollView.contentView.stackView(views: [label, labelM, labelM1, labelM2, bottomL],
                                         layoutDirection: .LeftToRight, spacing: 20,
                                         edgeInsets: [.Vertical, .AutoSize, .TopMargin])

        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            label.removeFromSuperview()
//        }
        
        //MARK: TODO: Service
                
        try? FTModelConfig.loadModelSchema(["MDASample": ["identifier":"id"] ])
        
        let sample = try? MDASample.init(dictionary: ["id":"sample", "amount":["usd":23.3]])
//        sample?.amount = 32.2
        
        print(sample?.toJSONString() ?? "")
        print(sample?.toDictionary() ?? "")
        
//        let sample = FTDataModel.dataModelOfType("MDASample", withJSON: ["id":"sample"]) as? MDASample
//        sample?.amount = 32.2
//        print(sample ?? "properties of type MDASample are empty");
    }
}
 
