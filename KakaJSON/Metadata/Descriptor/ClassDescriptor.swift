//
//  ClassDescriptor.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/7/31.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

struct ClassDescriptor: ModelDescriptor {
    /// Flags describing the context, including its kind and format version
    let flags: ContextDescriptorFlags
    
    /// The parent context, or null if this is a top-level context.
    let parent: RelativeContextPointer
    
    /// The name of the type
    var name: RelativeDirectPointer<CChar>
    
    /// A pointer to the metadata access function for this type
    let accessFunctionPtr: RelativeDirectPointer<MetadataResponse>
    
    /// A pointer to the field descriptor for the type, if any
    var fields: RelativeDirectPointer<FieldDescriptor>
    
    /// The type of the superclass, expressed as a mangled type name that can refer to the generic arguments of the subclass type
    let superclassType: RelativeDirectPointer<CChar>
    
    /// If this descriptor does not have a resilient superclass, this is the negative size of metadata objects of this class (in words)
    let metadataNegativeSizeInWords: UInt32
    
    /// If this descriptor does not have a resilient superclass, this is the positive size of metadata objects of this class (in words)
    let metadataPositiveSizeInWords: UInt32
    
    /// The number of additional members added by this class to the class metadata
    let numImmediateMembers: UInt32
    
    /// The number of stored properties in the class, not including its superclasses. If there is a field offset vector, this is its length.
    let numFields: UInt32
    
    /// The offset of the field offset vector for this class's stored properties in its metadata, in words. 0 means there is no field offset vector
    let fieldOffsetVectorOffset: FieldOffsetPointer<Int>
    
    let genericContextHeader: TargetTypeGenericContextDescriptorHeader
}
