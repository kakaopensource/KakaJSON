//
//  Descriptor.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/7/31.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

/// Must be struct, do not use class
/// Descriptor for layout
protocol Descriptor {}

// MARK: - NominalDescriptor
protocol NominalDescriptor: Descriptor {
    /// Flags describing the context, including its kind and format version
    var flags: ContextDescriptorFlags { get }
    
    /// The parent context, or null if this is a top-level context.
    var parent: RelativeContextPointer { get }
    
    /// The name of the type
    var name: RelativeDirectPointer<CChar> { get set }
    
    /// A pointer to the metadata access function for this type
    var accessFunctionPtr: RelativeDirectPointer<MetadataResponse> { get }
    
    /// A pointer to the field descriptor for the type, if any
    var fields: RelativeDirectPointer<FieldDescriptor> { get set }
    
    associatedtype OffsetType: BinaryInteger
    var fieldOffsetVectorOffset: FieldOffsetPointer<OffsetType> { get }
    
    /// generic info
    var genericContextHeader: TargetTypeGenericContextDescriptorHeader { get }
}

extension NominalDescriptor {
    var isGeneric: Bool { return (flags.value & 0x80) != 0 }
    var genericTypesCount: Int { return Int(genericContextHeader.base.numberOfParams) }
}

// MARK: - ModelDescriptor
protocol ModelDescriptor: NominalDescriptor {
    var numFields: UInt32 { get }
}

extension ModelDescriptor {
    func fieldOffsets(_ type: Any.Type) -> [Int] {
        let ptr = ((type ~>> UnsafePointer<Int>.self) + Int(fieldOffsetVectorOffset.offset))
            .kj_raw ~> OffsetType.self
        return (0..<Int(numFields)).map { Int(ptr[$0]) }
    }
}

// MARK: - Descriptor Inner Data Types
struct ContextDescriptorFlags {
    let value: UInt32
}

struct RelativeContextPointer {
    let offset: Int32
}

struct RelativeDirectPointer <Pointee> {
    var relativeOffset: Int32
    
    mutating func advanced() -> UnsafeMutablePointer<Pointee> {
        let offset = relativeOffset
        return withUnsafeMutablePointer(to: &self) {
            ($0.kj_raw + Int(offset)) ~> Pointee.self
        }
    }
}

struct FieldOffsetPointer <Pointee: BinaryInteger> {
    let offset: UInt32
}

struct MetadataResponse {}

struct TargetTypeGenericContextDescriptorHeader {
    var instantiationCache: Int32
    var defaultInstantiationPattern: Int32
    var base: TargetGenericContextDescriptorHeader
}

struct TargetGenericContextDescriptorHeader {
    var numberOfParams: UInt16
    var numberOfRequirements: UInt16
    var numberOfKeyArguments: UInt16
    var numberOfExtraArguments: UInt16
}
