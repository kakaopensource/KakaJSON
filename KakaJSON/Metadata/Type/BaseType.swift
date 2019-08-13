//
//  BaseType.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/7/30.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

/// Info for type(类型的相关信息)
public class BaseType: Type, CustomStringConvertible {
    public let name: String
    public let type: Any.Type
    public let kind: Kind
    public private(set) var module: String = ""
    public private(set) var isSystemModule: Bool = false
    
    required init(name: String, type: Any.Type, kind: Kind) {
        self.name = name
        self.type = type
        self.kind = kind
        
        build()
    }
    
    func build() {
        switch kind {
        case .optional, .struct, .class, .existential,
             .enum, .objCClassWrapper, .foreignClass:
            let name = String(reflecting: type)
            guard let end = name.firstIndex(of: ".") else { break }
            module = String(name[name.startIndex..<end])
        default: break
        }
        
        isSystemModule = module == "Swift" || module == "__C" || module.isEmpty
    }
    
    public var description: String {
        return "\(name) { kind = \(kind), module = \(module) }"
    }
}
