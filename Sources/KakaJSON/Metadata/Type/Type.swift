//
//  Type.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/7/31.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

// MARK: - Type
public protocol Type : AnyObject {
    var name: String { get }
    var type: Any.Type { get }
    var kind: Kind { get }
    var module: String { get }
    var isSystemModule: Bool { get }
}

// MARK: - LayoutType
protocol LayoutType: Type {
    associatedtype InnerLayout: Layout
    var layout: UnsafeMutablePointer<InnerLayout>! { get }
}

extension LayoutType {
    func builtLayout() -> UnsafeMutablePointer<InnerLayout> {
        return type ~>> UnsafeMutablePointer<InnerLayout>.self
    }
}

// MARK: - NominalType
protocol NominalType: Type {
    var genericTypes: [Any.Type]? { get }
}

extension NominalType where Self: LayoutType, InnerLayout: NominalLayout {
    func genenicTypesPtr() -> UnsafeMutablePointer<FieldList<Any.Type>> {
        // get the offset
        let offset = layout.pointee.genericTypeOffset * MemoryLayout<UnsafeRawPointer>.size
        
        // pointer to generic types
        return ((type ~>> UnsafeMutableRawPointer.self) + offset) ~> FieldList<Any.Type>.self
    }
    
    func builtGenericTypes() -> [Any.Type]? {
        // generic judge
        let description = layout.pointee.description
        if !description.pointee.isGeneric { return nil }
        let typesCount = description.pointee.genericTypesCount
        if typesCount <= 0 { return nil }
        
        // pointer to generic types
        if layout.pointee.genericTypeOffset == GenenicTypeOffset.wrong { return nil }
        let ptr = genenicTypesPtr()
        return (0..<typesCount).map { ptr.pointee.item($0) }
    }
}

enum GenenicTypeOffset {
    static let wrong = Int.min
}

// MARK: - PropertyType
protocol PropertyType: NominalType {
    var properties: [Property]? { get }
}

extension PropertyType where Self: LayoutType, InnerLayout: ModelLayout {
    func builtProperties() -> [Property]? {
        let description = layout.pointee.description
        let offsets = description.pointee.fieldOffsets(type)
        if offsets.isEmpty { return nil }
        let fieldDescriptorPtr = description.pointee.fields.advanced()
        let ptr = genenicTypesPtr()
        return (0..<Int(description.pointee.numFields)).map { i -> Property in
            let recordPtr = fieldDescriptorPtr.pointee.fieldRecords.ptr(i)
            return Property(name: recordPtr.pointee.fieldName(),
                            type: recordPtr.pointee.type(layout.pointee.description, ptr),
                            isVar: recordPtr.pointee.isVar,
                            offset: offsets[i],
                            ownerType: type)
        }
    }
}
