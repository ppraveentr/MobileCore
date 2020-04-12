//
//  UITableViewCell+Extension.swift
//  FactsCheck
//
//  Created by Praveen P on 08/04/20.
//  Copyright © 2020 Praveen P. All rights reserved.
//

import UIKit

// protocol for configuring cell
protocol ConfigurableCell: AnyObject {
    associatedtype ViewModel
    func setup(viewModel: ViewModel)
}

extension UITableViewCell {
    // ReuseIdentifier
    static var defaultReuseIdentifier: String {
        "\(self)ID"
    }
    
    // register a class for the tableView
    static func registerClass(for tableView: UITableView, reuseIdentifier: String? = nil) {
        tableView.register(self, forCellReuseIdentifier: reuseIdentifier ?? defaultReuseIdentifier)
    }
    
    // dequeue cell for the class
    static func dequeue<T: UITableViewCell>(from tableView: UITableView, for indexPath: IndexPath) -> T {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to dequeue cell of type \(T.self) with reuse identifier '\(defaultReuseIdentifier)'")
        }
        return cell
    }
}
