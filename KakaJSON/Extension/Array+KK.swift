//
//  Array+KK.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/8/12.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

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
            var model: Any?
            if let string = element as? String {
                model = string.kk_fastModel(t)
            } else if let dict = element as? JSONObject {
                model = dict.kk_fastModel(t)
            }
            return model
        }
        return arr.isEmpty ? nil : arr
    }
    
    // MARK: - Model -> JSON
    func JSON() -> JSONArray? {
        let arr = base.compactMap { element in
            return (element~! as? Convertible)?.kk_JSON()
        }
        return arr.isEmpty ? nil : arr
    }
    
    func JSONString(prettyPrinted: Bool = false) -> String? {
        if let str = JSONSerialization.kk_string(JSON(),
                                                 prettyPrinted: prettyPrinted) {
            return str
        }
        Logger.error("Failed to get JSONString from JSON.")
        return nil
    }
}

extension NSArray {
    func kk_JSONValue() -> Any? {
        return (self as? [Any])?.kk_JSONValue()
    }
}

extension Array {
    func kk_JSONValue() -> Any? {
        var arr: [Any] = []
        for element in self {
            let value = element~!
            if let v = Converter.JSONValue(from: value) {
                arr.append(v)
            } else if let cv = value as? CollectionValue,
                let v = cv.kk_JSONValue() {
                arr.append(v)
            }
        }
        return arr.isEmpty ? nil : arr
    }
}
