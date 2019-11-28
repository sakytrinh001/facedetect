//
//  BaseModel.swift
//  FaceDetect
//
//  Created by administrator on 11/27/19.
//  Copyright © 2019 Nguyen Le Minh. All rights reserved.
//

import UIKit

class BaseModel: NSObject {
    
    
    public override init() {
        super.init()
    }
    
    public init(dictionary : NSDictionary) {
        super.init()
        var allKey = self.getPropertyNames()
        for i in 0..<allKey.count {
            let key = allKey[i]
            if(dictionary[key] != nil) {
                if let value = dictionary[key] {
                    if(!(value is NSNull)) {
                        self.setValue(value , forKey: key )
                    }
                }
            }
        }
    }
    
    public init(dictionary : NSDictionary, skipKeys: [String]) {
        super.init()
        var allKey = self.getPropertyNames()
        for i in 0..<allKey.count {
            if((skipKeys.firstIndex{$0 == allKey[i]}) != nil) {
                break
            } else {
                let key = allKey[i]
                if(dictionary[key] != nil) {
                    if let value = dictionary[key] {
                        if(!(value is NSNull)) {
                            self.setValue(value , forKey: key )
                        }
                    }
                }
            }
        }
    }
    
    public func toDictionary() -> Dictionary<String, Any> {
        var dict = Dictionary<String, Any>()
        let keys = getPropertyNames()
        for i in 0..<keys.count {
            dict[keys[i]] = value(forKey: keys[i])
        }
        return dict
    }
    
    public func toDictionary(skipKey : [String]) -> Dictionary<String, Any> {
        var dict = Dictionary<String, Any>()
        let keys = getPropertyNames()
        for  i in 0..<keys.count {
            if((skipKey.firstIndex{$0 == keys[i]}) != nil) {
                continue
            }
            dict[keys[i]] = value(forKey: keys[i])
        }
        return dict;
    }
    public func getPropertyNames() -> [String] {
        return Mirror(reflecting: self).children.compactMap { $0.label }
    }
    
}
