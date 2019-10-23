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
    static func makeModel(json: Any) throws -> Self
    static func createEmpytModel() throws -> Self

    // JSON
    func jsonModel() throws -> JSON?
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

    static func makeModel(json: Any) throws -> Self {
        if let jsonString = json as? String {
            guard let data = jsonString.data(using: .utf8) else {
                throw FTJsonParserError.invalidJSON
            }
            let model = try JSONDecoder().decode(Self.self, from: data)
            return model
        }
        if let jsonData = json as? Data {
            let model = try JSONDecoder().decode(Self.self, from: jsonData)
            return model
        }
        if let json = json as? JSON {
            let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            return try self.makeModel(json: data)
        }
        
        throw FTJsonParserError.invalidJSON
    }

    func jsonModelData() -> Data? {
        var data: Data?
        do {
            data = try? JSONEncoder().encode(self)
        }
        return data
    }

    func jsonModel() throws -> JSON? {
        let data: Data = try JSONEncoder().encode(self)
        return try? data.jsonContent() as? JSON
    }
    
    func jsonString() -> String? {
        if var jsn: JSON = try? self.jsonModel() {
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

        guard let source = try? sourceData.jsonModel(), let json = try? self.jsonModel() else { return }
        
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

        guard let json = try? self.jsonModel() else { return [] }

        var query: [URLQueryItem] = []
        json.forEach { arg in
            let val = queryItems(arg.key, arg.value)
            query.append(contentsOf: val)
        }

        return query
    }

    // FORM
    func formData() -> Data? {
        
        guard let json = try? self.jsonModel() else {
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
