//  ViewController.swift
//  FTMobileCoreSample
//
//  Created by Praveen Prabhakar on 15/06/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var sampleView: FTContentView!
    @IBOutlet weak var topView: UIView!
    var button: UIButton = UIButton()
    
    override func loadView() {
        super.loadView()
         // Setup MobileCore
        setupCoreView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // FTContentView
        setupContentView()
        
        // MARK: TopView
        setUpTopView()
        
        // MARK: MainView
        setupMainView()
    }
    
    @objc
    func showFontPicker(sender: UIButton?) {
        let popoverContent = FTFontPickerViewController()
        popoverContent.fontPickerViewDelegate = self
        popoverContent.setUpPopoverPresentationController(sender)
        self.present(popoverContent, animated: true, completion: nil)
    }
}

extension ViewController: FTFontPickerViewprotocol {
    public func pickerColor(textColor: UIColor, backgroundColor: UIColor) {
        
    }
    
    public func fontSize(_ size: Float) {
        
    }
    
    public func fontFamily(_ fontName: String?) {
        
    }
}

extension ViewController {

    func setupContentView() {
        let value = """
        <p>1) Follow @ppraveentr or #visit <a href=\"www.W3Schools.com\">Visit W3Schools</a></p>
        <p>2) Follow @ppraveentr or #visit <a href=\"www.W3Schools.com\">Visit W3Schools</a></p>
        <p>3) Follow @ppraveentr or #visit <a href=\"www.W3Schools.com\">Visit W3Schools</a></p>
        <p>4) Follow @ppraveentr or #visit <a href=\"www.W3Schools.com\">Visit W3Schools</a></p>
        <p>5) Follow @ppraveentr or #visit <a href=\"www.W3Schools.com\">Visit W3Schools</a></p>
        """
        ftLog(value)
        //sampleView.webView.loadHTMLBody(value)
    }
    
    func setUpTopView() {
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
    }
    
    func setupMainView() {
        let scrollView = UIScrollView()
        topView.pin(view: scrollView, edgeInsets: [.topMargin, .horizontal])
        
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
}
