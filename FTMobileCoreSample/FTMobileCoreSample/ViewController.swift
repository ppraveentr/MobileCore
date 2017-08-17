
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
        
        self.baseView.theme = "default"
        
        let scrollView = FTScrollView()
        self.mainView?.pin(view: scrollView)
        
        let restyledString: NSMutableAttributedString = NSAttributedString(string: "top").mutableCopy() as! NSMutableAttributedString
        restyledString.addAttribute(NSParagraphStyleAttributeName, value: NSMutableParagraphStyle(), range: NSMakeRange(0, restyledString.length))

        let label = FTLabel()
        label.attributedText = restyledString
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
        
        scrollView.contentView.pin(view: label, withEdgeOffsets: FTEdgeOffsets(30, 50, 0, 0), withEdgeInsets: [ .Left, .Top ])

//        label.addSizeConstraint(200,200)
//        labelM.addSizeConstraint(20,20)
//        labelM1.addSizeConstraint(10,30)
//        labelM2.addSizeConstraint(100,100)
//        bottomL.addSizeConstraint(50,40)
        
        scrollView.contentView.stackView(views: [label, labelM, labelM1, labelM2, bottomL],
                                         withLayoutDirection: .LeftToRight, paddingBetween: 25,
                                         withEdgeInsets: [.TopMargin, .AutoMargin])

        let left = FTLabel()
        left.backgroundColor = .magenta
        left.text = "left dwds"
        scrollView.contentView.stackView(views: [labelM,left], withLayoutDirection: .TopToBottom, paddingBetween: 10,
                                         withEdgeInsets: [.LeadingMargin])
        
        scrollView.contentView.pin(view: left, withEdgeOffsets: FTEdgeOffsets(30, 50, 0, 0),
                                   withEdgeInsets: [ .Left, .Bottom, .AutoSize ],
                                   withLayoutPriority: UILayoutPriorityDefaultLow)

        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            label.removeFromSuperview()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
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
 
