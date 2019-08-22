//
//  Coding.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/8/22.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

import Foundation

@discardableResult
public func write(_ value: Any?,
                  to file: String?,
                  atomically: Bool = true,
                  encoding: String.Encoding = .utf8) -> String? {
    guard let path = file else { return nil }
    return write(value, to: URL(fileURLWithPath: path), encoding: encoding)
}

@discardableResult
public func write(_ value: Any?,
                  to URL: URL?,
                  atomically: Bool = true,
                  encoding: String.Encoding = .utf8) -> String?  {
    guard let url = URL else { return nil }
    if url.isFileURL {
        let dir = (url.path as NSString).deletingLastPathComponent
        let mgr = FileManager.default
        if !mgr.fileExists(atPath: dir) {
            try? mgr.createDirectory(atPath: dir,
                                     withIntermediateDirectories: true,
                                     attributes: nil)
        }
    }
    let string = value.kj_JSONString()
    try? string?.write(to: url,
                       atomically: atomically,
                       encoding: .utf8)
    return string
}

public func read<T>(_ type: T.Type,
                    from file: String?,
                    encoding: String.Encoding = .utf8) -> T? {
    guard let path = file else { return nil }
    return read(type,
                from: URL(fileURLWithPath: path),
                encoding: encoding)
}

public func read<T>(_ type: T.Type,
                    from URL: URL?,
                    encoding: String.Encoding = .utf8) -> T? {
    guard let url = URL else { return nil }
    guard let data = try? Data(contentsOf: url) else { return nil }
    
    var value = JSONSerialization.kj_JSON(data, Any.self)
    if value == nil {
        value = String(data: data, encoding: encoding)
    }
    return value.kj_value(T.self) as? T
}
