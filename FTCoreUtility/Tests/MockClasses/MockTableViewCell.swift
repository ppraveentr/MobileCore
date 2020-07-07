//
//  MockTableViewCell.swift
//  MobileCoreTests
//
//  Created by Praveen Prabhakar on 05/07/20.
//  Copyright © 2020 Praveen Prabhakar. All rights reserved.
//

import MobileCore
import UIKit

struct MockCellModel {
    var identifier: String?
    var title: String?
}

final class MockTableViewCell: UITableViewCell {
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

extension MockTableViewCell: ConfigurableCell {
    typealias ViewModel = MockCellModel
    func setup(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
}
