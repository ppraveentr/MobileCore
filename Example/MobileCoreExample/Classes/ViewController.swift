//  ViewController.swift
//  MobileCoreSample
//
//  Created by Praveen Prabhakar on 15/06/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    @IBOutlet weak var topView: UIView!
    weak var contentViewC: ContentViewController?
    var button = UIButton()
    let buttonText = "<p>Follow @ppraveentr or #visit <a href=\"www.W3Schools.com\">Visit W3Schools</a></p>"
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup MobileCore
        setupCoreView()
        
        // TopView
        setUpTopView()
        
        // MainView
        setupMainView()
    }
    
    @objc
    func showFontPicker(sender: UIButton?) {
        if let htmlView = contentViewC?.contentView {
            let popoverContent = htmlView.fontPickerViewController
            popoverContent.setUpPopoverPresentation(from: sender)
            self.present(popoverContent, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "contentViewC" {
            contentViewC = segue.destination as? ContentViewController
        }
    }
}

extension ViewController {
    
    func setUpTopView() {
        button.theme = "button14R"
        button.setTitle("Tap me", for: .normal)
        
        // Button Ation, with alertView
        button.addTapActionBlock { [weak self] in
            self?.showAlert(title: "Button Tapped", message: "")
        }
        
        let buttonD = UIButton()
        buttonD.theme = "button14R"
        buttonD.setTitle("Disabled", for: .normal)
        buttonD.isEnabled = false
        
        let buttonPopOver = UIButton()
        buttonPopOver.theme = "button14R"
        buttonPopOver.setTitle("Font Picker", for: .normal)
        buttonPopOver.addTarget(self, action: #selector(showFontPicker), for: .touchUpInside)
        
        let topView = UIView()
        topView.pin(view: button, edgeOffsets: UIEdgeInsets(20), edgeInsets: [ .left, .vertical ])
        topView.pin(view: buttonPopOver, edgeOffsets: UIEdgeInsets(20), edgeInsets: [ .right ])
        topView.stackView(
            views: [button, buttonD, buttonPopOver],
            layoutDirection: .leftToRight,
            spacing: 20,
            edgeInsets: [ .topMargin, .equalSize ]
        )
        
        self.baseView?.topPinnedView = topView
    }
    
    func setupMainView() {
        let scrollView = UIScrollView()
        topView.pin(view: scrollView, edgeInsets: [.topMargin, .horizontal])
        
        let label = UILabel()
        label.text = buttonText
        label.theme = "system14G"
        label.linkHandler = { link in
            print("Detect Link: ", link.linkURL)
        }
        
        let labelM = UILabel()
        labelM.text = "Middle Label"
        labelM.theme = "system14R"
        
        let labelM1 = UILabel()
        labelM1.text = "Label with Large text"
        labelM1.theme = "system14B"
        
        let labelM2 = UILabel()
        labelM2.text = "Label with Extra Extra Extra Large text"
        labelM2.theme = "system14AA"
        
        let bottomL = UILabel()
        bottomL.text = "last Label"
        bottomL.theme = "system14Y"
        
        // [ .Top, .Horizontal ]
        scrollView.contentView.pin(view: label, edgeOffsets: UIEdgeInsets(20), edgeInsets: [ .left, .vertical ])
        // [ .Bottom ]
        scrollView.contentView.pin(view: bottomL, edgeOffsets: UIEdgeInsets(20), edgeInsets: [ .right ])
        
        // layoutDirection: .TopToBottom, edgeInsets: [.EqualSize, .LeadingMargin]
        scrollView.contentView.stackView(
            views: [label, labelM, labelM1, labelM2, bottomL],
            layoutDirection: .leftToRight,
            spacing: 20,
            edgeInsets: [.autoSize, .topMargin]
        )
    }
}
