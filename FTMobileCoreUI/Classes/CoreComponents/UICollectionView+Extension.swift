//
//  UICollectionView.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 30/09/18.
//  Copyright © 2018 Praveen Prabhakar. All rights reserved.
//

import Foundation

extension UICollectionView {

    private static let aoCollectionView = FTAssociatedObject<FTCollectionViewControllerProtocol>(policy: .OBJC_ASSOCIATION_ASSIGN)

    public weak var viewController: FTCollectionViewControllerProtocol? {
        get {
            return UICollectionView.aoCollectionView[self]
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
        return viewController?.estimatedItemSize() ?? .zero
    }

    func sectionInset() -> UIEdgeInsets {
        return viewController?.sectionInset() ?? .zero
    }
}
