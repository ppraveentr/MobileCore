//
//  FTModelCreator.swift
//  FTMobileCore
//
//  Created by Praveen Prabhakar on 08/03/18.
//  Copyright © 2018 Praveen Prabhakar. All rights reserved.
//

import Foundation

enum FTModelBindType: String {
    case String
    case Decimal
    case Int
}

public enum FTServiceModelType: String {
    case classType = "class"
    case structType = "struct"
}

fileprivate let kRootModel = "FTServiceModel"
fileprivate let kStringType = "String"
fileprivate let kDefaultStringValue = "nil"
fileprivate let kDefaultArrayValue = "nil" //[]

fileprivate let kBindingKey = "bindKey"
fileprivate let kBindingAsType = "bindAs"
fileprivate let kBindingAsArray = "arrayOf"

open class FTModelCreator {
    
    static var sourcePath: String = ""
    static var outputPath: URL? = FTModelCreator.outputModelPath()
    
    static func outputModelPath() -> URL? {
        var outputPath: URL? = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        outputPath?.appendPathComponent("Models")
        if outputPath != nil {
            try? FileManager.default.createDirectory(at: outputPath!, withIntermediateDirectories: true, attributes: nil)
        }
        return outputPath
    }
    
    static func fileWriter() -> (String,String) -> () {
        
        let fileWriter = { (_ name: String,_ content: String) in
            if var url = outputPath {
                url.appendPathComponent(name)
                url.appendPathExtension("swift")
                try? content.write(to: url, atomically: true, encoding: .utf8)
                FTLog("Path: ",url.absoluteString)
            }
        }
        
        return fileWriter
    }
    
    static var modelType: FTServiceModelType = .classType

    // MARK: Configurations
    class open func configureSourcePath(path: String) { FTModelCreator.sourcePath = path }
    class open func configureOutputPath(path: String) { FTModelCreator.outputPath = URL(string: path) }
    class open func configureModel(type: FTServiceModelType) { FTModelCreator.modelType = type }

    // MARK:
    class open func generateOutput() {
        try? sourcePath.filesAtPath({ (filePath) in
            generateModelAt(path: filePath, completionHandler: fileWriter())
        })
    }
    
    static func generateModelAt(path: String, completionHandler: @escaping (_ name: String, _ content: String) -> ()) {
        
        do {
            if let json: [String: AnyObject] = try path.jsonContentAtPath() {
                // Create ".swift" for each object in Dic
                modelClass(jsonString: json, fileWriterHandler: completionHandler)
            }
        } catch {
            FTLog("Error reading Data")
        }
    }
    
}

extension FTModelCreator {
    
    /// Create Model class for-each dic key
    static func modelClass(jsonString: [String: AnyObject],
                                 fileWriterHandler: @escaping (_ fileName: String, _ fileContent: String) -> Swift.Void) {
        
        jsonString.forEach { (key, value) in
            let stribg = createModelFile(modelName: key, params: value as! [String : AnyObject])
            fileWriterHandler(key, stribg)
        }
    }
    
    ///Default values for each data type
    static func defaultValue(bindType:AnyObject, isSubIteration: Bool = false) -> AnyObject {
        
        if let bindType = bindType as? String {
            
            if let bindType = FTModelBindType(rawValue: bindType) {
                switch (bindType) {
                case .String:
                    return kDefaultStringValue as AnyObject
                case .Decimal:
                    return 0 as AnyObject
                case .Int:
                    return 0 as AnyObject
                }
            }
            else if !isSubIteration {
                return kDefaultStringValue as AnyObject
            }
        }
        else if bindType is [String:String] {
            
            if let bindAsType = bindType[kBindingAsType] {
                return defaultValue(bindType: bindAsType as AnyObject, isSubIteration: true )
            }
            else if (bindType[kBindingAsArray]) != nil {
                return kDefaultArrayValue as AnyObject
            }
        }
        
        return kDefaultStringValue as AnyObject
    }
    
    /// Setup binding params for file creation, for each param in model-dic
    static func bindings(forParams params: AnyObject) -> (String, String, AnyObject, Bool)? {
        
        if let value = params as? String {
            return (kStringType, value, defaultValue(bindType: params), false)
        }
        
        if
            let value = params as? [String:String],
            let bindKey = value[kBindingKey] {
            
            if let bindAsType = value[kBindingAsType] {
                let value = defaultValue(bindType: params)
                let isOptionalType = (((value as? String) != nil) && value as! String == kDefaultStringValue)
                return (bindAsType, bindKey, value, isOptionalType)
            }
            else if let bindAsType = value[kBindingAsArray] {
                return ("[\(bindAsType)]", bindKey, kDefaultArrayValue as AnyObject, false)
            }
            
            return nil
        }
        
        return nil
    }
    
    // MARK: File Content Creator
    static func createModelFile(modelName: String, params: [String: AnyObject]) -> String {
        var paramDef: String = ""
        var codingKeys: String = ""
        // var decoderKeys: String = "", encoderKeys: String = ""
        
        params.forEach { (key, type) in
            if let bindParams = bindings(forParams: type) {
                // If (bindParams.3) is true, then :'type': will be \(bindParams.0 + "?")
                paramDef += paramKeysCase(key: key, type: bindParams.0, defaultValues: bindParams.2 as AnyObject)
                codingKeys += codingKeysCase(key: key, value: bindParams.1)
                // decoderKeys += decoderCase(key: key, type: bindParams.0)
                // encoderKeys += encoderCase(key: key)
            }
        }
    
        var string = modalHeader(name: modelName) + " {" + "\n"
        string += "\n" + paramDef + "\n"
        string += "/* Coding Keys */" + "\n"
        string += codingKeysHeader(keyValueCase: codingKeys) + "\n"
        /*
        string += "\n" + "/* Decoder */" + "\n"
        string += decoderHeader(keyValueCase: decoderKeys) + "\n"
        string += "\n" + "/* Encoder */" + "\n"
        string += encoderHeader(keyValueCase: encoderKeys) + "\n"
        */
        string += "}"
        
        return string
    }
    
    // MARK: struct definition
    static func modalHeader(name: String) -> String {
        return "final \(modelType.rawValue) \(name): \(kRootModel)"
    }
    
    // MARK: struck params
    static func paramKeysCase(key: String, type: String, defaultValues: AnyObject) -> String {
        return "var \(key): \(type)? = \(defaultValues)" + "\n"
    }
    
    // MARK: CodingKey enum definition
    static func codingKeysHeader(keyValueCase value: String) -> String {
        let string =
        """
        enum CodingKeys: String, CodingKey  {
        \(value)
        }
        """
        return string
    }
    
    // MARK: CodingKey params
    static func codingKeysCase(key: String, value: String) -> String {
        if key == value {
            return "case \(key)" + "\n"
        }
        return "case \(key) = \"\(value)\"" + "\n"
    }
    
    // MARK: Decoder definition
    static func decoderHeader(keyValueCase value: String) -> String {
        let string =
        """
        init(from decoder: Decoder) throws { \n
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        \(value)
        }
        """
        return string
    }
    
    // MARK: Decoder case
    static func decoderCase(key: String, type: String) -> String {
        let string = "self.\(key) = try container?.decodeIfPresent(\(type).self, forKey: .\(key))"
        return string + "\n"
    }
    
    // MARK: Encoder definition
    static func encoderHeader(keyValueCase value: String) -> String {
        let string =
        """
        func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        \(value)
        }
        """
        return string
    }
    
    // MARK: Encoder case
    static func encoderCase(key: String) -> String {
        let string = "try container.encode(\(key), forKey: .\(key))"
        return string + "\n"
    }
}
