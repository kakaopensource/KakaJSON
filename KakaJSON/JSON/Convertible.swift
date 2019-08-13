//
//  Convertible.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/8/11.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

// MARK: - Convertible Interface
public protocol Convertible {
    init()
    
    /// Get a key from propertyName when converting from JSON to model
    ///
    /// Only call once for every property of every type
    func kk_modelKey(from property: Property) -> ConvertibleKey
    
    /// Get a model modelValue from JSONValue when converting from JSON to model
    ///
    /// - Returns: return `nil` indicates ignore the property,
    /// use the initial value instead.
    /// return `JSONValue` indicates do nothing
    func kk_modelValue(from JSONValue: Any?,
                       property: Property) -> Any?
    
    /// model type for Any、AnyObject、Convertible...
    func kk_modelType(from JSONValue: Any?,
                      property: Property) -> Convertible.Type?
    
    /// call when will begin to convert from JSON to model
    mutating func kk_willConvertToModel(from JSON: [String: Any])
    
    /// call when did finish converting from JSON to model
    mutating func kk_didConvertToModel(from JSON: [String: Any])
    
    /// Get a key from propertyName when converting from model to JSON
    ///
    /// Only call once for every property of every type
    func kk_JSONKey(from property: Property) -> String
    
    /// Get a JSONValue from modelValue when converting from JSON to model
    ///
    /// - Returns: return `nil` indicates ignore the JSONValue.
    /// return `modelValue` indicates do nothing
    func kk_JSONValue(from modelValue: Any?,
                      property: Property) -> Any?
    
    /// call when will begin to convert from model to JSON
    func kk_willConvertToJSON()
    
    /// call when did finish converting from model to JSON
    func kk_didConvertToJSON(JSON: [String: Any]?)
}

public protocol ConvertibleKey {}
extension String: ConvertibleKey {}
extension Array: ConvertibleKey where Element == String {}

public extension Convertible {
    func kk_modelKey(from property: Property) -> ConvertibleKey {
        property.name
    }
    func kk_modelValue(from JSONValue: Any?,
                       property: Property) -> Any? { JSONValue }
    func kk_modelType(from JSONValue: Any?,
                      property: Property) -> Convertible.Type? { nil }
    func kk_willConvertToModel(from JSON: [String: Any]) {}
    func kk_didConvertToModel(from JSON: [String: Any]) {}
    
    func kk_JSONKey(from property: Property) -> String {
        property.name
    }
    func kk_JSONValue(from modelValue: Any?,
                      property: Property) -> Any? { modelValue }
    func kk_willConvertToJSON() {}
    func kk_didConvertToJSON(JSON: [String: Any]?) {}
}

// MARK: - Wrapper for Convertible
public extension Convertible {
    static var kk: ConvertibleKK<Self>.Type {
        get { ConvertibleKK<Self>.self }
        set {}
    }
    var kk: ConvertibleKK<Self> {
        get { ConvertibleKK(self) }
        set {}
    }
    
    /// mutable version
    var kk_m: ConvertibleKK_M<Self> {
        mutating get { ConvertibleKK_M(&self) }
        set {}
    }
}

public struct ConvertibleKK_M<T: Convertible> {
    var basePtr: UnsafeMutablePointer<T>
    init(_ basePtr: UnsafeMutablePointer<T>) {
        self.basePtr = basePtr
    }
    
    public func convert(from JSONString: String?) {
        basePtr.pointee._convert(from: JSONString)
    }
    
    public func convert(from JSON: [String: Any]?) {
        basePtr.pointee._convert(from: JSON)
    }
}

public struct ConvertibleKK<T: Convertible> {
    var base: T
    init(_ base: T) {
        self.base = base
    }
    
    public func JSON() -> [String: Any]? {
        return base._JSON()
    }
    
    public func JSONString(prettyPrinted: Bool = false) -> String? {
        return base._JSONString(prettyPrinted: prettyPrinted)
    }
}

private extension Convertible {
    /// get the ponter of model
    mutating func _ptr() -> UnsafeMutableRawPointer {
        return (Metadata.type(self)!.kind == .struct)
            ? withUnsafeMutablePointer(to: &self) { UnsafeMutableRawPointer($0) }
            : self ~>> UnsafeMutableRawPointer.self
    }
}

// MARK: - JSON -> Model
extension Convertible {
    mutating func _convert(from JSONString: String?) {
        if let JSON = JSONSerialization.kk.JSON(JSONString, [String: Any].self) {
            _convert(from: JSON)
            return
        }
        Logger.error("Failed to get JSON from JSONString.")
    }
    
    mutating func _convert(from JSON: [String: Any]?) {
        guard let dict = JSON,
            let mt = Metadata.type(self) as? ModelType,
            let properties = mt.properties else { return }
        
        // get data address
        let model = _ptr()
        
        kk_willConvertToModel(from: dict)
        
        // enumerate properties
        for property in properties {
            // key filter
            let key = mt.modelKey(from: property.name,
                                  kk_modelKey(from: property))
            
            // value filter
            guard let newValue = kk_modelValue(
                from: dict.kk.value(for: key)~!,
                property: property)~! else { continue }
            
            let propertyType = property.dataType
            // if they are the same type, set value directly
            if Swift.type(of: newValue) == propertyType {
                property.set(newValue, for: model)
                continue
            }
            
            // Model Type have priority
            // it can return subclass object to match superclass type
            if let modelType = kk_modelType(from: newValue, property: property),
                let value = _modelTypeValue(newValue, modelType, property.dataType) {
                property.set(value, for: model)
                continue
            }
            
            guard let value = ValueParser.modelValue(from: newValue,
                                                propertyType)~! else { continue }
            property.set(value, for: model)
        }
        
        kk_didConvertToModel(from: dict)
    }
    
    private mutating
    func _modelTypeValue(_ JSONValue: Any,
                         _ modelType: Any.Type,
                         _ propertyType: Any.Type) -> Any? {
        if let JSON = JSONValue as? [Any],
            let models = JSON.kk.modelArray(anyType: modelType) {
            return propertyType is NSMutableArray.Type
                ? NSMutableArray(array: models)
                : models
        }
        
        if let JSON = JSONValue as? [String: Any] {
            if let JSONDict = JSONValue as? [String: [String: Any]?] {
                var modelDict = [String: Any]()
                for (k, v) in JSONDict {
                    guard let m = v?.kk.model(anyType: modelType) else { continue }
                    modelDict[k] = m
                }
                guard modelDict.count > 0 else { return nil }
                
                return propertyType is NSMutableDictionary.Type
                    ? NSMutableDictionary(dictionary: modelDict)
                    : modelDict
            } else {
                return JSON.kk.model(anyType: modelType)
            }
        }
        
        return nil
    }
}

// MARK: - Model -> JSON
extension Convertible {
    func _JSON() -> [String: Any]? {
        guard let mt = Metadata.type(self) as? ModelType,
            let properties = mt.properties
            else { return nil }
        
        kk_willConvertToJSON()
        
        // as AnyObject is important! for class if xx is protocol type
        // var model = xx as AnyObject
        var model = self
        
        // get data address
        let ptr = model._ptr()
        
        // get JSON from model
        var JSON = [String: Any]()
        for property in properties {
            // value filter
            guard let value = kk_JSONValue(
                from: property.get(from: ptr)~!,
                property: property)~! else { continue }
            
            guard let v = ValueParser.JSONValue(from: value)~! else { continue }
            
            // key filter
            JSON[mt.JSONKey(from: property.name,
                            kk_JSONKey(from: property))] = v
        }
        
        kk_didConvertToJSON(JSON: JSON.isEmpty ? nil : JSON)
        
        return JSON
    }
    
    func _JSONString(prettyPrinted: Bool = false) -> String? {
        if let str = JSONSerialization.kk.string(_JSON(),
                                                 prettyPrinted: prettyPrinted) {
            return str
        }
        Logger.error("Failed to get JSONString from JSON.")
        return nil
    }
}
