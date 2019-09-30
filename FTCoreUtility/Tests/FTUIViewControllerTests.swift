//
//  FTUIViewControllerTests.swift
//  MobileCoreTests
//
//  Created by Praveen P on 09/09/19.
//  Copyright © 2019 Praveen Prabhakar. All rights reserved.
//

@testable import FTMobileCoreSample
import XCTest

class FTUIViewControllerTests: XCTestCase {
    
    var oldRootVC: UIViewController?
    override func setUp() {
        super.setUp()
        oldRootVC = UIApplication.shared.keyWindow?.rootViewController
    }
    
    override func tearDown() {
        super.tearDown()
        UIApplication.shared.keyWindow?.rootViewController = oldRootVC
    }
    
    func testPresentedCurrentVC() {
        // vc --prensent-> VC
        let viewC = UIViewController()
        UIApplication.shared.keyWindow?.rootViewController = viewC

        let presentVC = UIViewController()
        viewC.present(presentVC, animated: false, completion: nil)
        
        let topVC = viewC.currentViewController
        XCTAssertNotNil(topVC)
        XCTAssertEqual(topVC, presentVC)
    }
    
    func testPushedNavCurrentVC() {
        // vc --present-> nav --push-2VC-in-nav--> VC
        let vc = UIViewController()
        UIApplication.shared.keyWindow?.rootViewController = vc
        
        let navVC = UINavigationController()
        vc.present(navVC, animated: false, completion: nil)
        
        navVC.pushViewController(UIViewController(), animated: false)
        let pushVC = UIViewController()
        navVC.pushViewController(pushVC, animated: false)
        
        let topVC = navVC.currentViewController
        XCTAssertNotNil(topVC)
        XCTAssertEqual(topVC, pushVC)
    }
    
    func testPressentedNavCurrentVC() {
        // nav --push-> VC --nav-prensent-> VC
        let navVC = UINavigationController()
        UIApplication.shared.keyWindow?.rootViewController = navVC
        
        let pushVC = UIViewController()
        navVC.pushViewController(pushVC, animated: false)
        let presentVC = UIViewController()
        navVC.present(presentVC, animated: false, completion: nil)
        
        let topVC = navVC.currentViewController
        XCTAssertNotNil(topVC)
        XCTAssertEqual(topVC, presentVC)
    }
    
    func testPushedTwiceNavCurrentVC() {
        // nav --push-> VC --nav-push-> VC
        let navVC = UINavigationController()
        UIApplication.shared.keyWindow?.rootViewController = navVC
        
        navVC.pushViewController(UIViewController(), animated: false)
        let pushVC = UIViewController()
        navVC.pushViewController(pushVC, animated: false)
        
        let topVC = navVC.currentViewController
        XCTAssertNotNil(topVC)
        XCTAssertEqual(topVC, pushVC)
    }
    
    func testEmptyCurrentVC() {
        UIApplication.shared.keyWindow?.rootViewController = nil
        XCTAssertNil(UIViewController().currentViewController)
    }
}
