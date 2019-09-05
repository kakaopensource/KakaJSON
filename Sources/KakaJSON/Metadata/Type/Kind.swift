//
//  Kind.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/7/30.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

public enum Kind {
    // MARK: - cases
    
    case `class`
    /// e.g. Int、String
    case `struct`
    /// e.g. MemoryLayout<T>
    case `enum`
    /// e.g. Optional<T>、T?
    case optional
    /// Such as a Core Foundation class, e.g. CFArray
    case foreignClass
    /// A type whose value is not exposed in the metadata system
    case opaque
    case tuple
    /// A monomorphic function, e.g. () -> Void
    case function
    /// An existential type, e.g. protocol
    case existential
    /// A metatype
    case metatype
    /// An ObjC class wrapper, e.g. NSString
    case objCClassWrapper
    /// An existential metatype
    case existentialMetatype
    /// A heap-allocated local variable using statically-generated metadata
    case heapLocalVariable
    case heapArray
    /// A heap-allocated local variable using runtime-instantiated metadata.
    case heapGenericLocalVariable
    /// A native error object.
    case errorObject
    
    // MARK: - Some flags
    /// Non-type metadata kinds have this bit set
    private static let nonType: UInt = 0x400
    /// Non-heap metadata kinds have this bit set
    private static let nonHeap: UInt = 0x200
    /*
     The above two flags are negative because the "class" kind has to be zero, and class metadata is both type and heap metadata.
     */
    /// Runtime-private metadata has this bit set. The compiler must not statically generate metadata objects with these kinds, and external tools should not rely on the stability of these values or the precise binary layout of their associated data structures
    private static let runtimePrivate: UInt = 0x100
    private static let runtimePrivate_nonHeap = runtimePrivate | nonHeap
    private static let runtimePrivate_nonType = runtimePrivate | nonType
    
    // MARK: - initialization
    
    /// 获得Any.Type对应的MetadataKind
    init(_ type: Any.Type) {
        let kind = (type ~>> UnsafePointer<UInt>.self).pointee
        
        switch kind {
        case 0 | Kind.nonHeap, 1: self = .struct
        case 1 | Kind.nonHeap, 2: self = .enum
        case 2 | Kind.nonHeap, 3: self = .optional
        case 3 | Kind.nonHeap: self = .foreignClass
            
        case 0 | Kind.runtimePrivate_nonHeap, 8: self = .opaque
        case 1 | Kind.runtimePrivate_nonHeap, 9: self = .tuple
        case 2 | Kind.runtimePrivate_nonHeap, 10: self = .function
        case 3 | Kind.runtimePrivate_nonHeap, 12: self = .existential
        case 4 | Kind.runtimePrivate_nonHeap, 13: self = .metatype
        case 5 | Kind.runtimePrivate_nonHeap, 14: self = .objCClassWrapper
        case 6 | Kind.runtimePrivate_nonHeap, 15: self = .existentialMetatype
            
        case 0 | Kind.nonType, 64: self = .heapLocalVariable
        case 0 | Kind.runtimePrivate_nonType: self = .heapGenericLocalVariable
        case 1 | Kind.runtimePrivate_nonType: self = .errorObject
            
        case 65: self = .heapArray
            
        case 0: fallthrough
        default: self = .class
        }
    }
}
