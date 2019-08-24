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

    public lazy var collectionView: UICollectionView = self.getCollectionView()
    @IBInspectable
    public var collectionViewTheme: String? = nil {
        didSet {
            if isViewLoaded, !collectionViewTheme.isNilOrEmpty {
                collectionView.theme = collectionViewTheme
            }
        }
    }

    public var  delegate: UICollectionViewDelegate? {
        didSet {
            collectionView.delegate = delegate
        }
    }
    public var dataSource: UICollectionViewDataSource? {
        didSet {
            collectionView.dataSource = dataSource
        }
    }

    open func flowLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        return layout
    }

    override open func loadView() {
        super.loadView()

        _ = self.collectionView

        if let theme = self.collectionViewTheme {
            self.collectionViewTheme = theme
        }
    }

    func getCollectionView() -> UICollectionView {

        let local = UICollectionView(frame: .zero, collectionViewLayout: flowLayout())
        local.viewController = self
        local.theme = FTThemeStyle.defaultStyle
        // Pin view to edges
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
