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

public extension UIView {
    static var defaultNibName: String {
        return String(describing: self)
    }
    
    static func loadFromDefaultNib<T: UIView>() -> T {
        return loadFromNib(defaultNibName)
    }
    
    static func loadFromNib<T: UIView>(_ nibName: String) -> T {
        return loadFromNib(nibName, bundle: Bundle(for: self))
    }
    
    static func loadFromNib<T: UIView>(_ nibName: String, bundle: Bundle) -> T {
        return loadFromNib(nibName, bundle: bundle, owner: nil)
    }
    
    static func loadFromNib<T: UIView>(_ nibName: String, bundle: Bundle, owner: Any?) -> T {
        guard let view = bundle.loadNibNamed(nibName, owner: owner, options: nil)?.first as? T else {
            fatalError("\(self) has not been initialized properly from nib \(nibName)")
        }
        return view
    }
    
    func loadViewFromNib(_ nibName: String) -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}

public extension UITableViewCell {
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

public extension UICollectionViewCell {
    // ReuseIdentifier
    static var defaultReuseIdentifier: String {
        "\(self)ID"
    }
    
    static var defaultNib: UINib {
        return getNib(nibName: defaultNibName)
    }
    
    static func getNib(nibName: String) -> UINib {
        return UINib(nibName: nibName, bundle: Bundle(for: self))
    }
    
    // register a class for the tableView
    static func registerClass(for collectionView: UICollectionView, reuseIdentifier: String? = nil) {
        collectionView.register(self, forCellWithReuseIdentifier: reuseIdentifier ?? defaultReuseIdentifier)
    }
    
    static func registerNib(for collectionView: UICollectionView, reuseIdentifier: String? = nil) {
        let nib = UINib(nibName: defaultNibName, bundle: Bundle(for: self))
        collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier ?? defaultReuseIdentifier)
    }
    
    // dequeue cell for the class
    static func dequeue<T: UICollectionViewCell>(from collectionView: UICollectionView, for indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to dequeue cell of type \(T.self) with reuse identifier '\(defaultReuseIdentifier)'")
        }
        return cell
    }
}
