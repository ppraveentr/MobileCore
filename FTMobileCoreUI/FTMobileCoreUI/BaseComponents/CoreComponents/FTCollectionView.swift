//
//  FTCollectionView.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 30/09/18.
//  Copyright © 2018 Praveen Prabhakar. All rights reserved.
//

import Foundation

open class FTCollectionView: UICollectionView {

    public weak var viewController: FTCollectionViewProtocol? = nil

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
