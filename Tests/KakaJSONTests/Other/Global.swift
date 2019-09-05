//
//  Global.swift
//  KakaJSONTests
//
//  Created by MJ Lee on 2019/8/11.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

import XCTest
@testable import KakaJSON

class Global: XCTestCase {
    struct Cat: Convertible {
        var age: Int = 0
        var name: String = ""
    }
    
    func testMetadata() {
        struct Cat {
            var age: Int = 0
            let name: String = ""
        }
        
        guard let type = Metadata.type(Cat.self) as? ModelType,
            let properties = type.properties else { return }
        
        for property in properties {
            print(property.name,
                  property.type,
                  property.isVar,
                  property.ownerType,
                  property.offset)
            // age Int true Cat 0
            // name String false Cat 8
        }
    }
    
    func testValue() {
        let string1 = "1565922866"
        XCTAssert(Values.int(string1) == 1565922866)
        XCTAssert(Values.double(string1) == 1565922866)
        XCTAssert(Values.cgFloat(string1) == 1565922866)
        let date = Values.value(string1, of: Date.self)
        XCTAssert(date?.timeIntervalSince1970 == 1565922866)
        
        let string2 = "true"
        XCTAssert(Values.bool(string2) == true)
        XCTAssert(Values.int(string2) == 1)
    }
    
    func testJSON_To_Model() {
        let name = "Miaomiao"
        let age = 26
        let json: [String: Any] = [
            "age": age,
            "name": name
        ]
        let jsonString = """
        {
            "name": "\(name)",
            "age": \(age)
        }
        """
        let jsonData = jsonString.data(using: .utf8)!
        
        let cat1 = model(from: json, Cat.self)
        XCTAssert(cat1.name == name)
        XCTAssert(cat1.age == age)
        
        let cat2 = model(from: json, type: Cat.self) as? Cat
        XCTAssert(cat2?.name == name)
        XCTAssert(cat2?.age == age)
        
        let cat3 = model(from: jsonString, Cat.self)
        XCTAssert(cat3?.name == name)
        XCTAssert(cat3?.age == age)
        
        let cat4 = model(from: jsonString, type: Cat.self) as? Cat
        XCTAssert(cat4?.name == name)
        XCTAssert(cat4?.age == age)
        
        let cat5 = model(from: jsonData, Cat.self)
        XCTAssert(cat5?.name == name)
        XCTAssert(cat5?.age == age)
        
        let cat6 = model(from: jsonData, type: Cat.self) as? Cat
        XCTAssert(cat6?.name == name)
        XCTAssert(cat6?.age == age)
    }
    
    func testModel_To_JSON() {
        let cat = Cat(age: 26, name: "Miaomiao")
        
        let json = JSONObject(from: cat)
        XCTAssert(json["name"] as? String == cat.name)
        XCTAssert(json["age"] as? Int == cat.age)
        
        let jsonString = JSONString(from: cat)
        XCTAssert(jsonString.contains("\"age\":\(cat.age)") == true)
        XCTAssert(jsonString.contains("\"name\":\"\(cat.name)\"") == true)
    }
    
    func testJSONArray_To_ModelArray() {
        let name = "Miaomiao"
        let age = 26
        let json: [[String: Any]] = [
            ["age": age, "name": name],
            ["age": age, "name": name]
        ]
        let jsonString = """
        [
            {"name": "\(name)", "age": \(age)},
            {"name": "\(name)", "age": \(age)}
        ]
        """
        
        let cats1 = modelArray(from: json, Cat.self)
        XCTAssert(cats1[0].name == name)
        XCTAssert(cats1[0].age == age)
        XCTAssert(cats1[1].name == name)
        XCTAssert(cats1[1].age == age)
        
        let cats2 = modelArray(from: json, type: Cat.self) as? [Cat]
        XCTAssert(cats2?[0].name == name)
        XCTAssert(cats2?[0].age == age)
        XCTAssert(cats2?[1].name == name)
        XCTAssert(cats2?[1].age == age)
        
        let cats3 = modelArray(from: jsonString, Cat.self)
        XCTAssert(cats3[0].name == name)
        XCTAssert(cats3[0].age == age)
        XCTAssert(cats3[1].name == name)
        XCTAssert(cats3[1].age == age)
        
        let cats4 = modelArray(from: jsonString, type: Cat.self) as? [Cat]
        XCTAssert(cats4?[0].name == name)
        XCTAssert(cats4?[0].age == age)
        XCTAssert(cats4?[1].name == name)
        XCTAssert(cats4?[1].age == age)
    }
    
    func testModelArray_To_JSONArray() {
        let cat = Cat(age: 26, name: "Miaomiao")
        let cats = [cat, cat]
        
        let json = JSONObjectArray(from: cats)
        XCTAssert(json[0]["name"] as? String == cat.name)
        XCTAssert(json[0]["age"] as? Int == cat.age)
        XCTAssert(json[1]["name"] as? String == cat.name)
        XCTAssert(json[1]["age"] as? Int == cat.age)
        
        let jsonString = JSONString(from: cats)
        XCTAssert(jsonString.contains("[") == true)
        XCTAssert(jsonString.contains("},{") == true)
        XCTAssert(jsonString.contains("]") == true)
        XCTAssert(jsonString.contains("\"age\":\(cat.age)") == true)
        XCTAssert(jsonString.contains("\"name\":\"\(cat.name)\"") == true)
    }
    
    static var allTests = [
        "testMetadata": testMetadata,
        "testValue": testValue,
        "testJSON_To_Model": testJSON_To_Model,
        "testModel_To_JSON": testModel_To_JSON,
        "testJSONArray_To_ModelArray": testJSONArray_To_ModelArray,
        "testModelArray_To_JSONArray": testModelArray_To_JSONArray
    ]
}

let timeIntevalInt: Int = 1565922866
let timeIntevalFloat = Float(timeIntevalInt)
let timeInteval = Double(timeIntevalInt)
let timeIntevalString = "\(timeIntevalInt)"
let time = Date(timeIntervalSince1970: timeInteval)
// 16 decimals
let longDoubleString = "0.1234567890123456"
let longDouble: Double = 0.1234567890123456
// 8 decimals
let longFloatString = "0.12345678"
let longFloat: Float = 0.12345678
// 39 decimals
let longDecimalString = "0.123456789012345678901234567890123456789"
var longDecimal = Decimal(string: longDecimalString)!
var longDecimalNumber = NSDecimalNumber(string: longDecimalString)

func checkModelToJSon<M: Equatable & Convertible>(_ type: M.Type) {
    // create model
    let model = type.init()
    // get JSONString from model
    let jsonString = model.kj.JSONString()
    
    // check JSON and JSONString
    let modelFromJsonString = jsonString.kj.model(type: type) as? M
    XCTAssert(model == modelFromJsonString)
    
    // prevent from 66.6499999999999998
    XCTAssert(jsonString.contains("99999") == false)
    // prevent from 66.6600000000000001
    XCTAssert(jsonString.contains("00000") == false)
}

/// note
/*
protocol Runnable {}
class Dog: Runnable {}

print("--------section0--------")
print(Runnable.self is Runnable.Type) // false

print("--------section1--------")
let dog1: Dog = Dog()
print(dog1 as? Runnable) // success
print(dog1 is Runnable) // true
print(dog1 as? Dog) // success
print(dog1 is Dog) // true

print("--------section2--------")
let dog2 = Dog.self
print(dog2 as? Runnable.Type) // success
print(dog2 is Runnable.Type) // true
print(dog2 as? Dog.Type) // success
print(dog2 is Dog.Type) // true

print("--------section3--------")
let dog3: dog?? = Dog()
print(dog3 as? Runnable) // success
print(dog3 is Runnable) // true
print(dog3 as? Dog) // success
print(dog3 is Dog) // true

print("--------section4--------")
let dog4: dog?? = nil
print(dog4 as? Runnable) // nil
print(dog4 is Runnable) // false
print(dog4 as? Dog) // nil
print(dog4 is Dog) // false

print("--------section5--------")
let dog5 = dog??.self
print(dog5 as? Runnable.Type) // nil
print(dog5 is Runnable.Type) // false
print(dog5 as? Dog.Type) // nil
print(dog5 is Dog.Type) // false

print("--------section6--------")
let dog6: Dog = Dog()
print(dog6 as? Runnable???) // success
print(dog6 is Runnable???) // false
print(dog6 as? dog??) // success
print(dog6 is dog??) // false

print("--------section7--------")
let dog7 = Dog.self
print(dog7 as? Runnable???.Type) // nil
print(dog7 is Runnable???.Type) // false
print(dog7 as? dog??.Type) // nil
print(dog7 is dog??.Type) // false
 */

/*
class Runnable {}
class Dog: Runnable {}

print("--------section0--------")
print(Runnable.self is Runnable.Type) // true

print("--------section1--------")
let dog1: Dog = Dog()
print(dog1 as? Runnable) // success
print(dog1 is Runnable) // true
print(dog1 as? Dog) // success
print(dog1 is Dog) // true

print("--------section2--------")
let dog2 = Dog.self
print(dog2 as? Runnable.Type) // success
print(dog2 is Runnable.Type) // true
print(dog2 as? Dog.Type) // success
print(dog2 is Dog.Type) // true

print("--------section3--------")
let dog3: dog?? = Dog()
print(dog3 as? Runnable) // success
print(dog3 is Runnable) // true
print(dog3 as? Dog) // success
print(dog3 is Dog) // true

print("--------section4--------")
let dog4: dog?? = nil
print(dog4 as? Runnable) // nil
print(dog4 is Runnable) // false
print(dog4 as? Dog) // nil
print(dog4 is Dog) // false

print("--------section5--------")
let dog5 = dog??.self
print(dog5 as? Runnable.Type) // nil
print(dog5 is Runnable.Type) // false
print(dog5 as? Dog.Type) // nil
print(dog5 is Dog.Type) // false

print("--------section6--------")
let dog6: Dog = Dog()
print(dog6 as? Runnable???) // success
print(dog6 is Runnable???) // false
print(dog6 as? dog??) // success
print(dog6 is dog??) // false

print("--------section7--------")
let dog7 = Dog.self
print(dog7 as? Runnable???.Type) // nil
print(dog7 is Runnable???.Type) // false
print(dog7 as? dog??.Type) // nil
print(dog7 is dog??.Type) // false
 */

/*
let array: [Int?] = [1, nil, 2]
print(array as? [Any]) // success
print(array as? [Int]) // nil
 */
