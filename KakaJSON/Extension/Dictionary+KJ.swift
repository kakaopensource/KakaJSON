//
//  Dictionary+KJ.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/8/7.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

import Foundation

extension NSDictionary: KJCompatible {}
extension Dictionary: KJGenericCompatible {
    public typealias T = Value
}

public extension KJGeneric where Base == [String: T] {
    /// JSONObject -> Model
    func model<M: Convertible>(_ type: M.Type) -> M {
        return model(type: type) as! M
    }
    
    /// JSONObject -> Model
    func model(type: Convertible.Type) -> Convertible {
        return base.kj_fastModel(type)
    }
}

public extension KJGeneric where Base == [NSString: T] {
    /// JSONObject -> Model
    func model<M: Convertible>(_ type: M.Type) -> M {
        return (base as [String: Any]).kj.model(type)
    }
    
    /// JSONObject -> Model
    func model(type: Convertible.Type) -> Convertible {
        return (base as [String: Any]).kj.model(type: type)
    }
}

public extension KJ where Base: NSDictionary {
    /// JSONObject -> Model
    func model<M: Convertible>(_ type: M.Type) -> M? {
        return (base as? [String: Any])?.kj.model(type)
    }
    
    /// JSONObject -> Model
    func model(type: Convertible.Type) -> Convertible? {
        return (base as? [String: Any])?.kj.model(type: type)
    }
}

extension Dictionary where Key == String {
    func kj_fastModel(_ type: Convertible.Type) -> Convertible {
        var model: Convertible
        if let ns = type as? NSObject.Type {
            model = ns.newConvertible()
        } else {
            model = type.init()
        }
        model.kj_convert(from: self)
        return model
    }
    
    func kj_value(for modelPropertyKey: ModelPropertyKey) -> Any? {
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
        if let value = self[stringKey] {
            return value
        }

        let subkeys = stringKey.split(separator: ".")
        var value: Any? = self
        for subKey in subkeys {
            if let dict = value as? [String: Any] {
                value = dict[String(subKey)]
                // when nil, end the for-loop
                if value == nil { return nil }
            } else if let array = value as? [Any] {
                guard let index = Int(subKey),
                    case array.indices = index else { return nil }
                value = array[index]
            } else {
                break
            }
        }
        return value
    }
}
