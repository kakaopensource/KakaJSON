//
//  Dictionary+KK.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/8/7.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

import Foundation

extension NSDictionary: KKCompatible {}
extension Dictionary: KKGenericCompatible {
    public typealias T = Value
}

public extension KKGeneric where Base == [String: T] {
    /// JSONObject -> Model
    func model<M: Convertible>(_ type: M.Type) -> M? {
        return model(anyType: type) as? M
    }
    
    /// JSONObject -> Model
    func model(anyType: Any.Type) -> Any? {
        guard let t = anyType as? Convertible.Type,
            let mt = Metadata.type(anyType) as? ModelType,
            let _ = mt.properties
            else { return nil }
        return base.kk_fastModel(t)
    }
}

public extension KKGeneric where Base == [NSString: T] {
    /// JSONObject -> Model
    func model<M: Convertible>(_ type: M.Type) -> M? {
        return model(anyType: type) as? M
    }
    
    /// JSONObject -> Model
    func model(anyType: Any.Type) -> Any? {
        return (base as [String: Any]).kk.model(anyType: anyType)
    }
}

public extension KK where Base: NSDictionary {
    /// JSONObject -> Model
    func model<M: Convertible>(_ type: M.Type) -> M? {
        return (base as? [String: Any])?.kk.model(type)
    }
    
    /// JSONObject -> Model
    func model(anyType: Any.Type) -> Any? {
        return (base as? [String: Any])?.kk.model(anyType: anyType)
    }
}

extension Dictionary where Key == String {
    func kk_fastModel(_ type: Convertible.Type) -> Convertible? {
        var model: Convertible?
        if let ns = type as? NSObject.Type {
            model = ns.newConvertible()
        } else {
            model = type.init()
        }
        model?.kk_convert(from: self)
        return model
    }
    
    func kk_value(for modelPropertyKey: ModelPropertyKey) -> Any? {
        if let key = modelPropertyKey as? String {
            return _value(stringKey: key)
        }
        
        let keyArray = modelPropertyKey as! [String]
        for key in keyArray {
            if let value = _value(stringKey: key) {
                return value
            }
        }
        return nil
    }
    
    private func _value(stringKey: String) -> Any? {
        let subkeys = stringKey.split(separator: ".")
        var value: Any? = self
        for subKey in subkeys {
            if let dict = value as? [String: Any] {
                value = dict[String(subKey)]
                // when nil, end the for-loop
                if value == nil { return nil }
            } else if let array = value as? [Any] {
                guard let index = Int(subKey),
                    array.indices ~= index else { return nil }
                value = array[index]
            }
        }
        return value
    }
}
