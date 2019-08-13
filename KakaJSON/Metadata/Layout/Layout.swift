//
//  Layout.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/7/31.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

/// Must be struct, do not use class
/// Memory layout for metadata
protocol Layout {
    // Only valid for non-class metadata
    var kind: UnsafeRawPointer { get }
}

protocol NominalLayout: Layout {
    associatedtype DescriptorType: NominalDescriptor
    var description: UnsafeMutablePointer<DescriptorType> { get }
    var genericTypeOffset: Int { get }
}

extension NominalLayout {
    var genericTypeOffset: Int { return 2 }
}

protocol ModelLayout: NominalLayout where DescriptorType: ModelDescriptor  {}
