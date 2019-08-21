//
//  KJ.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/7/30.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

public struct KJ<Base> {
    let base: Base
    init(_ base: Base) {
        self.base = base
    }
}

// MARK: - protocol for normal types
public protocol KJCompatible {}
public extension KJCompatible {
    static var kj: KJ<Self>.Type {
        get { return KJ<Self>.self }
        set {}
    }
    var kj: KJ<Self> {
        get { return KJ(self) }
        set {}
    }
}

// MARK: - protocol for types with a generic parameter
public struct KJGeneric<Base, T> {
    let base: Base
    init(_ base: Base) {
        self.base = base
    }
}
public protocol KJGenericCompatible {
    associatedtype T
}
public extension KJGenericCompatible {
    static var kj: KJGeneric<Self, T>.Type {
        get { return KJGeneric<Self, T>.self }
        set {}
    }
    var kj: KJGeneric<Self, T> {
        get { return KJGeneric(self) }
        set {}
    }
}

// MARK: - protocol for types with two generic parameter2
public struct KJGeneric2<Base, T1, T2> {
    let base: Base
    init(_ base: Base) {
        self.base = base
    }
}
public protocol KJGenericCompatible2 {
    associatedtype T1
    associatedtype T2
}
public extension KJGenericCompatible2 {
    static var kj: KJGeneric2<Self, T1, T2>.Type {
        get { return KJGeneric2<Self, T1, T2>.self }
        set {}
    }
    var kj: KJGeneric2<Self, T1, T2> {
        get { return KJGeneric2(self) }
        set {}
    }
}
