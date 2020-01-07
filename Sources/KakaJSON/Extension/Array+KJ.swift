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
    /// JSONObjectArray -> EnumArray
    func enumArray<M: ConvertibleEnum>(_ type: M.Type) -> [M] {
        return enumArray(type: type) as! [M]
    }
    
    /// JSONObjectArray -> EnumArray
    func enumArray(type: ConvertibleEnum.Type) -> [ConvertibleEnum] {
        guard let _ = Metadata.type(type) as? EnumType else { return [] }
        return base.compactMap {
            let vv = Values.value($0, type.kj_valueType)
            return type.kj_convert(from: vv as Any)
        }
    }
    
    /// JSONObjectArray -> ModelArray
    func modelArray<M: Convertible>(_ type: M.Type) -> [M] {
        return modelArray(type: type) as! [M]
    }
    
    /// JSONObjectArray -> ModelArray
    func modelArray(type: Convertible.Type) -> [Convertible] {
        guard let mt = Metadata.type(type) as? ModelType,
            let _ = mt.properties
            else { return [] }
        return base.compactMap {
            switch $0 {
            case let dict as [String: Any]: return dict.kj_fastModel(type)
            case let dict as Data: return dict.kj_fastModel(type)
            case let dict as String: return dict.kj_fastModel(type)
            default: return nil
            }
        }
    }
    
    /// ModelArray -> JSONObjectArray
    func JSONObjectArray() -> [[String: Any]] {
        return base.compactMap {
            ($0~! as? Convertible)?.kj_JSONObject()
        }
    }
    
    /// Array -> JSONArray
    func JSONArray() -> [Any] {
        return Values.JSONValue(base) as! [Any]
    }
    
    /// Array -> JSONString
    func JSONString(prettyPrinted: Bool = false) -> String {
        if let str = JSONSerialization.kj_string(JSONArray(),
                                                 prettyPrinted: prettyPrinted) {
            return str
        }
        Logger.error("Failed to get JSONString from JSON.")
        return ""
    }
}
