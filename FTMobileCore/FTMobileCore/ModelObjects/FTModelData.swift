//
//  FTModelObject.swift
//  FTMobileCore
//
//  Created by Praveen Prabhakar on 15/06/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

//typealias
public typealias JSON = Dictionary<String, Any>

enum FTJsonParserError: Error {
    case invalidJSON
}

//Operator Overloading
func += <K,V> ( left: inout [K:V], right: [K:V]){
    for (k, v) in right {
        left[k] = v
    }
}

public protocol FTModelData: Codable {
    static func createModelData(json: String) throws -> Self
    static func createModelData(json: Data) throws -> Self
    func jsonModelData() throws -> Data?
}

//FIXIT: To Extend 'FTModelData' to sequence Item with confirms 'Codable'.
extension Array: FTModelData { }
extension Dictionary: FTModelData { }

public extension FTModelData {
    
    static public func createModelData(json: String) throws  -> Self {
        let jsonData = json.data(using: .utf8)
        let data = try JSONDecoder().decode(Self.self, from:jsonData!)
        return data
    }
    
    static public func createModelData(json: Data) throws  -> Self {
        let data = try JSONDecoder().decode(Self.self, from:json)
        return data
    }
    
    func jsonModelData() -> Data? {
        var data: Data?
        do {
            data = try JSONEncoder().encode(self)
        } catch {}
        return data
    }
    
    func jsonString() -> String? {
        var string: String? = nil
        
        do {
            var data: Data = try JSONEncoder().encode(self)
            if var jsn: JSON = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? JSON {
                jsn.stripNilElements()
                if JSONSerialization.isValidJSONObject(jsn){
                    data = try JSONSerialization.data(withJSONObject: jsn, options: .prettyPrinted)
                    string = String(data: data, encoding: .utf8)
                }
            }
        } catch {}
        
        return string
    }
}

public class FTModelObject {
    
    @discardableResult
    public class func createDataModel<S: FTModelData>(ofType modelType: S.Type,
                                      fromJSON json: Any) throws -> S {
        
        guard (json is String) || (json is Data) else {
            throw FTJsonParserError.invalidJSON
        }
        
        if (json is String) {
            return try modelType.createModelData(json: json as! String)
        }
        
        return try modelType.createModelData(json: json as! Data)
    }
}
