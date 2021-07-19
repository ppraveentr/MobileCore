//
//  FlattenIterator.swift
//  MobileCore-CoreUtility
//
//  Created by Praveen Prabhakar on 15/03/18.
//  Copyright © 2018 Praveen Prabhakar. All rights reserved.
//

import Foundation
import UIKit

public protocol FlattenIterator: Collection {
    @discardableResult
    mutating func stripNilElements() -> Self
}

extension Array: FlattenIterator {
    // Optional Protocol implementation: intentionally empty
}
extension Dictionary: FlattenIterator {
    // Optional Protocol implementation: intentionally empty
}

public extension FlattenIterator {
    
    @discardableResult
    mutating func stripNilElements() -> Self {
        
        // Sub-Elements
        let stripSubElements = { (_ val: inout Any) -> Any in
            if var asJson = val as? [String: Any?] {
                return asJson.stripNilElements()
            }
            else if var asList = val as? [Any?] {
                return asList.stripNilElements()
            }
            return val
        }
        
        // swiftlint:disable force_unwrapping
        // swiftlint:disable force_cast
        // Dic
        if var dicSub = self as? [String: Any?] {
            dicSub = dicSub.filter { $1 != nil }
            self = dicSub.mapValues { val -> Any in
                var value = val
                return stripSubElements(&value!)
            } as! Self
        }
        // Array
        else if var dicArray = self as? [Any?] {
            dicArray = dicArray.filter({ $0 != nil })
            self = dicArray.map { val -> Any in
                var value = val
                return stripSubElements(&value!)
            } as! Self
        }
         // swiftlint:enable force_unwrapping
        // swiftlint:enable force_cast
        
        return self
    }
}

public extension Dictionary {
    mutating func merge(another: [Key: Value]) {
        for (key, value) in another {
            self[key] = value
        }
    }
}

public extension Dictionary where Value: RangeReplaceableCollection {
    mutating func merge(another: [Key: Value]) {
        for (key, value) in another {
            if let collection = self[key] {
                self[key] = collection + value
            }
            else {
                self[key] = value
            }
        }
    }
}
