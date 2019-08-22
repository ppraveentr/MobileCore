//
//  FTSequence.swift
//  FTCoreUtility
//
//  Created by Praveen Prabhakar on 15/03/18.
//  Copyright © 2018 Praveen Prabhakar. All rights reserved.
//

import Foundation

public protocol FTFlattenIterator: Collection {
    @discardableResult
    mutating func stripNilElements() -> Self
}

extension Array: FTFlattenIterator { }
extension Dictionary: FTFlattenIterator {}

public extension FTFlattenIterator {
    
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
