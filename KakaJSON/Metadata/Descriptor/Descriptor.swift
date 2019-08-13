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
    var isGeneric: Bool { (flags.value & 0x80) != 0 }
    var genericTypesCount: Int { Int(genericContextHeader.base.numberOfParams) }
}

// MARK: - ModelDescriptor
protocol ModelDescriptor: NominalDescriptor {
    var numFields: UInt32 { get }
}

extension ModelDescriptor {
    func fieldOffsets(_ type: Any.Type) -> [Int] {
        let ptr = ((type ~>> UnsafePointer<Int>.self) + Int(fieldOffsetVectorOffset.offset))
            .kk.raw ~> OffsetType.self
        return (0..<Int(numFields)).map { Int(ptr[$0]) }
    }
}

// MARK: - Descriptor Inner Data Types
struct ContextDescriptorFlags: CustomStringConvertible {
    let value: UInt32
    var description: String { "\(value)" }
}

struct RelativeContextPointer: CustomStringConvertible {
    let offset: Int32
    var description: String { "\(offset)" }
}

struct RelativeDirectPointer <Pointee>: CustomStringConvertible {
    var relativeOffset: Int32
    
    mutating func advanced() -> UnsafeMutablePointer<Pointee> {
        let offset = relativeOffset
        return withUnsafeMutablePointer(to: &self) {
            ($0.kk.raw + Int(offset)) ~> Pointee.self
        }
    }
    
    var description: String { "\(relativeOffset)" }
}

struct FieldOffsetPointer <Pointee: BinaryInteger>: CustomStringConvertible {
    let offset: UInt32
    var description: String { "\(offset)" }
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
