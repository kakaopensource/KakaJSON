//
//  Pointer+KK.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/8/1.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

extension UnsafePointer: KKGenericCompatible {
    public typealias T = Pointee
}
extension KKGeneric where Base == UnsafePointer<T> {
    var raw: UnsafeRawPointer {
        UnsafeRawPointer(base)
    }
    var mutable: UnsafeMutablePointer<T> {
        UnsafeMutablePointer(mutating: base)
    }
}

extension UnsafeMutablePointer: KKGenericCompatible {
    public typealias T = Pointee
}
extension KKGeneric where Base == UnsafeMutablePointer<T> {
    var raw: UnsafeMutableRawPointer {
        UnsafeMutableRawPointer(base)
    }
    
    var immutable: UnsafePointer<T> {
        UnsafePointer(base)
    }
}

extension UnsafeRawPointer: KKCompatible {}
extension KK where Base == UnsafeRawPointer {
    var mutable: UnsafeMutableRawPointer {
        UnsafeMutableRawPointer(mutating: base)
    }
}
extension UnsafeRawPointer {
    static func ~><T>(ptr: UnsafeRawPointer, type: T.Type) -> UnsafePointer<T> {
        ptr.assumingMemoryBound(to: type)
    }
}

extension UnsafeMutableRawPointer: KKCompatible {}
extension KK where Base == UnsafeMutableRawPointer {
    var immutable: UnsafeRawPointer {
        UnsafeRawPointer(base)
    }
    
    func set(_ value: Any, _ type: Any.Type) {
        typeProxy(type)._set(value, base)
    }
    
    func get(_ type: Any.Type) -> Any {
        typeProxy(type)._get(base)
    }
}
extension UnsafeMutableRawPointer {
    static func ~><T>(ptr: UnsafeMutableRawPointer, type: T.Type) -> UnsafeMutablePointer<T> {
        ptr.assumingMemoryBound(to: type)
    }
}

private extension TypeProxy {
    static func _set(_ value: Any, _ ptr: UnsafeMutableRawPointer) {
        guard let v = value as? Self else { return }
        (ptr ~> self).pointee = v
    }
    
    static func _get(_ ptr: UnsafeMutableRawPointer) -> Any {
        (ptr ~> self).pointee
    }
}

infix operator ~>> : MultiplicationPrecedence
func ~>> <T1, T2>(type1: T1, type2: T2.Type) -> T2 {
    unsafeBitCast(type1, to: type2)
}

infix operator ~> : MultiplicationPrecedence
