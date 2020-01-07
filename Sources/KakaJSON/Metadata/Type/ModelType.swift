//
//  ModelType.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/8/13.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

import Foundation

public class ModelType: BaseType {
    public internal(set) var properties: [Property]?
    public internal(set) var genericTypes: [Any.Type]?
    private var modelKeysLock = DispatchSemaphore(value: 1)
    private var modelKeys: [String: ModelPropertyKey] = [:]
    private var jsonKeysLock = DispatchSemaphore(value: 1)
    private var jsonKeys: [String: String] = [:]
    
    func modelKey(from propertyName: String,
                  _ createdKey: @autoclosure () -> ModelPropertyKey) -> ModelPropertyKey {
        modelKeysLock.wait()
        defer { modelKeysLock.signal() }
        if let key = modelKeys[propertyName] { return key }

        var resultKey = createdKey()
        if let stringKey = resultKey as? String {
            if stringKey != propertyName {
                resultKey = [stringKey, propertyName]
            }
        } else if var arrayKey = resultKey as? [String] {
            if arrayKey.count == 0 {
                resultKey = propertyName
            } else if arrayKey.last != propertyName {
                arrayKey.append(propertyName)
                resultKey = arrayKey
            }
        }
        modelKeys[propertyName] = resultKey;
        return resultKey
    }
    
    func JSONKey(from propertyName: String,
                 _ createdKey: @autoclosure () -> String) -> String {
        jsonKeysLock.wait()
        defer { jsonKeysLock.signal() }
        if let key = jsonKeys[propertyName] { return key }
        
        let resultKey = createdKey()
        jsonKeys[propertyName] = resultKey
        return resultKey
    }
}
