//
//  String+KJ.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/8/5.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

import Foundation

extension String: KJCompatible {}
extension NSString: KJCompatible {}

public extension KJ where Base: ExpressibleByStringLiteral {
    /// from underline-cased to camel-cased
    ///
    /// e.g. from `my_test_name` to `myTestName`
    func camelCased() -> String {
        guard let str = base as? String else { return "" }
        var newStr = ""
        var upper = false
        for c in str {
            if c == "_" {
                upper = true
                continue
            }
            
            if upper, newStr.count > 0 {
                newStr += c.uppercased()
            } else {
                newStr.append(c)
            }
            upper = false
        }
        return newStr
    }
    
    /// from camel-cased to underline-cased
    ///
    /// e.g. from `myTestName` to `my_test_name`
    func underlineCased() -> String {
        guard let str = base as? String else { return "" }
        var newStr = ""
        for c in str {
            if c >= "A", c <= "Z" {
                newStr += "_"
                newStr += c.lowercased()
            } else {
                newStr.append(c)
            }
        }
        return newStr
    }
    
    /// JSONObject -> Model
    func model<M: Convertible>(_ type: M.Type) -> M? {
        return model(anyType: type) as? M
    }
    
    /// JSONObject -> Model
    func model(anyType: Any.Type) -> Any? {
        if let json = JSONSerialization.kj_JSON(base as? String, [String: Any].self) {
            return json.kj.model(anyType: anyType)
        }
        Logger.error("Failed to get JSON from JSONString.")
        return nil
    }
    
    /// JSONObjectArray -> ModelArray
    func modelArray<M: Convertible>(_ type: M.Type) -> [M]? {
        return modelArray(anyType: type) as? [M]
    }
    
    /// JSONObjectArray -> ModelArray
    func modelArray(anyType: Any.Type) -> [Any]? {
        if let json = JSONSerialization.kj_JSON(base as? String, [Any].self) {
            return json.kj.modelArray(anyType: anyType)
        }
        Logger.error("Failed to get JSON from JSONString.")
        return nil
    }
}

extension String {
    func kj_fastModel(_ type: Convertible.Type) -> Convertible? {
        if let json = JSONSerialization.kj_JSON(self, [String: Any].self) {
            return json.kj_fastModel(type)
        }
        Logger.error("Failed to get JSON from JSONString.")
        return nil
    }
}
