//
//  ContentViewController.swift
//  FTMobileCore
//
//  Created by Praveen P on 01/11/19.
//  Copyright © 2019 Praveen Prabhakar. All rights reserved.
//

import Foundation

final class ContentViewController: UIViewController, WebViewControllerProtocol {
    
    let value = """
        <p>1) Follow @ppraveentr or #visit <a href=\"www.W3Schools.com\">Visit W3Schools</a></p>
        <p>2) Follow @ppraveentr or #visit <a href=\"www.W3Schools.com\">Visit W3Schools</a></p>
        <p>3) Follow @ppraveentr or #visit <a href=\"www.W3Schools.com\">Visit W3Schools</a></p>
        <p>4) Follow @ppraveentr or #visit <a href=\"www.W3Schools.com\">Visit W3Schools</a></p>
        <p>5) Follow @ppraveentr or #visit <a href=\"www.W3Schools.com\">Visit W3Schools</a></p>
        """
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup MobileCore
        setupCoreView()
        // Load HTLM
        contentView.loadHTMLBody(value)
    }
}
