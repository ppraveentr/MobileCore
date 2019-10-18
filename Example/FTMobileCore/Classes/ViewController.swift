//  ViewController.swift
//  FTMobileCoreSample
//
//  Created by Praveen Prabhakar on 15/06/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var sampleView: FTView!
    
    override func loadView() {
        super.loadView()
         // Setup MobileCore
        setupCoreView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: TopView
        let button = UIButton()
        button.theme = "button14R"
        button.setTitle("Tap me", for: .normal)
        //        button.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 10, 5)
        //        button.setImage(UIImage(named: "Pp"), for: .normal)
        
        let buttonD = UIButton()
        buttonD.theme = "button14R"
        buttonD.setTitle("Disabled", for: .normal)
        buttonD.isEnabled = false
        
        let buttonPopOver = UIButton()
        buttonPopOver.theme = "button14R"
        buttonPopOver.setTitle("PopOver", for: .normal)
        buttonPopOver.addTarget(self, action: #selector(showFontPicker), for: .touchUpInside)
        
        let topView = FTView()
        topView.pin(view: button, edgeOffsets: FTEdgeOffsets(20), edgeInsets: [ .left, .vertical ])
        topView.pin(view: buttonPopOver, edgeOffsets: FTEdgeOffsets(20), edgeInsets: [ .right ])
        topView.stackView(
            views: [button, buttonD, buttonPopOver],
            layoutDirection: .leftToRight,
            spacing: 20,
            edgeInsets: [ .topMargin, .equalSize ]
        )
        
        self.baseView?.topPinnedView = topView
        
        // MARK: MainView
        let scrollView = UIScrollView()
        self.mainView?.pin(view: scrollView, edgeInsets: [.topMargin, .horizontal])

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
        
        scrollView.contentView.pin(view: label, edgeOffsets: FTEdgeOffsets(20), edgeInsets: [ .left, .vertical ])
        scrollView.contentView.pin(view: bottomL, edgeOffsets: FTEdgeOffsets(20), edgeInsets: [ .right ])

        scrollView.contentView.stackView(
            views: [label, labelM, labelM1, labelM2, bottomL],
            layoutDirection: .leftToRight,
            spacing: 20,
            edgeInsets: [.autoSize, .topMargin]
        )

//        scrollView.contentView.pin(view: label, withEdgeOffsets: FTEdgeOffsets(20), withEdgeInsets: [ .Top, .Horizontal ])
//        scrollView.contentView.pin(view: bottomL, withEdgeOffsets: FTEdgeOffsets(20), withEdgeInsets: [ .Bottom ])
//        
//        scrollView.contentView.stackView(views: [label, labelM, labelM1, labelM2, bottomL],
//                                         layoutDirection: .TopToBottom, spacing: 20,
//                                         edgeInsets: [.EqualSize, .LeadingMargin])
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            label.removeFromSuperview()
//        }
    }
    
    @objc
    func showFontPicker(sender: UIButton?) {
        let popoverContent = FTFontPickerViewController()
        popoverContent.modalPresentationStyle = .popover
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = .popover
        if let popover = nav.presentationController as? UIPopoverPresentationController, let sender = sender {
            popover.sourceView = sender
            popover.sourceRect = sender.bounds
        }
        self.present(nav, animated: true, completion: nil)
    }
}
