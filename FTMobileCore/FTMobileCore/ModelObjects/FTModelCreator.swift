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

public enum FTModelDataType: String {
    case classType = "class"
    case structType = "struct"
}

fileprivate let kRootModel = "FTModelData"
fileprivate let kStringType = "String"

fileprivate let kBindingKey = "bindKey"
fileprivate let kBindingAsType = "bindAs"
fileprivate let kBindingAsArray = "arrayOf"

open class FTModelCreator {
    
    static var sourcePath: String = ""
    static var outputPath: URL? = FTModelCreator.outputModelPath()
    
    static func outputModelPath() -> URL? {
        var outputPath: URL? = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        outputPath?.appendPathComponent("Models")
        return outputPath
    }
    
    static func fileWriter() -> (String,String) -> () {
        
        let fileWriter = { (_ name: String,_ content: String) in
            if var url = outputPath {
                url.appendPathComponent(name); url.appendPathExtension("swift");
                try? content.write(to: url, atomically: true, encoding: .utf8)
                print("Path: ",url.absoluteString)
            }
        }
        
        return fileWriter
    }
    
    static var modelType: FTModelDataType = .classType

    //MARK: Configurations
    static open func configureSourcePath(path: String) { FTModelCreator.sourcePath = path }
    static open func configureOutputPath(path: String) { FTModelCreator.outputPath = URL(string: path) }
    static open func configureModel(type: FTModelDataType) { FTModelCreator.modelType = type }

    //MARK:
    static open func generateOutput() {
        try? sourcePath.filesAtPath({ (filePath) in
            generateModelAt(path: filePath, completionHandler: fileWriter())
        })
    }
    
    static func generateModelAt(path: String, completionHandler: @escaping (_ name: String, _ content: String) -> ()) {
        
        do {
            if let json: [String: AnyObject] = try path.jsonContentAtPath() {
                //Create ".swift" for each object in Dic
                createModelClass(jsonString: json, fileWriterHandler: completionHandler)
            }
        } catch {
            print("Error reading Data")
        }
    }
}

extension FTModelCreator {
    
    static func createModelClass(jsonString: [String: AnyObject],
                                 fileWriterHandler: @escaping (_ fileName: String, _ fileContent: String) -> Swift.Void) {
        
        jsonString.forEach { (key, value) in
            let stribg = createModelFile(modelName: key, params: value as! [String : AnyObject])
            fileWriterHandler(key, stribg)
        }
    }
    
    static func getDefaultValue(bindType:AnyObject, isSubIteration: Bool = false) -> AnyObject {
        
        if bindType is String {
            
            if let bindType = FTModelBindType(rawValue: bindType as! String) {
                switch (bindType) {
                case .String:
                    return "\"\"" as AnyObject
                case .Decimal:
                    return 0 as AnyObject
                case .Int:
                    return 0 as AnyObject
                }
            }
            else if !isSubIteration {
                return "\"\"" as AnyObject
            }
        }
        else if bindType is [String:String] {
            
            if let bindAsType = bindType[kBindingAsType] {
                return getDefaultValue(bindType: bindAsType as AnyObject, isSubIteration: true )
            }
            else if (bindType[kBindingAsArray]) != nil {
                return "[]" as AnyObject
            }
        }
        
        return "nil" as AnyObject
    }
    
    static func getBindings(params: AnyObject) -> (String, String, AnyObject, Bool)? {
        
        if let value = params as? String {
            return (kStringType, value, getDefaultValue(bindType: params), false)
        }
        
        if
            let value = params as? [String:String],
            let bindKey = value[kBindingKey] {
            
            if let bindAsType = value[kBindingAsType] {
                let value = getDefaultValue(bindType: params)
                let isOptionalType = (((value as? String) != nil) && value as! String == "nil")
                return (bindAsType, bindKey, value, isOptionalType)
            }
            else if let bindAsType = value[kBindingAsArray] {
                return ("[\(bindAsType)]", bindKey, "[]" as AnyObject, false)
            }
            
            return nil
        }
        
        return nil
    }
    
    static func createModelFile(modelName: String, params: [String: AnyObject]) -> String {
        
        var paramDef: String = ""
        var codingKeys: String = ""
        var decoderKeys: String = ""
        var encoderKeys: String = ""
        
        params.forEach { (key, type) in
            
            if let bindParams = getBindings(params: type) {
                //
                if (bindParams.3) {
                    paramDef += paramKeysCase(key: key, type: bindParams.0 + "?", defaultValues: bindParams.2 as AnyObject)
                }
                else {
                    paramDef += paramKeysCase(key: key, type: bindParams.0, defaultValues: bindParams.2 as AnyObject)
                }
                //
                codingKeys += codingKeysCase(key: key, value: bindParams.1)
                //
                decoderKeys += decoderCase(key: key, type: bindParams.0)
                //
                encoderKeys += encoderCase(key: key, isOptional: bindParams.3)
            }
        }
        
        let string =
        """
        \(modalHeader(name: modelName)) {
        \(paramDef)
        
        /* Coding Keys */
        \(codingKeysHeader(keyValueCase: codingKeys))
        
        /* Decoder */
        \(decoderHeader(keyValueCase: decoderKeys))
        
        /* Encoder */
        \(encoderHeader(keyValueCase: encoderKeys))
        
        }
        
        """
        
        return string
    }
    
    //MARK: struct definition
    static func modalHeader(name: String) -> String {
        return "final \(modelType.rawValue) \(name): \(kRootModel)"
    }
    
    //MARK: struck params
    static func paramKeysCase(key: String, type: String, defaultValues: AnyObject) -> String {
        return "var \(key): \(type) = \(defaultValues)" + "\n"
    }
    
    //MARK: CodingKey enum definition
    static func codingKeysHeader(keyValueCase value: String) -> String {
        let string =
        """
        enum CodingKeys: String, CodingKey  { \n
        \(value)
        }
        """
        return string
    }
    
    //MARK: CodingKey params
    static func codingKeysCase(key: String, value: String) -> String {
        if key == value {
            return "case \(key)" + "\n"
        }
        return "case \(key) = \"\(value)\"" + "\n"
    }
    
    //MARK: Decoder definition
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
    
    //MARK: Decoder case
    static func decoderCase(key: String, type: String) -> String {
        let string =
        """
        if let value = try container?.decodeIfPresent(\(type).self, forKey: .\(key)) {
            self.\(key) = value
        }
        """
        return string + "\n"
    }
    
    //MARK: Encoder definition
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
    
    //MARK: Encoder case
    static func encoderCase(key: String, isOptional: Bool) -> String {
        let string = "if " +
            (isOptional ? "\(key) != nil" : "!\(key).isEmpty")
            + " {"
            + "\n" +
        """
            try container.encode(\(key), forKey: .\(key))
        }
        """
        return string + "\n"
    }
}
