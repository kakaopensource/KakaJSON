//
//  KakaJSON.swift
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

// MARK: - JSON -> Model
public func model<M: Convertible>(from JSON: JSONObject?,
                                  _ type: M.Type) -> M? {
    return JSON?.kk.model(type)
}

public func model(from JSON: JSONObject?,
                  anyType: Any.Type) -> Any? {
    return JSON?.kk.model(anyType: anyType)
}

public func model<M: Convertible>(from JSONString: String?,
                                  _ type: M.Type) -> M? {
    return JSONString?.kk.model(type)
}

public func model(from JSONString: String?,
                  anyType: Any.Type) -> Any? {
    return JSONString?.kk.model(anyType: anyType)
}

public func modelArray<M: Convertible>(from JSON: [Any]?,
                                       _ type: M.Type) -> [M]? {
    return JSON?.kk.modelArray(type)
}

public func modelArray(from JSON: [Any]?,
                       anyType: Any.Type) -> [Any?]? {
    return JSON?.kk.modelArray(anyType: anyType)
}

public func modelArray<M: Convertible>(from JSONString: String?,
                                       _ type: M.Type) -> [M]? {
    return JSONString?.kk.modelArray(type)
}

public func modelArray(from JSONString: String?,
                       anyType: Any.Type) -> [Any]? {
    return JSONString?.kk.modelArray(anyType: anyType)
}

// MARK: Model -> JSON
public func JSON<M: Convertible>(from model: M?) -> JSONObject? {
    return model?.kk.JSON()
}

public func JSON(from models: [Any]?) -> JSONArray? {
    return models?.kk.JSON()
}

public func JSONString<M: Convertible>(from model: M?,
                                       prettyPrinted: Bool = false) -> String? {
    return model?.kk.JSONString(prettyPrinted: prettyPrinted)
}

public func JSONString(from models: [Any]?,
                       prettyPrinted: Bool = false) -> String? {
    return models?.kk.JSONString(prettyPrinted: prettyPrinted)
}
