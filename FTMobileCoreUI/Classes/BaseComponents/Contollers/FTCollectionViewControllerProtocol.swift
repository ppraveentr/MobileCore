//
//  FTCollectionViewControllerProtocol.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 30/09/18.
//  Copyright © 2018 Praveen Prabhakar. All rights reserved.
//

import Foundation

private var kAOCollectionVC = "k.FT.AO.CollectionViewController"

public protocol FTCollectionViewControllerProtocol: FTBaseViewControllerProtocol {
    var flowLayout: NSObject { get }
    var collectionView: UICollectionView { get set }
    var collectionViewController: UICollectionViewController { get }
    // Cell config
    func estimatedItemSize() -> CGSize
    func sectionInset() -> UIEdgeInsets
}

public extension FTCollectionViewControllerProtocol {

    func estimatedItemSize() -> CGSize {
        return .zero
    }

    func sectionInset() -> UIEdgeInsets {
        return .zero
    }
    
    var flowLayout: NSObject {
        return UICollectionViewFlowLayout()
    }
    
    var collectionView: UICollectionView {
        get {
            return collectionViewController.collectionView
        }
        set {
            setupCoreCollectionView(newValue)
        }
    }
    
    var collectionViewController: UICollectionViewController {
        guard let collection = FTAssociatedObject<UICollectionViewController>.getAssociated(self, key: &kAOCollectionVC) else {
            return setupCoreCollectionVC()
        }
        return collection
    }
}

private extension FTCollectionViewControllerProtocol {
    
    var localFlowLayout: UICollectionViewLayout {
        let layout = flowLayout as? UICollectionViewLayout
        return layout ?? UICollectionViewLayout()
    }
    
    @discardableResult
    func setupCoreCollectionVC(_ collectionView: UICollectionView? = nil) -> UICollectionViewController {

        // Load Base view
        setupCoreView()
        
        if let collection = FTAssociatedObject<UICollectionViewController>.getAssociated(self, key: &kAOCollectionVC) {
            collection.collectionView.removeSubviews()
            FTAssociatedObject<Any>.resetAssociated(self, key: &kAOCollectionVC)
        }
        
        // Create tableView based on user provided style
        let local = UICollectionViewController(collectionViewLayout: localFlowLayout)
        local.collectionView.removeSubviews()
        local.collectionView.theme = FTThemeStyle.defaultStyle
        
        // had to set by initialzing controller
        local.collectionView.dataSource = nil
        local.collectionView.delegate = nil
        
        if let customCollection = collectionView {
            setupCoreCollectionView(customCollection, controller: local)
        }
        
        // Add as child view controller
        self.addChild(local)
        self.mainView?.pin(view: local.collectionView, edgeOffsets: .zero)
        
        FTAssociatedObject<UICollectionViewController>.setAssociated(self, value: local, key: &kAOCollectionVC)
        
        return local
    }
    
    func setupCoreCollectionView(_ localView: UICollectionView, controller: UICollectionViewController? = nil) {
        let collectionVC = controller ?? collectionViewController
        collectionVC.collectionView.removeSubviews()
        collectionVC.collectionView = localView
        
        // Add as child view controller
        self.mainView?.pin(view: localView, edgeOffsets: .zero)
    }
}
