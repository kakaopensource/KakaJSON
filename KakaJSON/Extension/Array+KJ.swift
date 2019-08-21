//
//  Array+KJ.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/8/12.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

import Foundation

extension NSArray: KJCompatible {}
extension Array: KJCompatible {}
extension Set: KJCompatible {}
extension NSSet: KJCompatible {}

public extension KJ where Base: ExpressibleByArrayLiteral & Sequence {
    /// JSONObjectArray -> ModelArray
    func modelArray<M: Convertible>(_ type: M.Type) -> [M]? {
        return modelArray(anyType: type) as? [M]
    }
    
    /// JSONObjectArray -> ModelArray
    func modelArray(anyType: Any.Type) -> [Any]? {
        guard let t = anyType as? Convertible.Type,
            let mt = Metadata.type(anyType) as? ModelType,
            let _ = mt.properties
            else { return nil }
        let arr = base.compactMap { element -> Any? in
            switch element {
            case let dict as [String: Any]: return dict.kj_fastModel(t)
            case let dict as Data: return dict.kj_fastModel(t)
            case let dict as String: return dict.kj_fastModel(t)
            default: return nil
            }
        }
        return arr.isEmpty ? nil : arr
    }
    
    /// ModelArray -> JSONObjectArray
    func JSONObjectArray() -> [[String: Any]]? {
        let arr = base.compactMap { element -> [String: Any]? in
            (element~! as? Convertible)?.kj_JSONObject()
        }
        return arr.isEmpty ? nil : arr
    }
    
    /// Array -> JSONArray
    func JSONArray() -> [Any]? {
        return base~?.kj_JSON() as? [Any]
    }
    
    /// Array -> JSONArray
    func JSONString(prettyPrinted: Bool = false) -> String? {
        if let str = JSONSerialization.kj_string(JSONArray(),
                                                 prettyPrinted: prettyPrinted) {
            return str
        }
        Logger.error("Failed to get JSONString from JSON.")
        return nil
    }
}
