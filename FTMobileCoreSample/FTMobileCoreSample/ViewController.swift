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
                
        self.baseView.backgroundColor = UIColor.clear
        
        let scrollView = FTScrollView()
        self.mainView?.pin(view: scrollView)
        
        let restyledString: NSMutableAttributedString = NSAttributedString(string: "top").mutableCopy() as! NSMutableAttributedString
        restyledString.addAttribute(NSParagraphStyleAttributeName, value: NSMutableParagraphStyle(), range: NSMakeRange(0, restyledString.length))

        let label = FTLabel()
        label.backgroundColor = .red
        label.attributedText = restyledString
        label.Themes = "label"

        let labelM = FTLabel()
        labelM.backgroundColor = .yellow
        labelM.text = "Middledasd s asd "
        labelM.Themes = "labelM"
        
        let labelM1 = FTLabel()
        labelM1.backgroundColor = .blue
        labelM1.text = "Middle1 ad dfadf af ad"
        
        let labelM2 = FTLabel()
        labelM2.backgroundColor = .cyan
        labelM2.text = "Middle2 ad"
        
        let labelM3 = FTLabel()
        labelM3.backgroundColor = .orange
        labelM3.text = "Middle3 df wdfw dfwd"

        
        let labelM4 = FTLabel()
        labelM4.backgroundColor = .magenta
        labelM4.text = "Middle4 dwds"

        
        let label2 = FTLabel()
        label2.backgroundColor = .green
        label2.text = "bottom"
        
        scrollView.contentView.pin(view: label, withEdgeOffsets: FTEdgeOffsets(30, 50, 0, 0), withEdgeInsets: [ .Left, .Top ])

        label.addSizeConstraint(200,200)

        scrollView.contentView.stackView(views: [label, labelM, labelM1, labelM2, labelM3, labelM4, label2],
                                         withLayoutDirection: .LeftToRight, paddingBetween: 25,
                                         withEdgeInsets: [ .EqualSize, .TopMargin, .AutoMargin])

        let left = FTLabel()
        left.backgroundColor = .magenta
        left.text = "left dwds"
        scrollView.contentView.stackView(views: [labelM,left], withLayoutDirection: .TopToBottom, paddingBetween: 10,
                                         withEdgeInsets: [.LeadingMargin])
        
        scrollView.contentView.pin(view: left, withEdgeOffsets: FTEdgeOffsets(30, 50, 0, 0),
                                   withEdgeInsets: [ .Left, .Bottom, .AutoSize ],
                                   withLayoutPriority: UILayoutPriorityDefaultLow)

//        label.addSizeConstraint(100,100)
//        labelM.addSizeConstraint(20,20)
//        labelM1.addSizeConstraint(10,30)
//        labelM4.addSizeConstraint(50,40)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            label.removeFromSuperview()
        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
//            labelM2.removeFromSuperview()
//        }
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
//            labelM1.removeFromSuperview()
//        }
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 11) {
//            labelM4.removeFromSuperview()
//        }
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 13) {
//            labelM.removeFromSuperview()
//        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        try? FTModelConfig.loadModelSchema(["MDASample": ["identifier":"id"] ])
        
        let sample = FTDataModel.createDataModelOfType("MDASample", fromDictionary: ["id":"sample"]) as? MDASample
//        sample?.identifier = "jgj"
        print(sample ?? "properties of type MDASample are empty");
    }
}
