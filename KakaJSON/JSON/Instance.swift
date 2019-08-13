//
//  Instance.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/8/1.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

public struct Instance {
    public static func new<T>(_ type: T.Type) -> T? {
        let mt = Metadata.type(type)
        if let structMt = mt as? StructType {
            let ptr = UnsafeMutableRawPointer.allocate(byteCount: structMt.size,
                                                       alignment: structMt.alignment)
            defer { ptr.deallocate() }
            return (ptr ~> type).pointee
        } else if let classMt = mt as? ClassType {
            // Support class inherit from Foundation classes
            if let cls = type as? NSObject.Type {
                return cls.new() as? T
            }
            guard let ptr = _swift_allocObject(type ~>> UnsafeRawPointer.self,
                                              Int32(classMt.instanceSize),
                                              Int32(classMt.instanceAlignMask)) else {
                Logger.error("Failed to new class instance.")
                return nil
            }
            defer { _swift_release(ptr) }
            if classMt.propertyOffset > 0 {
                let mallocSize = malloc_size(ptr ~>> UnsafeRawPointer.self)
                (ptr ~>> UnsafeMutableRawPointer.self + classMt.propertyOffset)
                    .initializeMemory(as: UInt8.self,
                                      repeating: 0,
                                      count: mallocSize - classMt.propertyOffset)
            }
            return ptr ~>> type
        }
        Logger.warnning("Failed to new \(type) instance. Only can new struct or class instance.")
        return nil
    }
    
    public static func retainCount(of object: AnyObject) -> Int {
        _swift_retainCount(object ~>> UnsafeRawPointer.self) - 1
    }
    
    public static func unownedRetainCount(of object: AnyObject) -> Int {
        _swift_unownedRetainCount(object ~>> UnsafeRawPointer.self) - 1
    }
    
    public static func weakRetainCount(of object: AnyObject) -> Int {
        _swift_weakRetainCount(object ~>> UnsafeRawPointer.self) - 1
    }
}

extension NSObject {
    static func new() -> NSObject {
        return self.init()
    }
}

@_silgen_name("swift_allocObject")
private func _swift_allocObject(
    _ metadata: UnsafeRawPointer?,
    _ requiredSize: Int32,
    _ requiredAlignmentMask: Int32) ->  UnsafeRawPointer?

@_silgen_name("swift_release")
private func _swift_release(_ object: UnsafeRawPointer?)

@_silgen_name("swift_retainCount")
private func _swift_retainCount(_ object: UnsafeRawPointer?) -> Int

@_silgen_name("swift_unownedRetainCount")
private func _swift_unownedRetainCount(_ object: UnsafeRawPointer?) -> Int

@_silgen_name("swift_weakRetainCount")
private func _swift_weakRetainCount(_ object: UnsafeRawPointer?) -> Int
