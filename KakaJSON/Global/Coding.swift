//
//  Coding.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/8/22.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

import Foundation

@discardableResult
public func write(_ value: Any,
                  to file: String,
                  atomically: Bool = true,
                  encoding: String.Encoding = .utf8) -> String? {
    return write(value, to: URL(fileURLWithPath: file), encoding: encoding)
}

@discardableResult
public func write(_ value: Any,
                  to URL: URL,
                  atomically: Bool = true,
                  encoding: String.Encoding = .utf8) -> String?  {
    if URL.isFileURL {
        let dir = (URL.path as NSString).deletingLastPathComponent
        let mgr = FileManager.default
        if !mgr.fileExists(atPath: dir) {
            try? mgr.createDirectory(atPath: dir,
                                     withIntermediateDirectories: true,
                                     attributes: nil)
        }
    }
    let string = Values.JSONString(value)
    try? string?.write(to: URL,
                       atomically: atomically,
                       encoding: .utf8)
    return string
}

public func read<T>(_ type: T.Type,
                    from file: String,
                    encoding: String.Encoding = .utf8) -> T? {
    return read(type,
                from: URL(fileURLWithPath: file),
                encoding: encoding)
}

public func read<T>(_ type: T.Type,
                    from URL: URL,
                    encoding: String.Encoding = .utf8) -> T? {
    guard let data = try? Data(contentsOf: URL) else { return nil }
    
    var value = JSONSerialization.kj_JSON(data, Any.self)
    if value == nil {
        value = String(data: data, encoding: encoding)
    }
    return Values.value(value, T.self) as? T
}
