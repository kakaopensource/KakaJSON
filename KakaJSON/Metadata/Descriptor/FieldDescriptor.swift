//
//  FieldDescriptor.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/7/31.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

struct FieldDescriptor {
    let mangledTypeName: RelativeDirectPointer<CChar>
    let superclass: RelativeDirectPointer<CChar>
    let _kind : UInt16
    let fieldRecordSize : UInt16
    let numFields : UInt32
    var fieldRecords: FieldList<FieldRecord>
    var kind: FieldDescriptorKind { FieldDescriptorKind(rawValue: _kind)! }
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

struct FieldRecord {
    let flags: Int32
    var _mangledTypeName: RelativeDirectPointer<UInt8>
    var _fieldName: RelativeDirectPointer<UInt8>
    var isVar: Bool { (flags & 0x2) == 0x2 }
    mutating func fieldName() -> String { String(cString: _fieldName.advanced()) }
    mutating func mangledTypeName() -> String { String(cString: _mangledTypeName.advanced()) }
    
    mutating func type(_ genericContext: UnsafeRawPointer?,
                       _ genericArguments: UnsafeRawPointer?) -> Any.Type {
        let typeName = _mangledTypeName.advanced()
        return _getTypeByMangledNameInContext(
                    typeName,
                    nameLength(typeName),
                    genericContext,
                    genericArguments
                )!
    }
    
    func nameLength(_ begin: UnsafeRawPointer) -> UInt {
        var end = begin
        while true {
            let cur = end.load(as: UInt8.self)
            if cur == 0 { break }
            if cur >= 0x1 && cur <= 0x17 {
                end += 4
            } else if cur >= 0x18 && cur <= 0x1F {
                end += MemoryLayout<Int>.size
            }
            end += 1
        }
        return UInt(end - begin)
    }
}
