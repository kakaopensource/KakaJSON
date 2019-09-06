//
//  MTJ_05_CustomValue.swift
//  KakaJSONTests
//
//  Created by MJ Lee on 2019/8/13.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

import XCTest
@testable import KakaJSON

private let dateFmt: DateFormatter = {
    let fmt = DateFormatter()
    fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return fmt
}()

class MTJ_05_CustomValue: XCTestCase {
    // MARK: - Date
    func testDate() {
        struct Student: Convertible {
            var birthday: Date?
            
            func kj_JSONValue(from modelValue: Any?,
                              _ property: Property) -> Any? {
                if property.name != "birthday" { return modelValue }
                return birthday.flatMap(dateFmt.string)
            }
        }
        
        let time = "2019-08-13 12:52:51"
        let date = dateFmt.date(from: time)
        let student = Student(birthday: date)
        let jsonString = student.kj.JSONString()
        /* {"birthday":"2019-08-13 12:52:51"} */
        XCTAssert(jsonString.contains(time) == true)
    }
    
    static var allTests = [
        "testDate": testDate
    ]
}
