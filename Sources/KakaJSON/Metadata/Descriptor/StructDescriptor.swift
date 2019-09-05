//
//  StructDescriptor.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/7/31.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

struct StructDescriptor: ModelDescriptor {
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

    /// The number of stored properties in the struct. If there is a field offset vector, this is its length
    let numFields: UInt32
    
    /// The offset of the field offset vector for this struct's stored properties in its metadata, if any. 0 means there is no field offset vector
    let fieldOffsetVectorOffset: FieldOffsetPointer<Int32>
    
    let genericContextHeader: TargetTypeGenericContextDescriptorHeader
}
