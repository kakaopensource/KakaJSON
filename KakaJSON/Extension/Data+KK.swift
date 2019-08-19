//
//  Data+KK.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/8/18.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

import Foundation

extension Data: KKCompatible {}
extension NSData: KKCompatible {}

public extension KK where Base == Data {
    // MARK: - JSON -> Model
    func model<M: Convertible>(_ type: M.Type) -> M? {
        return model(anyType: type) as? M
    }
    
    func model(anyType: Any.Type) -> Any? {
        if let json = JSONSerialization.kk_JSON(base, [String: Any].self) {
            return json.kk.model(anyType: anyType)
        }
        Logger.error("Failed to get JSON from JSONData.")
        return nil
    }
    
    func modelArray<M: Convertible>(_ type: M.Type) -> [M]? {
        return modelArray(anyType: type) as? [M]
    }
    
    func modelArray(anyType: Any.Type) -> [Any]? {
        if let json = JSONSerialization.kk_JSON(base, [Any].self) {
            return json.kk.modelArray(anyType: anyType)
        }
        Logger.error("Failed to get JSON from JSONData.")
        return nil
    }
}

public extension KK where Base: NSData {
    // MARK: - JSON -> Model
    func model<M: Convertible>(_ type: M.Type) -> M? {
        return model(anyType: type) as? M
    }
    
    func model(anyType: Any.Type) -> Any? {
        return (base as Data).kk.model(anyType: anyType)
    }
    
    func modelArray<M: Convertible>(_ type: M.Type) -> [M]? {
        return modelArray(anyType: type) as? [M]
    }
    
    func modelArray(anyType: Any.Type) -> [Any]? {
        return (base as Data).kk.modelArray(anyType: anyType)
    }
}

extension Data {
    func kk_fastModel(_ type: Convertible.Type) -> Convertible? {
        if let json = JSONSerialization.kk_JSON(self, [String: Any].self) {
            return json.kk_fastModel(type)
        }
        Logger.error("Failed to get JSON from JSONData.")
        return nil
    }
}
