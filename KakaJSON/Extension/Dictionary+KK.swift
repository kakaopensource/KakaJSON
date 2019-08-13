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
    func value(for jsonKey: ConvertibleKey) -> Any? {
        base._value(jsonKey: jsonKey)
    }
    
    // MARK: JSON -> Model
    func model<M: Convertible>(_ type: M.Type) -> M? {
        return model(anyType: type) as? M
    }
    
    func model(anyType: Any.Type) -> Any? {
        guard let t = anyType as? Convertible.Type,
            let mt = Metadata.type(anyType) as? ModelType,
            let _ = mt.properties
            else { return nil }
        return base._fastModel(t)
    }
}

public extension KKGeneric where Base == [NSString: T] {
    func value(for jsonKey: ConvertibleKey) -> Any? {
        (base as [String: Any])._value(jsonKey: jsonKey)
    }
    
    // MARK: JSON -> Model
    func model<M: Convertible>(_ type: M.Type) -> M? {
        return model(anyType: type) as? M
    }
    
    func model(anyType: Any.Type) -> Any? {
        return (base as [String: Any]).kk.model(anyType: anyType)
    }
}

public extension KK where Base: NSDictionary {
    func value(for jsonKey: ConvertibleKey) -> Any? {
        (base as? [String: Any])?._value(jsonKey: jsonKey)
    }
    
    func model<M: Convertible>(_ type: M.Type) -> M? {
        (base as? [String: Any])?.kk.model(type)
    }
    
    func model(anyType: Any.Type) -> Any? {
        (base as? [String: Any])?.kk.model(anyType: anyType)
    }
}

extension Dictionary where Key == String {
    func _fastModel(_ type: Convertible.Type) -> Convertible? {
        var model = type.init()
        model._convert(from: self)
        return model
    }
    
    func _JSONValue() -> Any? {
        var dict: [String: Any] = [:]
        for (key, element) in self {
            let value = element~!
            if let v = ValueParser.JSONValue(from: value) {
                dict[key] = v
            } else if let cv = value as? CollectionValue,
                let v = cv._JSONValue() {
                dict[key] = v
            }
        }
        return dict.isEmpty ? nil : dict
    }
}

extension NSDictionary {
    func _JSONValue() -> Any? {
        (self as? [String: Any])?._JSONValue()
    }
}

private extension Dictionary {
    func _value(stringKey: String) -> Any? {
        let subkeys = stringKey.split(separator: ".")
        var value: Any? = self
        for subKey in subkeys {
            if let dict = value as? [String: Any] {
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
    
    func _value(jsonKey: ConvertibleKey) -> Any? {
        if let key = jsonKey as? String {
            return _value(stringKey: key)
        }
        
        let keyArray = jsonKey as! [String]
        for key in keyArray {
            if let value = _value(stringKey: key) {
                return value
            }
        }
        return nil
    }
}
