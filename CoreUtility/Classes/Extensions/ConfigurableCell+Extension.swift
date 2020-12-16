//
//  TableViewCell+Extension.swift
//  FactsCheck
//
//  Created by Praveen P on 08/04/20.
//  Copyright © 2020 Praveen P. All rights reserved.
//

import UIKit

// protocol for configuring cell
public protocol ConfigurableCell: AnyObject {
    associatedtype ViewModel
    func setup(viewModel: ViewModel)
}

public enum ViewLoadingError: Error {
    case invalidReuseIdentifier(message: String?)
    case loadNibInitialized(message: String?)
}

fileprivate extension UIView {
    static func cellDequeueError(type: AnyClass) -> ViewLoadingError {
        let errorString = "Unable to dequeue cell of type \(type) with reuse identifier '\(defaultReuseIdentifier)'"
        return .invalidReuseIdentifier(message: errorString)
    }
    
    static func loadFromNibError(nibName: String) -> ViewLoadingError {
        let errorString = "\(self) has not been initialized properly from nib \(nibName)"
        return .loadNibInitialized(message: errorString)
    }
}

public extension UIView {
   static var defaultNibName: String {
       String(describing: self)
   }

    // ReuseIdentifier
    static var defaultReuseIdentifier: String {
        "\(self)ID"
    }
     
    static func getNib(nibName: String) -> UINib {
        UINib(nibName: nibName, bundle: Bundle(for: self))
    }
    
    static func loadFromDefaultNib<T: UIView>() throws -> T {
        try loadFromNib(defaultNibName)
    }
    
    static func loadFromNib<T: UIView>(_ nibName: String) throws -> T {
        try loadFromNib(nibName, bundle: Bundle(for: self))
    }
    
    static func loadFromNib<T: UIView>(_ nibName: String, bundle: Bundle) throws -> T {
        try loadFromNib(nibName, bundle: bundle, owner: nil)
    }
    
    static func loadFromNib<T: UIView>(_ nibName: String, bundle: Bundle, owner: Any?) throws -> T {
        guard let view = bundle.loadNibNamed(nibName, owner: owner, options: nil)?.first as? T else {
            throw loadFromNibError(nibName: nibName)
        }
        return view
    }
    
    func loadViewFromNib(_ nibName: String) -> UIView? {
        let nib = Self.getNib(nibName: nibName)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}

public extension UITableViewCell {
    // register a class for the tableView
    static func registerClass(for tableView: UITableView, reuseIdentifier: String? = nil) {
        tableView.register(self, forCellReuseIdentifier: reuseIdentifier ?? defaultReuseIdentifier)
    }
    
    static func registerNib(for tableView: UITableView, reuseIdentifier: String? = nil) {
        let nib = UINib(nibName: defaultNibName, bundle: Bundle(for: self))
        tableView.register(nib, forCellReuseIdentifier: reuseIdentifier ?? defaultReuseIdentifier)
    }
       
    // dequeue cell for the class
    static func dequeue<T: UITableViewCell>(from tableView: UITableView, for indexPath: IndexPath, identifier: String? = nil) throws -> T {
        let identifier = identifier ?? defaultReuseIdentifier
        guard tableView.dequeueReusableCell(withIdentifier: identifier) != nil else {
            throw cellDequeueError(type: T.self)
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            throw cellDequeueError(type: T.self)
        }
        return cell
    }
}

public extension UICollectionViewCell {
    // register a class for the collectionView
    static func registerClass(for collectionView: UICollectionView, reuseIdentifier: String? = nil) {
        collectionView.register(self, forCellWithReuseIdentifier: reuseIdentifier ?? defaultReuseIdentifier)
    }
    
    static func registerNib(for collectionView: UICollectionView, reuseIdentifier: String? = nil) {
        let nib = UINib(nibName: defaultNibName, bundle: Bundle(for: self))
        collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier ?? defaultReuseIdentifier)
    }
    
    // dequeue cell for the class
    static func dequeue<T: UICollectionViewCell>(from collectionView: UICollectionView, for indexPath: IndexPath, reuseIdentifier: String? = nil) throws -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier ?? defaultReuseIdentifier, for: indexPath) as? T else {
            throw cellDequeueError(type: T.self)
        }
        return cell
    }
}

public extension UICollectionReusableView {
    static func reuseIdentifer(reuseIdentifier: String?, elementKind: String) -> String {
        let identifier = (reuseIdentifier ?? defaultReuseIdentifier) + elementKind
        return identifier
    }
    // register a class for the collectionView
    static func registerClass(for collectionView: UICollectionView, forSupplementaryViewOfKind elementKind: String, reuseIdentifier: String? = nil) {
        let identifier = reuseIdentifer(reuseIdentifier: reuseIdentifier, elementKind: elementKind)
        collectionView.register(self, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: identifier)
    }
    
    // register a class for the collectionView's SupplementaryViewOfKind
    static func registerNib(for collectionView: UICollectionView, forSupplementaryViewOfKind elementKind: String, reuseIdentifier: String? = nil) {
        let nib = UINib(nibName: defaultNibName, bundle: Bundle(for: self))
        let identifier = reuseIdentifer(reuseIdentifier: reuseIdentifier, elementKind: elementKind)
        collectionView.register(nib, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: identifier)
    }
    
    // dequeue cell for the class
    static func dequeue<T: UICollectionReusableView>(from collectionView: UICollectionView, ofKind elementKind: String, for indexPath: IndexPath, reuseIdentifier: String = T.defaultReuseIdentifier) throws -> T {
        let identifier = reuseIdentifer(reuseIdentifier: reuseIdentifier, elementKind: elementKind)
        guard let cell = collectionView.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: identifier, for: indexPath) as? T else {
            throw cellDequeueError(type: T.self)
        }
        return cell
    }
}
