//
//  TypeProxy.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/8/13.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

protocol TypeProxy {}

extension TypeProxy {
    static func `is`(_ value: Any) -> Bool {
        value is Self
    }
    
    static func `is`(_ type: Any.Type) -> Bool {
        type is Self.Type
    }
    
    static func `as`(_ value: Any) -> Self? {
        value as? Self
    }
    
    static func `as`(_ type: Any.Type) -> Self.Type? {
        type as? Self.Type
    }
}

func typeProxy(_ type: Any.Type) -> TypeProxy.Type {
    // Any.Type(8 bytes) * 2 == Protocol.Type(16 bytes)
    return (type, Any.self)  ~>> TypeProxy.Type.self
}
