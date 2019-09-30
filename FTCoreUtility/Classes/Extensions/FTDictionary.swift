//
//  FTDictionary.swift
//  FTCoreUtility
//
//  Created by Praveen Prabhakar on 01/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

public extension Dictionary {
    func keyPath<T>(_ keyPath: String) -> T? {
        return (self as NSDictionary).value(forKeyPath: keyPath) as? T
    }
}

// swiftlint:disable static_operator
// MARK: Dictionary: 
// Operator '+' Overloading
func + <K, V> (left: [K: V], right: [K: V]) -> [K: V] {
    var computedValue = left
    
    for (k, v) in right {
        var superObject: [K: V]? = left[k] as? [K: V]
        let subObject = v as? [K: V]
        
        if subObject != nil, superObject != nil {
            superObject! += subObject!
            computedValue[k]! = (superObject as? V)!
        }
        else {
            computedValue[k] = v
        }
    }
    
    return computedValue
}

// Operator Overloading
func += <K, V> (left: inout [K: V], right: [K: V]) {
    for (k, v) in right {
        left[k] = v
    }
}

func += <K, V> (left: inout [K: V], right: [K: V]) where V: RangeReplaceableCollection {
    for (k, v) in right {
        if let collection = left[k] {
            left[k] = collection + v
        }
        else {
            left[k] = v
        }
    }
}

// MARK: Array
public func += <K> ( left: inout [K], right: [K]) {
    for (k) in right {
        left.append(k)
    }
}
// swiftlint:enable static_operator
