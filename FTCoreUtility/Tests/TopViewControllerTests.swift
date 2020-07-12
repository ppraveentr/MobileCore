//
//  TopViewControllerTests.swift
//  CoreUtilityTests
//
//  Created by Praveen P on 09/09/19.
//  Copyright © 2019 Praveen Prabhakar. All rights reserved.
//

@testable import MobileCore
import XCTest

final class TopViewControllerTests: XCTestCase {
    
    private var oldRootVC: UIViewController?
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
    
    func testTabBarCurrentVC() {
        let tabVC = UITabBarController()
        UIApplication.shared.keyWindow?.rootViewController = tabVC
        
        let viewC1 = UIViewController()
        let viewC2 = UIViewController()
        tabVC.setViewControllers([viewC1, viewC2], animated: false)
        tabVC.selectedIndex = 2
                
        let topVC = tabVC.currentViewController
        XCTAssertNotNil(topVC)
        let selectedVC = tabVC.selectedViewController
        XCTAssertNotNil(selectedVC)
        XCTAssertEqual(topVC, selectedVC)
    }
    
    func testChildCurrentVC() {
        // vc --prensent-> VC
        let viewC = UIViewController()
        UIApplication.shared.keyWindow?.rootViewController = viewC
        
        // not pinned
        let childVC1 = UIViewController()
        viewC.addChild(childVC1)
        // pinned view
        let childVC2 = UIViewController()
        viewC.addChild(childVC2)
        viewC.view.pin(view: childVC2.view)
        
        let topVC = viewC.currentViewController
        XCTAssertNotNil(topVC)
        XCTAssertEqual(topVC, childVC2)
    }
    
    func testEmptyCurrentVC() {
        let dummyViewContorller = UIViewController()
        UIApplication.shared.keyWindow?.rootViewController = nil
        let topVC = dummyViewContorller.currentViewController
        XCTAssertNotNil(dummyViewContorller.currentViewController)
        XCTAssertEqual(topVC, dummyViewContorller)
    }
}
