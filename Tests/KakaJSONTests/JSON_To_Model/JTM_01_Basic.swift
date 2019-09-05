//
//  JTM_01_Basic.swift
//  KakaJSONTest
//
//  Created by MJ Lee on 2019/8/7.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

import XCTest
@testable import KakaJSON

class JTM_01_Basic: XCTestCase {
    struct Cat: Convertible {
        var weight: Double = 0.0
        var name: String = ""
    }
    
    // MARK: - Generic Type
    func testGeneric() {
        let name = "Miaomiao"
        let weight = 6.66
        
        // json can also be NSDictionary\NSMutableDictionary
        let json: [String: Any] = [
            "weight": weight,
            "name": name
        ]
        
        let cat = json.kj.model(Cat.self)
        XCTAssert(cat.name == name)
        XCTAssert(cat.weight == weight)
    }
    
    // MARK: - Any.Type
    func testAny() {
        let name: String = "Miaomiao"
        let weight: Double = 6.66
        
        let json: [String: Any] = [
            "weight": weight,
            "name": name
        ]
        
        let type: Convertible.Type = Cat.self
        let cat = json.kj.model(type: type) as? Cat
        XCTAssert(cat?.name == name)
        XCTAssert(cat?.weight == weight)
    }
    
    // MARK: - json String
    func testJSONString() {
        let name = "Miaomiao"
        let weight = 6.66
        
        // jsonString can also be NSString\NSMutableString
        let jsonString: String = """
        {
            "name": "\(name)",
            "weight": \(weight)
        }
        """
        
        let cat = jsonString.kj.model(Cat.self)
        XCTAssert(cat?.name == name)
        XCTAssert(cat?.weight == weight)
    }
    
    // MARK: - json data
    func testJSONData() {
        let name = "Miaomiao"
        let weight = 6.66
        
        // jsonData can also be NSData\NSMutableData
        let jsonData = """
        {
        "name": "\(name)",
        "weight": \(weight)
        }
        """.data(using: .utf8)!
        
        let cat = jsonData.kj.model(Cat.self)
        XCTAssert(cat?.name == name)
        XCTAssert(cat?.weight == weight)
    }
    
    // MARK: - NSNull
    func testNSNull() {
        struct Cat: Convertible {
            var weight: Double = 0.0
            var name: String = "xx"
            var data: NSNull?
        }
        
        let json: [String: Any] = [
            "name": NSNull(),
            "weight": 6.6,
            "data": NSNull()
        ]
        
        let cat = json.kj.model(Cat.self)
        // convert failed, keep default value
        XCTAssert(cat.name == "xx")
        XCTAssert(cat.weight == 6.6)
        XCTAssert(cat.data == NSNull())
    }
    
    // MARK: - let
    func testLet() {
        struct Cat: Convertible {
            // let of integer type is very restricted in release mode
            // please user `private(set) var` instead of `let`
            private(set) var weight: Double = 0.0
            let name: String = ""
        }
        let name: String = "Miaomiao"
        let weight: Double = 6.66
        
        let json: [String: Any] = [
            "weight": weight,
            "name": name
        ]
        
        let cat = json.kj.model(Cat.self)
        XCTAssert(cat.name == name)
        XCTAssert(cat.weight == weight)
    }
    
    // MARK: - Class Type
    func testClass() {
        class Person: Convertible {
            var name: String = ""
            var age: Int = 0
            required init() {}
        }
        
        class Student: Person {
            var score: Int = 0
            var no: String = ""
        }
        
        let name = "jack"
        let age = 18
        let score = 98
        let no = "9527"
        
        let json: [String: Any] = [
            "name": name,
            "age": age,
            "score": score,
            "no": no
        ]
        
        let student = json.kj.model(Student.self)
        XCTAssert(student.name == name)
        XCTAssert(student.age == age)
        XCTAssert(student.score == score)
        XCTAssert(student.no == no)
    }
    
    // MARK: - NSObject Class Type
    func testNSObjectClass() {
        class Person: NSObject, Convertible {
            var name: String = ""
            var age: Int = 0
            required override init() {}
        }
        
        class Student: Person {
            var score: Int = 0
            var no: String = ""
        }
        
        let name = "jack"
        let age = 18
        let score = 98
        let no = "9527"
        
        let json: [String: Any] = [
            "name": name,
            "age": age,
            "score": score,
            "no": no
        ]
        
        let student = json.kj.model(Student.self)
        XCTAssert(student.name == name)
        XCTAssert(student.age == age)
        XCTAssert(student.score == score)
        XCTAssert(student.no == no)
    }
    
    // MARK: - Convert
    func testConvert() {
        let name = "Miaomiao"
        let weight = 6.66
        
        let json: [String: Any] = [
            "weight": weight,
            "name": name
        ]
        
        var cat = Cat()
        cat.kj_m.convert(from: json)
        XCTAssert(cat.name == name)
        XCTAssert(cat.weight == weight)
        
        let JSONString = """
        {
            "weight": 6.66,
            "name": "Miaomiao"
        }
        """
        
        cat.kj_m.convert(from: JSONString)
        XCTAssert(cat.name == name)
        XCTAssert(cat.weight == weight)
    }
    
    func testCallback1() {
        struct Car: Convertible {
            var name: String = ""
            var age: Int = 0
            
            mutating func kj_willConvertToModel(from json: [String: Any]) {
//                print("Car - kj_willConvertToModel")
            }
            
            mutating func kj_didConvertToModel(from json: [String: Any]) {
//                print("Car - kj_didConvertToModel")
            }
        }
        
        let name = "Benz"
        let age = 100
        let car = ["name": name, "age": age].kj.model(Car.self)
        // Car - kj_willConvertToModel
        // Car - kj_didConvertToModel
        XCTAssert(car.name == name)
        XCTAssert(car.age == age)
    }
    
    func testCallback2() {
        class Person: Convertible {
            var name: String = ""
            var age: Int = 0
            required init() {}
            
            func kj_willConvertToModel(from json: [String: Any]) {
//                print("Person - kj_willConvertToModel")
            }
            
            func kj_didConvertToModel(from json: [String: Any]) {
//                print("Person - kj_didConvertToModel")
            }
        }
        
        class Student: Person {
            var score: Int = 0
            
            override func kj_willConvertToModel(from json: [String: Any]) {
                // call super's implementation if necessary
                super.kj_willConvertToModel(from: json)
                
//                print("Student - kj_willConvertToModel")
            }
            
            override func kj_didConvertToModel(from json: [String: Any]) {
                // call super's implementation if necessary
                super.kj_didConvertToModel(from: json)
                
//                print("Student - kj_didConvertToModel")
            }
        }
        
        let name = "jack"
        let age = 10
        let score = 100
        let student = ["name": name, "age": age, "score": score].kj.model(Student.self)
        // Person - kj_willConvertToModel
        // Student - kj_willConvertToModel
        // Person - kj_didConvertToModel
        // Student - kj_didConvertToModel
        XCTAssert(student.name == name)
        XCTAssert(student.age == age)
        XCTAssert(student.score == score)
    }
    
    static var allTests = [
        "testGeneric": testGeneric,
        "testAny": testAny,
        "testJSONString": testJSONString,
        "testJSONData": testJSONData,
        "testNSNull": testNSNull,
        "testLet": testLet,
        "testClass": testClass,
        "testNSObjectClass": testNSObjectClass,
        "testConvert": testConvert,
        "testCallback1": testCallback1,
        "testCallback2": testCallback2
    ]
}
