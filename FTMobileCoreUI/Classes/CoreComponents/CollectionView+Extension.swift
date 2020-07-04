//
//  CollectionView+Extension.swift
//  CoreUIExtensions
//
//  Created by Praveen Prabhakar on 30/09/18.
//  Copyright © 2018 Praveen Prabhakar. All rights reserved.
//

import Foundation

extension UICollectionView {

    private static let aoCollectionView = AssociatedObject<CollectionViewControllerProtocol>(policy: .OBJC_ASSOCIATION_ASSIGN)

    public weak var viewController: CollectionViewControllerProtocol? {
        get {
            UICollectionView.aoCollectionView[self]
        }
        set {
            UICollectionView.aoCollectionView[self] = newValue
        }
    }

    func collectionView(delegate: UICollectionViewDelegate?, dataSource: UICollectionViewDataSource?) {
        self.delegate = delegate
        self.dataSource = dataSource
    }

    func estimatedItemSize() -> CGSize {
        viewController?.estimatedItemSize() ?? .zero
    }

    func sectionInset() -> UIEdgeInsets {
        viewController?.sectionInset() ?? .zero
    }
}
