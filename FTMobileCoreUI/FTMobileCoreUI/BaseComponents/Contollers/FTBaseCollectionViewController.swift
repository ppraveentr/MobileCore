//
//  FTBaseCollectionViewController.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 30/09/18.
//  Copyright © 2018 Praveen Prabhakar. All rights reserved.
//

import Foundation

public protocol FTCollectionViewProtocol: NSObjectProtocol {
    // Cell config
    func estimatedItemSize() -> CGSize
    func sectionInset() -> UIEdgeInsets
}

extension FTCollectionViewProtocol {

    public func estimatedItemSize() -> CGSize {
        return .zero
    }

    public func sectionInset() -> UIEdgeInsets {
        return .zero
    }

}

open class FTBaseCollectionViewController: FTBaseViewController, FTCollectionViewProtocol {

    public lazy var collectionView: FTCollectionView = self.getCollectionView()
    public var  delegate: UICollectionViewDelegate? {
        didSet{
            collectionView.delegate = delegate
        }
    }
    public var dataSource: UICollectionViewDataSource? {
        didSet{
            collectionView.dataSource = dataSource
        }
    }

    open func flowLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        return layout
    }

    open override func loadView() {
        super.loadView()

        _ = self.collectionView
    }

}

extension FTBaseCollectionViewController {

    func getCollectionView() -> FTCollectionView {

        let local = FTCollectionView(frame: .zero, collectionViewLayout: flowLayout())
        local.viewController = self
        local.backgroundColor = UIColor.white
        local.backgroundView?.backgroundColor = UIColor.white
        
        self.mainView?.pin(view: local, edgeOffsets: .zero)

        return local
    }

}

extension FTBaseCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }

    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }

}
