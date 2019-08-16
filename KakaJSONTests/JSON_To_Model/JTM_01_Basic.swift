//
//  JTM_01_Basic.swift
//  KakaJSONTest
//
//  Created by MJ Lee on 2019/8/7.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

class JTM_01_Basic: XCTestCase {
    struct Cat: Convertible {
        var weight: Double = 0.0
        var name: String = ""
    }
    
    // MARK: - Generic Type
    func testGeneric() {
        let name = "Miaomiao"
        let weight = 6.66
        
        // json can be NSDictionary\NSMutableDictionary
        let json: [String: Any] = [
            "weight": weight,
            "name": name
        ]
        
        let cat = json.kk.model(Cat.self)
        XCTAssert(cat?.name == name)
        XCTAssert(cat?.weight == weight)
    }
    
    // MARK: - Any.Type
    func testAny() {
        let name: String = "Miaomiao"
        let weight: Double = 6.66
        
        let json: [String: Any] = [
            "weight": weight,
            "name": name
        ]
        
        let type: Any.Type = Cat.self
        let cat = json.kk.model(anyType: type) as? Cat
        XCTAssert(cat?.name == name)
        XCTAssert(cat?.weight == weight)
    }
    
    // MARK: - json String
    func testJSONString() {
        let name = "Miaomiao"
        let weight = 6.66
        
        // NSString\NSMutableString
        let JSONString: String = """
        {
            "name": "\(name)",
            "weight": \(weight)
        }
        """
        
        let cat = JSONString.kk.model(Cat.self)
        XCTAssert(cat?.name == name)
        XCTAssert(cat?.weight == weight)
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
        
        let student = json.kk.model(Student.self)
        XCTAssert(student?.name == name)
        XCTAssert(student?.age == age)
        XCTAssert(student?.score == score)
        XCTAssert(student?.no == no)
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
        
        let student = json.kk.model(Student.self)
        XCTAssert(student?.name == name)
        XCTAssert(student?.age == age)
        XCTAssert(student?.score == score)
        XCTAssert(student?.no == no)
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
        cat.kk_m.convert(from: json)
        XCTAssert(cat.name == name)
        XCTAssert(cat.weight == weight)
        
        let JSONString = """
        {
            "weight": 6.66,
            "name": "Miaomiao"
        }
        """
        
        cat.kk_m.convert(from: JSONString)
        XCTAssert(cat.name == name)
        XCTAssert(cat.weight == weight)
    }
    
    func testCallback1() {
        struct Car: Convertible {
            var name: String = ""
            var age: Int = 0
            
            mutating func kk_willConvertToModel(from json: JSONObject) {
                print("Car - kk_willConvertToModel")
            }
            
            mutating func kk_didConvertToModel(from json: JSONObject) {
                print("Car - kk_didConvertToModel")
            }
        }
        
        let name = "Benz"
        let age = 100
        let car = ["name": name, "age": age].kk.model(Car.self)
        // Car - kk_willConvertToModel
        // Car - kk_didConvertToModel
        XCTAssert(car?.name == name)
        XCTAssert(car?.age == age)
    }
    
    func testCallback2() {
        class Person: Convertible {
            var name: String = ""
            var age: Int = 0
            required init() {}
            
            func kk_willConvertToModel(from json: JSONObject) {
                print("Person - kk_willConvertToModel")
            }
            
            func kk_didConvertToModel(from json: JSONObject) {
                print("Person - kk_didConvertToModel")
            }
        }
        
        class Student: Person {
            var score: Int = 0
            
            override func kk_willConvertToModel(from json: JSONObject) {
                // call super's implementation if necessary
                super.kk_willConvertToModel(from: json)
                
                print("Student - kk_willConvertToModel")
            }
            
            override func kk_didConvertToModel(from json: JSONObject) {
                // call super's implementation if necessary
                super.kk_didConvertToModel(from: json)
                
                print("Student - kk_didConvertToModel")
            }
        }
        
        let name = "jack"
        let age = 10
        let score = 100
        let student = ["name": name, "age": age, "score": score].kk.model(Student.self)
        // Person - kk_willConvertToModel
        // Student - kk_willConvertToModel
        // Person - kk_didConvertToModel
        // Student - kk_didConvertToModel
        XCTAssert(student?.name == name)
        XCTAssert(student?.age == age)
        XCTAssert(student?.score == score)
    }
}
