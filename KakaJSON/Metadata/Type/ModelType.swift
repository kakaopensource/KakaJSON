//
//  ModelType.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/8/13.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

public class ModelType: BaseType {
    public internal(set) var properties: [Property]?
    public internal(set) var genericTypes: [Any.Type]?
    private let modelKeyLock = DispatchSemaphore(value: 1)
    private var modelKeys: [String: ConvertibleKey] = [:]
    private let JSONKeyLock = DispatchSemaphore(value: 1)
    private var JSONKeys: [String: String] = [:]
    
    func modelKey(from propertyName: String,
                  _ createdKey: @autoclosure () -> ConvertibleKey) -> ConvertibleKey {
        if let key = modelKeys[propertyName] { return key }
        
        modelKeyLock.wait()
        defer { modelKeyLock.signal() }
        if let key = modelKeys[propertyName] { return key }

        let resultKey = createdKey()
        modelKeys[propertyName] = resultKey
        return resultKey
    }
    
    func JSONKey(from propertyName: String,
                 _ createdKey: @autoclosure () -> String) -> String {
        if let key = JSONKeys[propertyName] { return key }
        
        JSONKeyLock.wait()
        defer { JSONKeyLock.signal() }
        if let key = JSONKeys[propertyName] { return key }
        
        let resultKey = createdKey()
        JSONKeys[propertyName] = resultKey
        return resultKey
    }
}
