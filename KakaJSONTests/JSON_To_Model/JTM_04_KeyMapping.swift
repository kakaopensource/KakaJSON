//
//  JTM_04_KeyMapping.swift
//  KakaJSONTests
//
//  Created by MJ Lee on 2019/8/10.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

class JTM_04_KeyMapping: XCTestCase {
    func testCamelToUnderline() {
        struct SPerson: Convertible {
            var nickName: String = ""
            var mostFavoriteNumber: Int = 0
            var birthday: String = ""
            
            func kk_modelKey(from property: Property) -> ConvertibleKey {
                // `nickName` -> `nick_name`
                return property.name.kk.underlineCased()
            }
        }
        
        let nick_name = "ErHa"
        let most_favorite_number = 666
        let birthday = "2011-10-12"
        
        let JSON: [String: Any] = [
            "nick_name": nick_name,
            "most_favorite_number": most_favorite_number,
            "birthday": birthday
        ]
        
        let student = JSON.kk.model(SPerson.self)
        XCTAssert(student?.nickName == nick_name)
        XCTAssert(student?.mostFavoriteNumber == most_favorite_number)
        XCTAssert(student?.birthday == birthday)
    }
    
    func testUnderlineToCamel() {
        struct SPerson: Convertible {
            var nick_name: String = ""
            var most_favorite_number: Int = 0
            var birthday: String = ""
            
            func kk_modelKey(from property: Property) -> ConvertibleKey {
                // `nick_name` -> `nickName`
                return property.name.kk.camelCased()
            }
        }
        
        let nickName = "ErHa"
        let mostFavoriteNumber = 666
        let birthday = "2011-10-12"
        
        let JSON: [String: Any] = [
            "nickName": nickName,
            "mostFavoriteNumber": mostFavoriteNumber,
            "birthday": birthday
        ]
        
        let student = JSON.kk.model(SPerson.self)
        XCTAssert(student?.nick_name == nickName)
        XCTAssert(student?.most_favorite_number == mostFavoriteNumber)
        XCTAssert(student?.birthday == birthday)
    }
    
    func testClass1() {
        class CPerson: Convertible {
            var name: String = ""
            required init() {}
            
            func kk_modelKey(from property: Property) -> ConvertibleKey {
                property.name == "name" ? "_name_" : property.name
            }
        }
        
        class CStudent: CPerson {
            var score: Int = 0
        }
        
        let personName = "Jack"
        let personJSON: [String: Any] = ["_name_": personName]
        let person = personJSON.kk.model(CPerson.self)
        XCTAssert(person?.name == personName)
        
        let studentName = "Rose"
        let studentScore = 96
        let studentJSON: [String: Any] = ["_name_": studentName, "score": studentScore]
        let student = studentJSON.kk.model(CStudent.self)
        XCTAssert(student?.name == studentName)
        XCTAssert(student?.score == studentScore)
    }
    
    func testClass2() {
        class CPerson: Convertible {
            var name: String = ""
            required init() {}
            
            func kk_modelKey(from property: Property) -> ConvertibleKey {
                property.name == "name" ? "_name_" : property.name
            }
        }
        
        class CStudent: CPerson {
            var score: Int = 0
            
            override func kk_modelKey(from property: Property) -> ConvertibleKey {
                property.name == "score"
                    ? "_score_"
                    : super.kk_modelKey(from: property)
            }
        }
        
        let personName = "Jack"
        let personJSON: [String: Any] = ["_name_": personName]
        let person = personJSON.kk.model(CPerson.self)
        XCTAssert(person?.name == personName)
        
        let studentName = "Rose"
        let studentScore = 96
        let studentJSON: [String: Any] = ["_name_": studentName, "_score_": studentScore]
        let student = studentJSON.kk.model(CStudent.self)
        XCTAssert(student?.name == studentName)
        XCTAssert(student?.score == studentScore)
    }
    
    func testClass3() {
        class CPerson: Convertible {
            var name: String = ""
            required init() {}
            
            func kk_modelKey(from property: Property) -> ConvertibleKey {
                property.name == "name" ? "_name_" : property.name
            }
        }
        
        class CStudent: CPerson {
            var score: Int = 0
            
            override func kk_modelKey(from property: Property) -> ConvertibleKey {
                property.name == "score" ? "_score_" : property.name
            }
        }
        
        let personName = "Jack"
        let personJSON: [String: Any] = ["_name_": personName]
        let person = personJSON.kk.model(CPerson.self)
        XCTAssert(person?.name == personName)
        
        let studentName = "Rose"
        let studentScore = 96
        let studentJSON: [String: Any] = ["name": studentName, "_score_": studentScore]
        let student = studentJSON.kk.model(CStudent.self)
        XCTAssert(student?.name == studentName)
        XCTAssert(student?.score == studentScore)
    }
    
    func testComplex() {
        struct SToy: Convertible {
            var price: Double = 0.0
            var name: String = ""
        }
        
        struct SDog: Convertible {
            var name: String = ""
            var age: Int = 0
            var nickName: String?
            var toy: SToy?
            
            func kk_modelKey(from property: Property) -> ConvertibleKey {
                switch property.name {
                case "toy": return "dog.toy"
                case "name": return "data.1.dog.name"
                case "nickName":
                    return ["nickName", "nick_name", "dog.nickName", "dog.nick_name"]
                default:
                    return property.name
                }
            }
        }
        
        let name = "Larry"
        let age = 5
        let nickName1 = "Jake1"
        let nickName2 = "Jake2"
        let nickName3 = "Jake3"
        let nickName4 = "Jake4"
        let toy = (name: "Bobbi", price: 20.5)
        
        let JSON: [String: Any] = [
            "data": [10, ["dog" : ["name": name]]],
            "age": age,
            "nickName": nickName1,
            "nick_name": nickName2,
            "dog": [
                "nickName": nickName3,
                "nick_name": nickName4,
                "toy": ["name": toy.name, "price": toy.price]
            ]
        ]
        
        let dog = JSON.kk.model(SDog.self)
        XCTAssert(dog?.name == name)
        XCTAssert(dog?.age == age)
        XCTAssert(dog?.nickName == nickName1)
        XCTAssert(dog?.toy?.name == toy.name)
        XCTAssert(dog?.toy?.price == toy.price)
    }
}
