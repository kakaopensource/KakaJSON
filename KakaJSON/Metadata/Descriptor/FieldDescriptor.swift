//
//  FieldDescriptor.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/7/31.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

import Foundation

struct FieldRecord {
    let flags: Int32
    var _mangledTypeName: RelativeDirectPointer<UInt8>
    var _fieldName: RelativeDirectPointer<UInt8>
    var isVar: Bool { return (flags & 0x2) == 0x2 }
    mutating func fieldName() -> String { return String(cString: _fieldName.advanced()) }
    mutating func mangledTypeName() -> String { return String(cString: _mangledTypeName.advanced()) }
    
    mutating func type(_ genericContext: UnsafeRawPointer?,
                       _ genericArguments: UnsafeRawPointer?) -> Any.Type {
        let name = _mangledTypeName.advanced()
        return _getTypeByMangledNameInContext(
                    name,
                    nameLength(name),
                    genericContext,
                    genericArguments
                )!
    }
    
    func nameLength(_ begin: UnsafeRawPointer) -> UInt {
        var end = begin
        let size = MemoryLayout<Int>.size
        while true {
            let cur = end.load(as: UInt8.self)
            if cur == 0 { break }
            end += 1
            if cur <= 0x17 {
                end += 4
            } else if cur <= 0x1F {
                end += size
            }
        }
        return UInt(end - begin)
    }
}

struct FieldDescriptor {
    let mangledTypeName: RelativeDirectPointer<CChar>
    let superclass: RelativeDirectPointer<CChar>
    let _kind : UInt16
    let fieldRecordSize : UInt16
    let numFields : UInt32
    var fieldRecords: FieldList<FieldRecord>
    var kind: FieldDescriptorKind { return FieldDescriptorKind(rawValue: _kind)! }
}

enum FieldDescriptorKind: UInt16 {
    case `struct`
    case `class`
    case `enum`
    case multiPayloadEnum
    case `protocol`
    case classProtocol
    case objCProtocol
    case objCClass
}

@_silgen_name("swift_getTypeByMangledNameInContext")
private func _getTypeByMangledNameInContext(
    _ name: UnsafePointer<UInt8>,
    _ nameLength: UInt,
    _ genericContext: UnsafeRawPointer?,
    _ genericArguments: UnsafeRawPointer?)
    -> Any.Type?
