//
//  FTDataModel.swift
//  FTMobileCore
//
//  Created by Praveen Prabhakar on 15/06/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

open class FTDataModel : NSObject {
    
    var jsonData: Dictionary<String,Any> = [:]
    var classType: AnyClass = FTDataModel.self
    
     public override required init(){
        super.init()
        self.jsonData = [:]
    }

    public required convenience init(jsonData: Dictionary<String,Any>, baseClass: AnyClass) {
        self.init()
        
        self.classType = baseClass
        
        self.__setup__()

        self.jsonData = jsonData
    }
    
}

extension FTDataModel {
 
    public class func createDataModelOfType(_ baseClass: String, fromDictionary dic: Dictionary<String, Any>) -> Any? {
        
        guard let cls = baseClass.getClassInstance() as? FTDataModel.Type else { return nil }
        
        return cls.init(jsonData:dic, baseClass: cls)
    }
}

extension FTDataModel {
    
    func __setup__ ()  {
            
        let properties = getClassPropertyNames(self)

        print(properties ?? "properties of type \(classType) are empty");

    }
    
    override open class func resolveInstanceMethod(_ sel: Selector!) -> Bool {
        
//        if (aSEL == @selector(resolveThisMethodDynamically)) {
//            class_addMethod([self class], aSEL, (IMP) dynamicMethodIMP, "v@:");
//            return YES;
//        }
//        return [super resolveInstanceMethod:aSEL];
        
        
        return false
    }
    

    
}

