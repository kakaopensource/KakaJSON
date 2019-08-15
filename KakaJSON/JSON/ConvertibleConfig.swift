//
//  ConvertibleConfig.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/8/15.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

public typealias ModelKeyConfig = (Property) -> ModelPropertyKey
public typealias ModelValueConfig = (Any?, Property) -> Any?
public typealias JSONKeyConfig = (Property) -> JSONPropertyKey
public typealias JSONValueConfig = (Any?, Property) -> Any?

public class ConvertibleConfig {
    private static let lock = DispatchSemaphore(value: 1)
    public class Item {
        public internal(set) var modelKey: ModelKeyConfig?
        public internal(set) var modelValue: ModelValueConfig?
        public internal(set) var jsonKey: JSONKeyConfig?
        public internal(set) var jsonValue: JSONValueConfig?
        init() {}
        init(modelKey: @escaping ModelKeyConfig) { self.modelKey = modelKey }
        init(modelValue: @escaping ModelValueConfig) { self.modelValue = modelValue }
        init(jsonKey: @escaping JSONKeyConfig) { self.jsonKey = jsonKey }
        init(jsonValue: @escaping JSONValueConfig) { self.jsonValue = jsonValue }
    }
    
    private static let global: Item = Item()
    private static var items: [TypeKey: Item] = [:]
    
    public static func modelKey(_ type: Convertible.Type,
                                property: Property) -> ModelPropertyKey {
        lock.wait()
        defer { lock.signal() }
        
        if let fn = items[typeKey(type)]?.modelKey {
            return fn(property)
        }
        
        let mt = Metadata.type(type)
        if var classMt = mt as? ClassType {
            while let superMt = classMt.super {
                if let fn = items[typeKey(superMt.type)]?.modelKey {
                    return fn(property)
                }
                classMt = superMt
            }
        }
        
        if let fn = global.modelKey { return fn(property) }
        return property.name
    }
    
    public static func modelValue(_ type: Convertible.Type,
                                  jsonValue: Any?,
                                  property: Property) -> Any? {
        lock.wait()
        defer { lock.signal() }
        
        if let fn = items[typeKey(type)]?.modelValue {
            return fn(jsonValue, property)
        }
        
        let mt = Metadata.type(type)
        if var classMt = mt as? ClassType {
            while let superMt = classMt.super {
                if let fn = items[typeKey(superMt.type)]?.modelValue {
                    return fn(jsonValue, property)
                }
                classMt = superMt
            }
        }
        
        if let fn = global.modelValue { return fn(jsonValue, property) }
        return jsonValue
    }
    
    public static func JSONKey(_ type: Convertible.Type,
                               property: Property) -> JSONPropertyKey {
        lock.wait()
        defer { lock.signal() }
        
        if let fn = items[typeKey(type)]?.jsonKey {
            return fn(property)
        }
        
        let mt = Metadata.type(type)
        if var classMt = mt as? ClassType {
            while let superMt = classMt.super {
                if let fn = items[typeKey(superMt.type)]?.jsonKey {
                    return fn(property)
                }
                classMt = superMt
            }
        }
        
        if let fn = global.jsonKey { return fn(property) }
        return property.name
    }
    
    public static func JSONValue(_ type: Convertible.Type,
                                 modelValue: Any?,
                                 property: Property) -> Any? {
        lock.wait()
        defer { lock.signal() }
        
        if let fn = items[typeKey(type)]?.jsonValue {
            return fn(modelValue, property)
        }
        
        let mt = Metadata.type(type)
        if var classMt = mt as? ClassType {
            while let superMt = classMt.super {
                if let fn = items[typeKey(superMt.type)]?.jsonValue {
                    return fn(modelValue, property)
                }
                classMt = superMt
            }
        }
        
        if let fn = global.modelValue { return fn(modelValue, property) }
        return modelValue
    }
    
    public static func setModelKey(for types: [Convertible.Type] = [],
                                   _ modelKey: @escaping ModelKeyConfig) {
        lock.wait()
        defer { lock.signal() }
        
        // clear model key cache
        Metadata.modelTypes.forEach { $0.clearModelKeys() }
        
        if types.count == 0 {
            global.modelKey = modelKey
            return
        }
        
        for type in types {
            let key = typeKey(type)
            if let item = items[key] {
                item.modelKey = modelKey
                continue
            }
            items[key] = Item(modelKey: modelKey)
        }
    }
    
    public static func setModelValue(for types: [Convertible.Type] = [],
                                     modelValue: @escaping ModelValueConfig) {
        lock.wait()
        defer { lock.signal() }
        
        if types.count == 0 {
            global.modelValue = modelValue
            return
        }
        
        for type in types {
            let key = typeKey(type)
            if let item = items[key] {
                item.modelValue = modelValue
                continue
            }
            items[key] = Item(modelValue: modelValue)
        }
    }
    
    public static func setJSONKey(for types: [Convertible.Type] = [],
                                  jsonKey: @escaping JSONKeyConfig) {
        lock.wait()
        defer { lock.signal() }
        
        // clear JSON key cache
        Metadata.modelTypes.forEach { $0.clearJSONKeys() }
        
        if types.count == 0 {
            global.jsonKey = jsonKey
            return
        }
        
        for type in types {
            let key = typeKey(type)
            if let item = items[key] {
                item.jsonKey = jsonKey
                continue
            }
            items[key] = Item(jsonKey: jsonKey)
        }
    }
    
    public static func setJSONValue(for types: [Convertible.Type] = [],
                                    jsonValue: @escaping JSONValueConfig) {
        lock.wait()
        defer { lock.signal() }
        
        if types.count == 0 {
            global.jsonValue = jsonValue
            return
        }
        
        for type in types {
            let key = typeKey(type)
            if let item = items[key] {
                item.jsonValue = jsonValue
                continue
            }
            items[key] = Item(jsonValue: jsonValue)
        }
    }
}
