//
//  FTServiceModel.swift
//  FTMobileCore
//
//  Created by Praveen Prabhakar on 15/06/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

// typealias
public typealias JSON = [String: Any]

enum FTJsonParserError: Error {
    case invalidJSON
}

public protocol FTServiceModel: Codable {
    static func makeModel(json: String) throws -> Self
    static func makeModel(json: Data) throws -> Self
    static func createEmpytModel() throws -> Self

    // JSON
    func jsonModel() -> JSON?
    func jsonModelData() -> Data?
    func jsonString() -> String?
    mutating func merge(data: FTServiceModel)
    // URL
    func queryItems() -> [URLQueryItem]
}

// FIXIT: To Extend 'FTServiceModel' to sequence Item with confirms 'Codable'.
extension Array: FTServiceModel where Element: Codable { }
extension Dictionary: FTServiceModel where Key: Codable, Value: Codable { }

public extension FTServiceModel {

    static func createEmpytModel() throws -> Self {
        let data = try makeModel(json: [:])
        return data
    }

    static func makeModel(json: String) throws -> Self {
        guard let jsonData = json.data(using: .utf8) else {
            throw FTJsonParserError.invalidJSON
        }
        let data = try JSONDecoder().decode(Self.self, from: jsonData)
        return data
    }
    
    static func makeModel(json: Data) throws -> Self {
        let data = try JSONDecoder().decode(Self.self, from: json)
        return data
    }

    static func makeModel(json: JSON) throws -> Self {
        let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        return try self.makeModel(json: data)
    }

    func jsonModelData() -> Data? {
        var data: Data?
        do {
            data = try? JSONEncoder().encode(self)
        }
        return data
    }

    func jsonModel() -> JSON? {

        do {
            let data: Data = try JSONEncoder().encode(self)
            return data.jsonContent() as? JSON
        }
        catch {}

        return nil
    }
    
    func jsonString() -> String? {
        if var jsn: JSON = self.jsonModel() {
            jsn.stripNilElements()
            if
                JSONSerialization.isValidJSONObject(jsn),
                let data = try? JSONSerialization.data(withJSONObject: jsn, options: .prettyPrinted)
            {
                return data.decodeToString()
            }
        }
        return nil
    }

    mutating func merge(data sourceData: FTServiceModel) {

        guard let source = sourceData.jsonModel(), let json = self.jsonModel() else {
            return
        }
        
        let data = json.merging(source) { left, right -> Any in
            if var leftJson = left as? FTServiceModel,
               let rightJson = right as? FTServiceModel {
                return leftJson.merge(data: rightJson)
            }
            else if let leftJson = left as? [Any], let rightJson = right as? [Any] {
                return leftJson + rightJson
            }
            return right
        }
        
        if let data = try? Self.makeModel(json: data) {
            self = data
        }
    }

    // Encode complex key/value objects in NSRULQueryItem pairs
    private func queryItems(_ key: String, _ value: Any?) -> [URLQueryItem] {
        var result = [] as [URLQueryItem]

        if let dictionary = value as? [String: AnyObject] {
            for (nestedKey, value) in dictionary {
                result += queryItems("\(key).\(nestedKey)", value)
            }
        }
        else if let array = value as? [AnyObject] {
            for value in array {
                result += queryItems(key, value)
            }
        }
        else if (value as? NSNull) != nil {
            result.append(URLQueryItem(name: key, value: nil))
        }
        else if let v = value {
            result.append(URLQueryItem(name: key, value: "\(v)"))
        }
        else {
            result.append(URLQueryItem(name: key, value: nil))
        }
        return result
    }

    // URL
    func queryItems() -> [URLQueryItem] {

        guard let json = self.jsonModel() else { return [] }

        var query: [URLQueryItem] = []
        json.forEach { arg in
            let val = queryItems(arg.key, arg.value)
            query.append(contentsOf: val)
        }

        return query
    }

    // FORM
    func formData() -> Data? {
        
        guard let json = self.jsonModel() else {
            return nil
        }

        var postData: Data?
        json.forEach { arg in
            if let value = arg.value as? String {
                let key = arg.key
                if postData == nil {
                    postData = "\(key)=\(value)".data(using: String.Encoding.utf8)!
                }
                else {
                    postData!.append("&\(key)=\(value)".data(using: String.Encoding.utf8)!)
                }
            }
        }

        return postData
    }
}

open class FTServiceModelObject: FTServiceModel {
    
    @discardableResult
    public static func makeModel<S: FTServiceModel>(ofType modelType: S.Type, fromJSON json: Any) throws -> S {
        
        guard (json is String) || (json is Data) else {
            throw FTJsonParserError.invalidJSON
        }
        
        if let json = json as? String {
            return try modelType.makeModel(json: json)
        }
        else if let json = json as? Data {
            return try modelType.makeModel(json: json)
        }
        
        throw FTJsonParserError.invalidJSON
    }
}
