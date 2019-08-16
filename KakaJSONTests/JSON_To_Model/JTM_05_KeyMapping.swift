//
//  JTM_05_KeyMapping.swift
//  KakaJSONTests
//
//  Created by MJ Lee on 2019/8/10.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

class JTM_05_KeyMapping: XCTestCase {
    func testSimple() {
        struct Person: Convertible {
            var nickName: String = ""
            var mostFavoriteNumber: Int = 0
            var birthday: String = ""
            
            func kk_modelKey(from property: Property) -> ModelPropertyKey {
                switch property.name {
                case "nickName": return "nick_name"
                case "mostFavoriteNumber": return "most_favorite_number"
                default: return property.name
                }
            }
        }
        
        let nick_name = "ErHa"
        let most_favorite_number = 666
        let birthday = "2011-10-12"
        
        let json: [String: Any] = [
            "nick_name": nick_name,
            "most_favorite_number": most_favorite_number,
            "birthday": birthday
        ]
        
        let student = json.kk.model(Person.self)
        XCTAssert(student?.nickName == nick_name)
        XCTAssert(student?.mostFavoriteNumber == most_favorite_number)
        XCTAssert(student?.birthday == birthday)
    }
    
    func testCamelToUnderline() {
        struct Person: Convertible {
            var nickName: String = ""
            var mostFavoriteNumber: Int = 0
            var birthday: String = ""
            
            func kk_modelKey(from property: Property) -> ModelPropertyKey {
                // `nickName` -> `nick_name`
                return property.name.kk.underlineCased()
            }
        }
        
        let nick_name = "ErHa"
        let most_favorite_number = 666
        let birthday = "2011-10-12"
        
        let json: [String: Any] = [
            "nick_name": nick_name,
            "most_favorite_number": most_favorite_number,
            "birthday": birthday
        ]
        
        let student = json.kk.model(Person.self)
        XCTAssert(student?.nickName == nick_name)
        XCTAssert(student?.mostFavoriteNumber == most_favorite_number)
        XCTAssert(student?.birthday == birthday)
    }
    
    func testUnderlineToCamel() {
        struct Person: Convertible {
            var nick_name: String = ""
            var most_favorite_number: Int = 0
            var birthday: String = ""
            
            func kk_modelKey(from property: Property) -> ModelPropertyKey {
                // `nick_name` -> `nickName`
                return property.name.kk.camelCased()
            }
        }
        
        let nickName = "ErHa"
        let mostFavoriteNumber = 666
        let birthday = "2011-10-12"
        
        let json: [String: Any] = [
            "nickName": nickName,
            "mostFavoriteNumber": mostFavoriteNumber,
            "birthday": birthday
        ]
        
        let student = json.kk.model(Person.self)
        XCTAssert(student?.nick_name == nickName)
        XCTAssert(student?.most_favorite_number == mostFavoriteNumber)
        XCTAssert(student?.birthday == birthday)
    }
    
    func testClass1() {
        class Person: Convertible {
            var nickName: String = ""
            required init() {}
            
            func kk_modelKey(from property: Property) -> ModelPropertyKey {
                return property.name.kk.underlineCased()
            }
        }
        
        class Student: Person {
            var mathScore: Int = 0
        }
        
        let nick_ame = "Jack"
        let math_score = 96
        let json: [String: Any] = ["nick_name": nick_ame, "math_score": math_score]
        
        let person = json.kk.model(Person.self)
        XCTAssert(person?.nickName == nick_ame)
        
        let student = json.kk.model(Student.self)
        XCTAssert(student?.nickName == nick_ame)
        XCTAssert(student?.mathScore == math_score)
    }
    
    func testClass2() {
        class Person: Convertible {
            var name: String = ""
            required init() {}
            
            func kk_modelKey(from property: Property) -> ModelPropertyKey {
                return property.name == "name" ? "_name_" : property.name
            }
        }
        
        class Student: Person {
            var score: Int = 0
            
            override func kk_modelKey(from property: Property) -> ModelPropertyKey {
                return property.name == "score"
                    ? "_score_"
                    : super.kk_modelKey(from: property)
            }
        }
        
        let name = "Jack"
        let score = 96
        let json: [String: Any] = ["_name_": name, "_score_": score]
        
        let person = json.kk.model(Person.self)
        XCTAssert(person?.name == name)
        
        let student = json.kk.model(Student.self)
        XCTAssert(student?.name == name)
        XCTAssert(student?.score == score)
    }
    
    func testClass3() {
        class Person: Convertible {
            var name: String = ""
            required init() {}
            
            func kk_modelKey(from property: Property) -> ModelPropertyKey {
                return property.name == "name" ? "_name_" : property.name
            }
        }
        
        class Student: Person {
            var score: Int = 0
            
            override func kk_modelKey(from property: Property) -> ModelPropertyKey {
                return property.name == "score" ? "_score_" : property.name
            }
        }
        
        let personName = "Jack"
        let person = ["_name_": personName].kk.model(Person.self)
        XCTAssert(person?.name == personName)
        
        let studentName = "Rose"
        let studentScore = 96
        let student = ["name": studentName,
                       "_score_": studentScore].kk.model(Student.self)
        XCTAssert(student?.name == studentName)
        XCTAssert(student?.score == studentScore)
    }
    
    func testComplex() {
        struct Toy: Convertible {
            var price: Double = 0.0
            var name: String = ""
        }
        
        struct Dog: Convertible {
            var name: String = ""
            var age: Int = 0
            var nickName: String?
            var toy: Toy?
            
            func kk_modelKey(from property: Property) -> ModelPropertyKey {
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
        
        let json: [String: Any] = [
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
        
        let dog = json.kk.model(Dog.self)
        XCTAssert(dog?.name == name)
        XCTAssert(dog?.age == age)
        XCTAssert(dog?.nickName == nickName1)
        XCTAssert(dog?.toy?.name == toy.name)
        XCTAssert(dog?.toy?.price == toy.price)
    }
    
    func testConfig1() {
        // Global Config
        ConvertibleConfig.setModelKey { property in
            property.name.kk.underlineCased()
        }
        // ConvertibleConfig.setModelKey { $0.name.kk.underlineCased() }
        
        class Person: Convertible {
            var nickName: String = ""
            required init() {}
        }
        
        class Student: Person {
            var mathScore: Int = 0
        }
        
        struct Car: Convertible {
            var maxSpeed: Double = 0.0
            var name: String = ""
        }
        
        let nick_ame = "Jack"
        let math_score = 96
        let json: [String: Any] = ["nick_name": nick_ame, "math_score": math_score]
        
        let person = json.kk.model(Person.self)
        XCTAssert(person?.nickName == nick_ame)
        
        let student = json.kk.model(Student.self)
        XCTAssert(student?.nickName == nick_ame)
        XCTAssert(student?.mathScore == math_score)
        
        let max_speed = 250.0
        let name = "Bently"
        let car = ["max_speed": max_speed, "name": name].kk.model(Car.self)
        XCTAssert(car?.maxSpeed == max_speed)
        XCTAssert(car?.name == name)
    }
    
    func testConfig2() {
        // Local Config
        // The config can be used on Student because Student extends Person
        ConvertibleConfig.setModelKey(for: [Person.self, Car.self]) {
            property in
            property.name.kk.underlineCased()
        }
        
        class Person: Convertible {
            var nickName: String = ""
            required init() {}
        }
        
        class Student: Person {
            var mathScore: Int = 0
        }
        
        struct Car: Convertible {
            var maxSpeed: Double = 0.0
            var name: String = ""
        }
        
        let nick_ame = "Jack"
        let math_score = 96
        let json: [String: Any] = ["nick_name": nick_ame, "math_score": math_score]
        
        let person = json.kk.model(Person.self)
        XCTAssert(person?.nickName == nick_ame)
        
        let student = json.kk.model(Student.self)
        XCTAssert(student?.nickName == nick_ame)
        XCTAssert(student?.mathScore == math_score)
        
        let max_speed = 250.0
        let name = "Bently"
        let car = ["max_speed": max_speed, "name": name].kk.model(Car.self)
        XCTAssert(car?.maxSpeed == max_speed)
        XCTAssert(car?.name == name)
    }
    
    func testConfig3() {
        // Global Config
        ConvertibleConfig.setModelKey { property in
            property.name.kk.underlineCased()
        }
        
        // Config of Person
        ConvertibleConfig.setModelKey(for: Person.self) { property in
            // `name` -> `_name_`
            property.name == "name" ? "_name_" : property.name
        }
        
        // Config of Student
        ConvertibleConfig.setModelKey(for: Student.self) { property in
            // `score` -> `_score_`，`name` -> `name`
            property.name == "score" ? "_score_" : property.name
        }
        
        class Person: Convertible {
            var name: String = ""
            required init() {}
        }
        
        class Student: Person {
            var score: Int = 0
        }
        
        struct Car: Convertible {
            var maxSpeed: Double = 0.0
            var name: String = ""
        }
        
        let personName = "Jack"
        let person = ["_name_": personName].kk.model(Person.self)
        XCTAssert(person?.name == personName)
        
        let studentName = "Rose"
        let studentScore = 96
        let student = ["name": studentName,
                       "_score_": studentScore].kk.model(Student.self)
        XCTAssert(student?.name == studentName)
        XCTAssert(student?.score == studentScore)
        
        let max_speed = 250.0
        let name = "Bently"
        let car = ["max_speed": max_speed, "name": name].kk.model(Car.self)
        XCTAssert(car?.maxSpeed == max_speed)
        XCTAssert(car?.name == name)
    }
    
    func testConfig4() {
        // Global Config
        ConvertibleConfig.setModelKey { property in
            property.name.kk.underlineCased()
        }
        
        // Config of Person
        ConvertibleConfig.setModelKey(for: Person.self) { property in
            // `name` -> `_name_`
            property.name == "name" ? "_name_" : property.name
        }
        
        // Config of Student
        ConvertibleConfig.setModelKey(for: Student.self) { property in
            // `score` -> `_score_`，`name` -> `name`
            property.name == "score" ? "_score_" : property.name
        }
        
        class Person: Convertible {
            var name: String = ""
            required init() {}
            
            func kk_modelKey(from property: Property) -> ModelPropertyKey {
                // Use ConvertibleConfig to get config of Person
                // `name` -> `_name_`
                return ConvertibleConfig.modelKey(Person.self, property: property)
            }
        }
        
        class Student: Person {
            var score: Int = 0
            
            override func kk_modelKey(from property: Property) -> ModelPropertyKey {
                // `score` -> `score`，`name` -> `name`
                return property.name
            }
        }
        
        struct Car: Convertible {
            var maxSpeed: Double = 0.0
            var name: String = ""
            
            func kk_modelKey(from property: Property) -> ModelPropertyKey {
                // Use ConvertibleConfig to get global config
                // `maxSpeed` -> `max_speed`
                // `name` -> `name`
                return ConvertibleConfig.modelKey(property: property)
            }
        }
        
        /*
         If there are many `modelKey`s，the rule is（e.g. Student）
         ① Use kk_modelKey implementation of Student
         ② If ① doesn't exist，use ConvertibleConfig of Student
         ③ If ①② doesn't exist，use ConvertibleConfig of Student's superclass
         ④ If ①②③ doesn't exist，use ConvertibleConfig of Student's superclass's superclass....
         ⑤ If ①②③④ doesn't exist，use global ConvertibleConfig
         */
        
        let personName = "Jack"
        let person = ["_name_": personName].kk.model(Person.self)
        XCTAssert(person?.name == personName)
        
        let studentName = "Rose"
        let studentScore = 96
        let student = ["name": studentName,
                       "score": studentScore].kk.model(Student.self)
        XCTAssert(student?.name == studentName)
        XCTAssert(student?.score == studentScore)
        
        let max_speed = 250.0
        let name = "Bently"
        let car = ["max_speed": max_speed, "name": name].kk.model(Car.self)
        XCTAssert(car?.maxSpeed == max_speed)
        XCTAssert(car?.name == name)
    }
}
