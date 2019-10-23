//  ViewController.swift
//  FTMobileCoreSample
//
//  Created by Praveen Prabhakar on 15/06/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var sampleView: UIView!
    
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
        
        let topView = UIView()
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

        let label = UILabel()
        label.text = "<p>Follow @ppraveentr or #visit <a href=\"www.W3Schools.com\">Visit W3Schools</a></p>"
        label.theme = "system14G"
        label.linkHandler = { link in
            print("Detect Link: ", link.linkURL)
        }
        
        button.addTapActionBlock {
            label.text = "<p>Follow @ppraveentr or #visit <a href=\"www.W3Schools.com\">Visit W3Schools</a></p>"
        }
       
        
        let labelM = UILabel()
        labelM.text = "Middledasd s asd "
        labelM.theme = "system14R"
        
        let labelM1 = UILabel()
        labelM1.text = "Middle1 ad dfadf af ad"
        labelM1.theme = "system14B"
        
        let labelM2 = UILabel()
        labelM2.text = "Middle2 ad"
        labelM2.theme = "system14AA"
        
        let bottomL = UILabel()
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
        popoverContent.preferredContentSize = CGSize(width: 250, height: 250)
        popoverContent.modalPresentationStyle = .popover
        
        let ppc = popoverContent.popoverPresentationController
        ppc?.permittedArrowDirections = .any
        ppc?.sourceView = sender
        ppc?.delegate = self
        if let bounds = sender?.bounds {
            ppc?.sourceRect = bounds
        }
        
        self.present(popoverContent, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(
            x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
            y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y
        )
        let locationOfTouchInTextContainer = CGPoint(
            x: locationOfTouchInLabel.x - textContainerOffset.x,
            y: locationOfTouchInLabel.y - textContainerOffset.y
        )
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
}
