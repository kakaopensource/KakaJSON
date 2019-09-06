//
//  EnumDescriptor.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/7/31.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

struct EnumDescriptor: NominalDescriptor {
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

    /// The number of non-empty cases in the enum are in the low 24 bits; the offset of the payload size in the metadata record in words, if any, is stored in the high 8 bits
    let numPayloadCasesAndPayloadSizeOffset: UInt32

    /// The number of empty cases in the enum
    let numEmptyCases: UInt32
    
    let fieldOffsetVectorOffset: FieldOffsetPointer<Int32>
    
    let genericContextHeader: TargetTypeGenericContextDescriptorHeader
}
