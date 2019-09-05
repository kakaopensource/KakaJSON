//
//  Convertible.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/8/11.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

import Foundation

// MARK: - Convertible Interface

/// return value type of kj_modelKey
public protocol ModelPropertyKey {}
extension String: ModelPropertyKey {}
extension Array: ModelPropertyKey where Element == String {}

/// return value type of kj_JSONKey
public typealias JSONPropertyKey = String

/// all the models who want to convert should conform to `Convertible`
/// please let struct or class conform to `Convertible`
public protocol Convertible {
    init()
    
    /// Get a key from propertyName when converting JSON to model
    ///
    /// Only call once for every property in every type
    ///
    /// - Parameter property: A property of model
    ///
    /// - Returns: Return a key to get jsonValue for the property
    func kj_modelKey(from property: Property) -> ModelPropertyKey
    
    /// Get a model modelValue from jsonValue when converting JSON to model
    ///
    /// - Parameters:
    ///     - jsonValue: A jsonValue for the property
    ///     - property: A property of model
    ///
    /// - Returns: return `nil` indicates ignore the property,
    /// use the initial value instead.
    /// return `JSONValue` indicates do nothing
    func kj_modelValue(from jsonValue: Any?,
                       _ property: Property) -> Any?
    
    /// model type for Any、AnyObject、Convertible...
    ///
    /// - Parameters:
    ///     - jsonValue: A jsonValue for the property
    ///     - property: A property of model
    func kj_modelType(from jsonValue: Any?,
                      _ property: Property) -> Convertible.Type?
    
    /// call when will begin to convert from JSON to model
    ///
    /// - Parameters:
    ///     - json: A json will be converted to model
    mutating func kj_willConvertToModel(from json: [String: Any])
    
    /// call when did finish converting from JSON to model
    ///
    /// - Parameters:
    ///     - json: A json did be converted to model
    mutating func kj_didConvertToModel(from json: [String: Any])
    
    /// Get a key from propertyName when converting from model to JSON
    ///
    /// Only call once for every property in every type
    ///
    /// - Parameters:
    ///     - property: A property of model
    func kj_JSONKey(from property: Property) -> JSONPropertyKey
    
    /// Get a JSONValue from modelValue when converting from JSON to model
    ///
    /// - Parameters:
    ///     - modelValue: A modelValue for the property
    ///     - property: A property of model
    ///
    /// - Returns: return `nil` indicates ignore the JSONValue.
    /// return `modelValue` indicates do nothing
    func kj_JSONValue(from modelValue: Any?,
                      _ property: Property) -> Any?
    
    /// call when will begin to convert from model to JSON
    func kj_willConvertToJSON()
    
    /// call when did finish converting from model to JSON
    ///
    /// - Parameters:
    ///     - json: A json did be converted from model
    func kj_didConvertToJSON(json: [String: Any])
}

/// default implementation
public extension Convertible {
    func kj_modelKey(from property: Property) -> ModelPropertyKey {
        return ConvertibleConfig.modelKey(from: property, Self.self)
    }
    func kj_modelValue(from jsonValue: Any?,
                       _ property: Property) -> Any? {
        return ConvertibleConfig.modelValue(from: jsonValue, property, Self.self)
    }
    func kj_modelType(from jsonValue: Any?,
                      _ property: Property) -> Convertible.Type? { return nil }
    func kj_willConvertToModel(from json: [String: Any]) {}
    func kj_didConvertToModel(from json: [String: Any]) {}
    
    func kj_JSONKey(from property: Property) -> JSONPropertyKey {
        return ConvertibleConfig.JSONKey(from: property, Self.self)
    }
    func kj_JSONValue(from modelValue: Any?,
                      _ property: Property) -> Any? {
        return ConvertibleConfig.JSONValue(from: modelValue, property, Self.self)
    }
    func kj_willConvertToJSON() {}
    func kj_didConvertToJSON(json: [String: Any]) {}
}

// MARK: - Wrapper for Convertible
public extension Convertible {
    static var kj: ConvertibleKJ<Self>.Type {
        get { return ConvertibleKJ<Self>.self }
        set {}
    }
    var kj: ConvertibleKJ<Self> {
        get { return ConvertibleKJ(self) }
        set {}
    }
    
    /// mutable version of kj
    var kj_m: ConvertibleKJ_M<Self> {
        mutating get { return ConvertibleKJ_M(&self) }
        set {}
    }
}

public struct ConvertibleKJ_M<T: Convertible> {
    var basePtr: UnsafeMutablePointer<T>
    init(_ basePtr: UnsafeMutablePointer<T>) {
        self.basePtr = basePtr
    }
    
    /// JSONData -> Model
    public func convert(from jsonData: Data) {
        basePtr.pointee.kj_convert(from: jsonData)
    }
    
    /// JSONData -> Model
    public func convert(from jsonData: NSData) {
        basePtr.pointee.kj_convert(from: jsonData as Data)
    }
    
    /// JSONString -> Model
    public func convert(from jsonString: String) {
        basePtr.pointee.kj_convert(from: jsonString)
    }
    
    /// JSONString -> Model
    public func convert(from jsonString: NSString) {
        basePtr.pointee.kj_convert(from: jsonString as String)
    }
    
    /// JSONObject -> Model
    public func convert(from json: [String: Any]) {
        basePtr.pointee.kj_convert(from: json)
    }
    
    /// JSONObject -> Model
    public func convert(from json: [NSString: Any]) {
        basePtr.pointee.kj_convert(from: json as [String: Any])
    }
    
    /// JSONObject -> Model 
    public func convert(from json: NSDictionary) {
        basePtr.pointee.kj_convert(from: json as! [String: Any])
    }
}

public struct ConvertibleKJ<T: Convertible> {
    var base: T
    init(_ base: T) {
        self.base = base
    }
    
    /// Model -> JSONObject
    public func JSONObject() -> [String: Any] {
        return base.kj_JSONObject()
    }
    
    /// Model -> JSONString
    public func JSONString(prettyPrinted: Bool = false) -> String {
        return base.kj_JSONString(prettyPrinted: prettyPrinted)
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
    mutating func kj_convert(from jsonData: Data) {
        if let json = JSONSerialization.kj_JSON(jsonData, [String: Any].self) {
            kj_convert(from: json)
            return
        }
        Logger.error("Failed to get JSON from JSONData.")
    }
    
    mutating func kj_convert(from jsonString: String) {
        if let json = JSONSerialization.kj_JSON(jsonString, [String: Any].self) {
            kj_convert(from: json)
            return
        }
        Logger.error("Failed to get JSON from JSONString.")
    }
    
    mutating func kj_convert(from json: [String: Any]) {
        guard let mt = Metadata.type(self) as? ModelType else {
            Logger.warnning("Not a class or struct instance.")
            return
        }
        guard let properties = mt.properties else {
            Logger.warnning("Don't have any property.")
            return
        }
        
        // get data address
        let model = _ptr()
        
        kj_willConvertToModel(from: json)
        
        // enumerate properties
        for property in properties {
            // key filter
            let key = mt.modelKey(from: property.name,
                                  kj_modelKey(from: property))
            
            // value filter
            guard let newValue = kj_modelValue(
                from: json.kj_value(for: key),
                property)~! else { continue }
            
            let propertyType = property.dataType
            // if they are the same type, set value directly
            if Swift.type(of: newValue) == propertyType {
                property.set(newValue, for: model)
                continue
            }
            
            // Model Type have priority
            // it can return subclass object to match superclass type
            if let modelType = kj_modelType(from: newValue, property),
                let value = _modelTypeValue(newValue, modelType, propertyType) {
                property.set(value, for: model)
                continue
            }
            
            // try to convert newValue to propertyType
            guard let value = Values.value(newValue,
                                           propertyType,
                                           property.get(from: model)) else {
                property.set(newValue, for: model)
                continue
            }
            
            property.set(value, for: model)
        }
        
        kj_didConvertToModel(from: json)
    }
    
    private mutating
    func _modelTypeValue(_ jsonValue: Any,
                         _ modelType: Convertible.Type,
                         _ propertyType: Any.Type) -> Any? {
        // don't use `propertyType is XX.Type`
        // because it may be an `Any` type
        if let json = jsonValue as? [Any] {
            let models = json.kj.modelArray(type: modelType)
            if !models.isEmpty {
                return propertyType is NSMutableArray.Type
                    ? NSMutableArray(array: models)
                    : models
            }
        }
        
        if let json = jsonValue as? [String: Any] {
            if let jsonDict = jsonValue as? [String: [String: Any]?] {
                var modelDict = [String: Any]()
                for (k, v) in jsonDict {
                    guard let m = v?.kj.model(type: modelType) else { continue }
                    modelDict[k] = m
                }
                guard modelDict.count > 0 else { return jsonValue }
                
                return propertyType is NSMutableDictionary.Type
                    ? NSMutableDictionary(dictionary: modelDict)
                    : modelDict
            } else {
                return json.kj.model(type: modelType)
            }
        }
        return jsonValue
    }
}

// MARK: - Model -> JSON
extension Convertible {
    func kj_JSONObject() -> [String: Any] {
        var json = [String: Any]()
        guard let mt = Metadata.type(self) as? ModelType else {
            Logger.warnning("Not a class or struct instance.")
            return json
        }
        guard let properties = mt.properties else {
            Logger.warnning("Don't have any property.")
            return json
        }
        
        kj_willConvertToJSON()
        
        // as AnyObject is important! for class if xx is protocol type
        // var model = xx as AnyObject
        var model = self
        
        // get data address
        let ptr = model._ptr()
        
        // get JSON from model
        for property in properties {
            // value filter
            guard let value = kj_JSONValue(
                from: property.get(from: ptr)~!,
                property)~! else { continue }
            
            guard let v = Values.JSONValue(value) else { continue }
            
            // key filter
            json[mt.JSONKey(from: property.name,
                            kj_JSONKey(from: property))] = v
        }
        
        kj_didConvertToJSON(json: json)
        
        return json
    }
    
    func kj_JSONString(prettyPrinted: Bool = false) -> String {
        if let str = JSONSerialization.kj_string(kj_JSONObject() as Any,
                                                 prettyPrinted: prettyPrinted) {
            return str
        }
        Logger.error("Failed to get JSONString from JSON.")
        return ""
    }
}
