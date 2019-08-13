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
                model = string._fastModel(t)
            } else if let dict = element as? [String: Any] {
                model = dict._fastModel(t)
            }
            return model
        }
        return arr.isEmpty ? nil : arr
    }
    
    // MARK: - Model -> JSON
    func JSON() -> [[String: Any]]? {
        let arr = base.compactMap { element in
            (element~! as? Convertible)?._JSON()
        }
        return arr.isEmpty ? nil : arr
    }
    
    func JSONString(prettyPrinted: Bool = false) -> String? {
        if let str = JSONSerialization.kk.string(JSON(),
                                                 prettyPrinted: prettyPrinted) {
            return str
        }
        Logger.error("Failed to get JSONString from JSON.")
        return nil
    }
}

extension NSArray {
    func _JSONValue() -> Any? {
        (self as? [Any])?._JSONValue()
    }
}

extension Array {
    func _JSONValue() -> Any? {
        var arr: [Any] = []
        for element in self {
            let value = element~!
            if let v = ValueParser.JSONValue(from: value) {
                arr.append(v)
            } else if let cv = value as? CollectionValue,
                let v = cv._JSONValue() {
                arr.append(v)
            }
        }
        return arr.isEmpty ? nil : arr
    }
}
