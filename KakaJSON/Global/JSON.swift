//
//  JSON.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/8/2.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

/*
 Reference:
 0. https://github.com/apple/swift/blob/master/docs/ABI/TypeMetadata.rst
 1. https://github.com/apple/swift/blob/master/include/swift/ABI/MetadataKind.def
 2. https://github.com/apple/swift/blob/master/include/swift/ABI/Metadata.h
 3. https://github.com/apple/swift/blob/master/include/swift/ABI/MetadataValues.h
 4. https://github.com/apple/swift/blob/master/utils/dtrace/runtime.d
 5. https://github.com/apple/swift/blob/master/include/swift/Reflection/Records.h
 */

// MARK: Model -> JSON
public func JSONObject<M: Convertible>(from model: M?) -> [String: Any]? {
    return model?.kj_JSONObject()
}

public func JSONObjectArray<M: Convertible>(from models: [M]?) -> [[String: Any]]? {
    return models?.kj.JSONObjectArray()
}

public func JSONArray(from value: [Any]?) -> [Any]? {
    return value.kj_JSON() as? [Any]
}

public func JSON(from value: Any?) -> Any? {
    return value.kj_JSON()
}

public func JSONString(from value: Any?,
                       prettyPrinted: Bool = false) -> String? {
    return value.kj_JSONString()
}
