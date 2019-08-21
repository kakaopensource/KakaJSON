//
//  ClassLayout.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/7/31.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

struct ClassLayout: ModelLayout {
    let kind: UnsafeRawPointer
    let superclass: Any.Type
    
    /// The cache data is used for certain dynamic lookups; it is owned by the runtime and generally needs to interoperate with Objective-C's use
    let runtimeReserved0: UInt
    let runtimeReserved1: UInt
    
    /// The data pointer is used for out-of-line metadata and is generally opaque, except that the compiler sets the low bit in order to indicate that this is a Swift metatype and therefore that the type metadata header is present
    let rodata: UInt
    
    /// Swift-specific class flags
    let flags: UInt32
    
    /// The address point of instances of this type
    let instanceAddressPoint: UInt32

    /// The required size of instances of this type. 'InstanceAddressPoint' bytes go before the address point; 'InstanceSize - InstanceAddressPoint' bytes go after it
    let instanceSize: UInt32

    /// The alignment mask of the address point of instances of this type
    let instanceAlignMask: UInt16

    /// Reserved for runtime use
    let reserved: UInt16

    /// The total size of the class object, including prefix and suffix extents
    let classSize: UInt32

    /// The offset of the address point within the class object
    let classAddressPoint: UInt32

    // Description is by far the most likely field for a client to try to access directly, so we force access to go through accessors
    /// An out-of-line Swift-specific description of the type, or null if this is an artificial subclass.  We currently provide no supported mechanism for making a non-artificial subclass dynamically
    var description: UnsafeMutablePointer<ClassDescriptor>
    
    /// A function for destroying instance variables, used to clean up after an early return from a constructor. If null, no clean up will be performed and all ivars must be trivial
    let iVarDestroyer: UnsafeRawPointer
    
    var genericTypeOffset: Int {
        let descriptor = description.pointee
        // don't have resilient superclass
        if (0x4000 & flags) == 0 {
            return (flags & 0x800) == 0
            ? Int(descriptor.metadataPositiveSizeInWords - descriptor.numImmediateMembers)
            : -Int(descriptor.metadataNegativeSizeInWords)
        }
        return GenenicTypeOffset.wrong
    }
}
