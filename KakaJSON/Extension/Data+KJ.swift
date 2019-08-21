//
//  Data+KJ.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/8/18.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

import Foundation

extension Data: KJCompatible {}
extension NSData: KJCompatible {}

public extension KJ where Base == Data {
    /// JSONObject -> Model
    func model<M: Convertible>(_ type: M.Type) -> M? {
        return model(anyType: type) as? M
    }
    
    /// JSONObject -> Model
    func model(anyType: Any.Type) -> Any? {
        if let json = JSONSerialization.kj_JSON(base, [String: Any].self) {
            return json.kj.model(anyType: anyType)
        }
        Logger.error("Failed to get JSON from JSONData.")
        return nil
    }
    
    /// JSONObjectArray -> ModelArray
    func modelArray<M: Convertible>(_ type: M.Type) -> [M]? {
        return modelArray(anyType: type) as? [M]
    }
    
    /// JSONObjectArray -> ModelArray
    func modelArray(anyType: Any.Type) -> [Any]? {
        if let json = JSONSerialization.kj_JSON(base, [Any].self) {
            return json.kj.modelArray(anyType: anyType)
        }
        Logger.error("Failed to get JSON from JSONData.")
        return nil
    }
}

public extension KJ where Base: NSData {
    /// JSONObject -> Model
    func model<M: Convertible>(_ type: M.Type) -> M? {
        return model(anyType: type) as? M
    }
    
    /// JSONObject -> Model
    func model(anyType: Any.Type) -> Any? {
        return (base as Data).kj.model(anyType: anyType)
    }
    
    /// JSONObjectArray -> ModelArray
    func modelArray<M: Convertible>(_ type: M.Type) -> [M]? {
        return modelArray(anyType: type) as? [M]
    }
    
    /// JSONObjectArray -> ModelArray
    func modelArray(anyType: Any.Type) -> [Any]? {
        return (base as Data).kj.modelArray(anyType: anyType)
    }
}

extension Data {
    func kj_fastModel(_ type: Convertible.Type) -> Convertible? {
        if let json = JSONSerialization.kj_JSON(self, [String: Any].self) {
            return json.kj_fastModel(type)
        }
        Logger.error("Failed to get JSON from JSONData.")
        return nil
    }
}
