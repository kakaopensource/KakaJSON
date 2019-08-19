//
//  Array+KK.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/8/12.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

import Foundation

extension NSArray: KKCompatible {}
extension Array: KKCompatible {}
extension Set: KKCompatible {}
extension NSSet: KKCompatible {}

public extension KK where Base: ExpressibleByArrayLiteral & Sequence {
    // MARK: - JSON -> Model
    func modelArray<M: Convertible>(_ type: M.Type) -> [M]? {
        return modelArray(anyType: type) as? [M]
    }
    
    func modelArray(anyType: Any.Type) -> [Any]? {
        guard let t = anyType as? Convertible.Type,
            let mt = Metadata.type(anyType) as? ModelType,
            let _ = mt.properties
            else { return nil }
        let arr = base.compactMap { element -> Any? in
            switch element {
            case let dict as [String: Any]: return dict.kk_fastModel(t)
            case let dict as Data: return dict.kk_fastModel(t)
            case let dict as String: return dict.kk_fastModel(t)
            default: return nil
            }
        }
        return arr.isEmpty ? nil : arr
    }
    
    // MARK: - Model -> JSON
    func JSONArray() -> [Any]? {
        return base~?.kk_JSON() as? [Any]
    }
    
    func JSONObjectArray() -> [[String: Any]]? {
        let arr = base.compactMap { element -> [String: Any]? in
            (element~! as? Convertible)?.kk_JSONObject()
        }
        return arr.isEmpty ? nil : arr
    }
    
    func JSONString(prettyPrinted: Bool = false) -> String? {
        if let str = JSONSerialization.kk_string(JSONArray(),
                                                 prettyPrinted: prettyPrinted) {
            return str
        }
        Logger.error("Failed to get JSONString from JSON.")
        return nil
    }
}
