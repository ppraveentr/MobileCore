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
func += <K,V> ( left: inout [K:V], right: [K:V]) {
    for (k, v) in right {
        left[k] = v
    }
}

func += <K,V> ( left: inout [K:V], right: [K:V]) where V: RangeReplaceableCollection {
    for (k, v) in right {
        if let collection = left[k] {
            left[k] = collection + v
        } else {
            left[k] = v
        }
    }
}

func += <K> ( left: inout [K], right: [K]){
    for (k) in right {
        left.append(k)
    }
}

public protocol FTModelData: Codable {
    static func createModelData(json: String) throws -> Self
    static func createModelData(json: Data) throws -> Self
    static func createEmpytModel() -> Self

    //JSON
    func jsonModel() -> JSON?
    func jsonModelData() throws -> Data?
}

//FIXIT: To Extend 'FTModelData' to sequence Item with confirms 'Codable'.
extension Array: FTModelData { }
extension Dictionary: FTModelData { }

public extension FTModelData {

    static func createEmpytModel() -> Self {
        return try! createModelData(json: [:])
    }

    static public func createModelData(json: String) throws  -> Self {
        let jsonData = json.data(using: .utf8)
        let data = try JSONDecoder().decode(Self.self, from:jsonData!)
        return data
    }
    
    static public func createModelData(json: Data) throws  -> Self {
        let data = try JSONDecoder().decode(Self.self, from:json)
        return data
    }

    static public func createModelData(json: JSON) throws  -> Self {
        let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        return try self.createModelData(json: data)
    }

    func jsonModelData() -> Data? {
        var data: Data?
        do {
            data = try JSONEncoder().encode(self)
        } catch {}
        return data
    }

    func jsonModel() -> JSON? {

        do {
            let data: Data = try JSONEncoder().encode(self)
            return try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? JSON

        } catch {}

        return nil
    }
    
    func jsonString() -> String? {
        var string: String? = nil
        
        do {
            if var jsn: JSON = self.jsonModel() {
                jsn.stripNilElements()
                if JSONSerialization.isValidJSONObject(jsn){
                    let data = try JSONSerialization.data(withJSONObject: jsn, options: .prettyPrinted)
                    string = String(data: data, encoding: .utf8)
                }
            }
        } catch {}
        
        return string
    }

    mutating func merge(data: FTModelData) {

        let json = self.jsonModel()
        let data = json?.merging((data.jsonModel())!, uniquingKeysWith: { (left, right) -> Any in
            if var leftJson = left as? FTModelData,
               let rightJson = right as? FTModelData {
                return leftJson.merge(data: rightJson)
            }
            else
                if let leftJson = left as? [Any],
                let rightJson = right as? [Any] {
                return leftJson + rightJson
            }

            return right
        })

        self = try! Self.createModelData(json: data!)
    }
    
    //URL
    func queryItems() -> [URLQueryItem] {

        guard let json = self.jsonModel() else { return [] }

        var query:[URLQueryItem] = []
        _ = json.map { (key, value) -> URLQueryItem? in
            if let value = value as? String {
                query.append(URLQueryItem(name: key , value: value))
            }
            else {
                if let value = value as? FTModelData,
                    let valueModel = value.jsonModel()  {
                    query.append(contentsOf: valueModel.queryItems())
                }
            }
            return nil
        }

        return query

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
