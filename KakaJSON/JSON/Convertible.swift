//
//  Convertible.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/8/11.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

// MARK: - Types
public typealias JSONObject = [String: Any]
public typealias JSONArray = [[String: Any]]

// MARK: - Convertible Interface
public protocol ModelKey {}
extension String: ModelKey {}
extension Array: ModelKey where Element == String {}

public typealias JSONKey = String

public protocol Convertible {
    init()
    
    /// Get a key from propertyName when converting from JSON to model
    ///
    /// Only call once for every property of every type
    func kk_modelKey(from property: Property) -> ModelKey
    
    /// Get a model modelValue from jsonValue when converting from JSON to model
    ///
    /// - Returns: return `nil` indicates ignore the property,
    /// use the initial value instead.
    /// return `JSONValue` indicates do nothing
    func kk_modelValue(from jsonValue: Any?,
                       property: Property) -> Any?
    
    /// model type for Any、AnyObject、Convertible...
    func kk_modelType(from jsonValue: Any?,
                      property: Property) -> Convertible.Type?
    
    /// call when will begin to convert from JSON to model
    mutating func kk_willConvertToModel(from json: JSONObject)
    
    /// call when did finish converting from JSON to model
    mutating func kk_didConvertToModel(from json: JSONObject)
    
    /// Get a key from propertyName when converting from model to JSON
    ///
    /// Only call once for every property of every type
    func kk_JSONKey(from property: Property) -> JSONKey
    
    /// Get a JSONValue from modelValue when converting from JSON to model
    ///
    /// - Returns: return `nil` indicates ignore the JSONValue.
    /// return `modelValue` indicates do nothing
    func kk_JSONValue(from modelValue: Any?,
                      property: Property) -> Any?
    
    /// call when will begin to convert from model to JSON
    func kk_willConvertToJSON()
    
    /// call when did finish converting from model to JSON
    func kk_didConvertToJSON(json: JSONObject?)
}

public extension Convertible {
    func kk_modelKey(from property: Property) -> ModelKey {
        return property.name
    }
    func kk_modelValue(from jsonValue: Any?,
                       property: Property) -> Any? { return jsonValue }
    func kk_modelType(from jsonValue: Any?,
                      property: Property) -> Convertible.Type? { return nil }
    func kk_willConvertToModel(from json: JSONObject) {}
    func kk_didConvertToModel(from json: JSONObject) {}
    
    func kk_JSONKey(from property: Property) -> JSONKey {
        return property.name
    }
    func kk_JSONValue(from modelValue: Any?,
                      property: Property) -> Any? { return modelValue }
    func kk_willConvertToJSON() {}
    func kk_didConvertToJSON(json: JSONObject?) {}
}

// MARK: - Wrapper for Convertible
public extension Convertible {
    static var kk: ConvertibleKK<Self>.Type {
        get { return ConvertibleKK<Self>.self }
        set {}
    }
    var kk: ConvertibleKK<Self> {
        get { return ConvertibleKK(self) }
        set {}
    }
    
    /// mutable version
    var kk_m: ConvertibleKK_M<Self> {
        mutating get { return ConvertibleKK_M(&self) }
        set {}
    }
}

public struct ConvertibleKK_M<T: Convertible> {
    var basePtr: UnsafeMutablePointer<T>
    init(_ basePtr: UnsafeMutablePointer<T>) {
        self.basePtr = basePtr
    }
    
    public func convert(from jsonString: String?) {
        basePtr.pointee.kk_convert(from: jsonString)
    }
    
    public func convert(from json: JSONObject?) {
        basePtr.pointee.kk_convert(from: json)
    }
}

public struct ConvertibleKK<T: Convertible> {
    var base: T
    init(_ base: T) {
        self.base = base
    }
    
    public func JSON() -> JSONObject? {
        return base.kk_JSON()
    }
    
    public func JSONString(prettyPrinted: Bool = false) -> String? {
        return base.kk_JSONString(prettyPrinted: prettyPrinted)
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
    mutating func kk_convert(from jsonString: String?) {
        if let json = JSONSerialization.kk_JSON(jsonString, JSONObject.self) {
            kk_convert(from: json)
            return
        }
        Logger.error("Failed to get JSON from JSONString.")
    }
    
    mutating func kk_convert(from json: JSONObject?) {
        guard let dict = json,
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
                from: dict.kk_value(for: key)~!,
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
            
            guard let value = Converter.modelValue(from: newValue,
                                                   propertyType)~! else { continue }
            
            property.set(value, for: model)
        }
        
        kk_didConvertToModel(from: dict)
    }
    
    private mutating
    func _modelTypeValue(_ jsonValue: Any,
                         _ modelType: Any.Type,
                         _ propertyType: Any.Type) -> Any? {
        // don't use `propertyType is XX.Type`
        // because it may be an `Any` type
        if let json = jsonValue as? [Any],
            let models = json.kk.modelArray(anyType: modelType) {
            return propertyType is NSMutableArray.Type
                ? NSMutableArray(array: models)
                : models
        }
        
        if let json = jsonValue as? JSONObject {
            if let jsonDict = jsonValue as? [String: JSONObject?] {
                var modelDict = JSONObject()
                for (k, v) in jsonDict {
                    guard let m = v?.kk.model(anyType: modelType) else { continue }
                    modelDict[k] = m
                }
                guard modelDict.count > 0 else { return nil }
                
                return propertyType is NSMutableDictionary.Type
                    ? NSMutableDictionary(dictionary: modelDict)
                    : modelDict
            } else {
                return json.kk.model(anyType: modelType)
            }
        }
        // return nil when in other case
        return nil
    }
}

// MARK: - Model -> JSON
extension Convertible {
    func kk_JSON() -> JSONObject? {
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
        var json = JSONObject()
        for property in properties {
            // value filter
            guard let value = kk_JSONValue(
                from: property.get(from: ptr)~!,
                property: property)~! else { continue }
            
            guard let v = Converter.JSONValue(from: value)~! else { continue }
            
            // key filter
            json[mt.JSONKey(from: property.name,
                            kk_JSONKey(from: property))] = v
        }
        
        kk_didConvertToJSON(json: json.isEmpty ? nil : json)
        
        return json
    }
    
    func kk_JSONString(prettyPrinted: Bool = false) -> String? {
        if let str = JSONSerialization.kk_string(kk_JSON(),
                                                 prettyPrinted: prettyPrinted) {
            return str
        }
        Logger.error("Failed to get JSONString from JSON.")
        return nil
    }
}
