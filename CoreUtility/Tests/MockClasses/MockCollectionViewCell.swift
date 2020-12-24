//
//  MockCollectionViewCell.swift
//  MobileCoreTests
//
//  Created by Praveen Prabhakar on 24/12/20.
//  Copyright © 2020 Praveen Prabhakar. All rights reserved.
//

import MobileCore
import UIKit

final class MockCollectionViewCell: UICollectionViewCell {
    var viewModel: MockCellModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mockSetup()
    }
    
    func mockSetup() {
        setup(viewModel: MockCellModel(identifier: "mockId", title: "mockTitle"))
    }
}

// MARK: - Setup ViewModel

extension MockCollectionViewCell: ConfigurableCell {
    typealias ViewModel = MockCellModel
    func setup(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
}
