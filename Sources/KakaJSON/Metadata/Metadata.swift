//
//  Metadata.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/8/4.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

import Foundation

public struct Metadata {
    private static let typeLock = NSRecursiveLock()
    private static var types = [TypeKey: BaseType]()
    
    public static func type(_ type: Any.Type) -> BaseType? {
        typeLock.lock()
        defer { typeLock.unlock() }
        
        // get from cache
        let key = typeKey(type)
        if let mt = types[key] { return mt }
        
        // name
        let name = String(describing: type)
        if name == "Swift._SwiftObject"
            || name == "NSObject"
            || name == "_TtCs12_SwiftObject" { return nil }
        
        // type judge
        var mtt: BaseType.Type
        let kind = Kind(type)
        switch kind {
        case .class: mtt = ClassType.self
        case .struct: mtt = StructType.self
        case .enum: mtt = EnumType.self
        case .optional: mtt = OptionalType.self
        case .objCClassWrapper: mtt = ObjCClassType.self
        case .foreignClass: mtt = ForeignClassType.self
        case .tuple: mtt = TupleType.self
        case .function: mtt = FunctionType.self
        case .existential: mtt = ProtocolType.self
        case .metatype: mtt = MetaType.self
        default: mtt = BaseType.self
        }
        
        // ceate and put it into cache
        let mt = mtt.init(name: name, type: type, kind: kind)
        types[key] = mt
        return mt
    }
    
    public static func type(_ obj: Any) -> BaseType? {
        return type(Swift.type(of: obj))
    }
}
