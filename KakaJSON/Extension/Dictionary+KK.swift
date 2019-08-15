//
//  Dictionary+KK.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/8/7.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

extension NSDictionary: KKCompatible {}
extension Dictionary: KKGenericCompatible {
    public typealias T = Value
}

public extension KKGeneric where Base == [String: T] {
    // MARK: JSON -> Model
    func model<M: Convertible>(_ type: M.Type) -> M? {
        return model(anyType: type) as? M
    }
    
    func model(anyType: Any.Type) -> Any? {
        guard let t = anyType as? Convertible.Type,
            let mt = Metadata.type(anyType) as? ModelType,
            let _ = mt.properties
            else { return nil }
        return base.kk_fastModel(t)
    }
}

public extension KKGeneric where Base == [NSString: T] {
    // MARK: JSON -> Model
    func model<M: Convertible>(_ type: M.Type) -> M? {
        return model(anyType: type) as? M
    }
    
    func model(anyType: Any.Type) -> Any? {
        return (base as JSONObject).kk.model(anyType: anyType)
    }
}

public extension KK where Base: NSDictionary {
    func model<M: Convertible>(_ type: M.Type) -> M? {
        return (base as? JSONObject)?.kk.model(type)
    }
    
    func model(anyType: Any.Type) -> Any? {
        return (base as? JSONObject)?.kk.model(anyType: anyType)
    }
}

extension Dictionary where Key == String {
    func kk_fastModel(_ type: Convertible.Type) -> Convertible? {
        var model = type.init()
        model.kk_convert(from: self)
        return model
    }
    
    func kk_JSONValue() -> Any? {
        var dict: JSONObject = [:]
        for (key, element) in self {
            let value = element~!
            if let v = Converter.JSONValue(from: value) {
                dict[key] = v
            } else if let cv = value as? CollectionValue,
                let v = cv.kk_JSONValue() {
                dict[key] = v
            }
        }
        return dict.isEmpty ? nil : dict
    }
    
    func kk_value(for modelKey: ModelKey) -> Any? {
        if let key = modelKey as? String {
            return _value(stringKey: key)
        }
        
        let keyArray = modelKey as! [String]
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
            if let dict = value as? JSONObject {
                value = dict[String(subKey)]
                // when nil, end the for-loop
                if value == nil { return nil }
            } else if let array = value as? [Any] {
                guard let index = Int(subKey),
                    index >= 0, index < array.count else { return nil }
                value = array[index]
            }
        }
        return value
    }
}

extension NSDictionary {
    func kk_JSONValue() -> Any? {
        return (self as? JSONObject)?.kk_JSONValue()
    }
    
    func kk_fastModel(_ type: Convertible.Type) -> Convertible? {
        return (self as? JSONObject)?.kk_fastModel(type)
    }
    
    func kk_value(for modelKey: ModelKey) -> Any? {
        return (self as? JSONObject)?.kk_value(for: modelKey)
    }
}
