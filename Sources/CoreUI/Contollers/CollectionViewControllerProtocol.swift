//
//  CollectionViewControllerProtocol.swift
//  CoreUIExtensions
//
//  Created by Praveen Prabhakar on 30/09/18.
//  Copyright © 2018 Praveen Prabhakar. All rights reserved.
//

import CoreUtility
import Foundation
import UIKit

private var kAOCollectionVC = "k.FT.AO.CollectionViewController"

public protocol CollectionViewControllerProtocol: ViewControllerProtocol {
    var flowLayout: UICollectionViewLayout { get }
    var collectionView: UICollectionView { get set }
    var collectionViewController: UICollectionViewController { get }
    // Cell config
    func estimatedItemSize() -> CGSize
    func sectionInset() -> UIEdgeInsets
}

public extension CollectionViewControllerProtocol {

    func estimatedItemSize() -> CGSize {
        .zero
    }

    func sectionInset() -> UIEdgeInsets {
        .zero
    }
    
    var flowLayout: UICollectionViewLayout {
        UICollectionViewLayout()
    }
    
    var collectionView: UICollectionView {
        get {
            collectionViewController.collectionView
        }
        set {
            setupCoreCollectionView(newValue)
        }
    }
    
    var collectionViewController: UICollectionViewController {
        guard let collection = AssociatedObject<UICollectionViewController>.getAssociated(self, key: &kAOCollectionVC) else {
            return setupCoreCollectionVC()
        }
        return collection
    }
}

private extension CollectionViewControllerProtocol {
    
    @discardableResult
    func setupCoreCollectionVC(_ collectionView: UICollectionView? = nil) -> UICollectionViewController {

        // Load Base view
        setupCoreView()
        
        // Create tableView based on user provided style
        let collectionVC = UICollectionViewController(collectionViewLayout: flowLayout)
        // had to reset vc's collectionView
        collectionVC.collectionView.removeSubviews()
        collectionVC.collectionView.dataSource = nil
        collectionVC.collectionView.delegate = nil
        // has user provided collectionView, add it to collectionVC
        if let collectionView = collectionView {
            setupCoreCollectionView(collectionView, controller: collectionVC)
        }
        
        // Add as child view controller
        self.addChild(collectionVC)
        self.mainView?.pin(view: collectionVC.collectionView, edgeOffsets: .zero)
        
        AssociatedObject<UICollectionViewController>.setAssociated(self, value: collectionVC, key: &kAOCollectionVC)
        
        return collectionVC
    }
    
    func setupCoreCollectionView(_ localView: UICollectionView, controller: UICollectionViewController? = nil) {
        let collectionVC = controller ?? collectionViewController
        collectionVC.collectionView.removeSubviews()
        collectionVC.collectionView = localView
        
        // Add as child view controller
        self.mainView?.pin(view: localView, edgeOffsets: .zero)
    }
}
