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
        
        func kk_willConvertToModel(from json: JSONObject) {
            print("kk_willConvertToModel -", json)
        }
        
        func kk_didConvertToModel(from json: JSONObject) {
            print("kk_didConvertToModel -", json)
        }
    }
    
    // MARK: - Generic Type
    func testGeneric() {
        let name = "Miaomiao"
        let weight = 6.66
        
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
    
    // MARK: - Int Type
    func testInt() {
        struct Student: Convertible {
            var age1: Int8 = 6
            var age2: Int16 = 0
            var age3: Int32 = 0
            var age4: Int64 = 0
            var age5: UInt8 = 0
            var age6: UInt16 = 0
            var age7: UInt32 = 0
            var age8: UInt64 = 0
            var age9: UInt = 0
            var age10: Int = 0
        }
        
        let json: [String: Any] = [
            "age1": "suan8fa8",
            "age2": "6suan8fa8",
            "age3": "6",
            "age4": 6.66,
            "age5": NSNumber(value: 6.66),
            "age6": Int32(6),
            "age7": true,
            "age8": "FALSE", // true\false\yes\no\TRUE\FALSE\YES\NO
            "age9": Decimal(6.66),
            "age10": NSDecimalNumber(value: 6.66)
        ]
        
        let student = json.kk.model(Student.self)
        XCTAssert(student?.age1 == 6) // use default value
        XCTAssert(student?.age2 == 6)
        XCTAssert(student?.age3 == 6)
        XCTAssert(student?.age4 == 6)
        XCTAssert(student?.age5 == 6)
        XCTAssert(student?.age6 == 6)
        XCTAssert(student?.age7 == 1)
        XCTAssert(student?.age8 == 0)
        XCTAssert(student?.age9 == 6)
        XCTAssert(student?.age10 == 6)
    }
    
    // MARK: - Float Type
    func testFloat() {
        struct Student: Convertible {
            var height1: Float = 0.0
            var height2: Float = 0.0
            var height3: Float = 0.0
            var height4: Float = 0.0
            var height5: Float = 0.0
            var height6: Float = 0.0
            var height7: Float = 0.0
        }
        
        let json: [String: Any] = [
            "height1": "6.66suan8fa8",
            "height2": longFloatString,
            "height3": NSDecimalNumber(string: longFloatString),
            "height4": Decimal(string: longFloatString) as Any,
            "height5": 666,
            "height6": true,
            "height7": "NO" // true\false\yes\no\TRUE\FALSE\YES\NO
        ]
        
        let student = json.kk.model(Student.self)
        XCTAssert(student?.height1 == 6.66)
        XCTAssert(student?.height2 == longFloat)
        XCTAssert(student?.height3 == longFloat)
        XCTAssert(student?.height4 == longFloat)
        XCTAssert(student?.height5 == 666.0)
        XCTAssert(student?.height6 == 1.0)
        XCTAssert(student?.height7 == 0.0)
    }
    
    // MARK: - Double Type
    func testDouble() {
        struct Student: Convertible {
            var height1: Double = 0.0
            var height2: Double = 0.0
            var height3: Double = 0.0
            var height4: Double = 0.0
            var height5: Double = 0.0
            var height6: Double = 0.0
            var height7: Double = 0.0
        }
        
        let json: [String: Any] = [
            "height1": "6.66suan8fa8",
            "height2": longDoubleString,
            "height3": NSDecimalNumber(string: longDoubleString),
            "height4": Decimal(string: longDoubleString) as Any,
            "height5": 666,
            "height6": true,
            "height7": "NO" // true\false\yes\no\TRUE\FALSE\YES\NO
        ]
        
        let student = json.kk.model(Student.self)
        XCTAssert(student?.height1 == 6.66)
        XCTAssert(student?.height2 == longDouble)
        XCTAssert(student?.height3 == longDouble)
        XCTAssert(student?.height4 == longDouble)
        XCTAssert(student?.height5 == 666.0)
        XCTAssert(student?.height6 == 1.0)
        XCTAssert(student?.height7 == 0.0)
    }
    
    // MARK: - Bool Type
    func testBool() {
        struct Student: Convertible {
            var rich1: Bool = false
            var rich2: Bool = false
            var rich3: Bool = false
            var rich4: Bool = false
            var rich5: Bool = false
            var rich6: Bool = false
        }
        
        // 0 -> false , other -> true
        let json: [String: Any] = [
            "rich1": 100,
            "rich2": 0.0,
            "rich3": "1",
            "rich4": NSNumber(value: 0.666),
            "rich5": "true",
            "rich6": "NO" // true\false\yes\no\TRUE\FALSE\YES\NO
        ]
        
        let student = json.kk.model(Student.self)
        XCTAssert(student?.rich1 == true)
        XCTAssert(student?.rich2 == false)
        XCTAssert(student?.rich3 == true)
        XCTAssert(student?.rich4 == true)
        XCTAssert(student?.rich5 == true)
        XCTAssert(student?.rich6 == false)
    }
    
    // MARK: - String Type
    func testString() {
        struct Student: Convertible {
            var name1: String = ""
            var name2: String = ""
            var name3: NSString = ""
            var name4: NSString = ""
            var name5: NSMutableString = ""
            var name6: NSMutableString = ""
            var name7: String = ""
            var name8: String = ""
        }
        
        let json: [String: Any] = [
            "name1": 666,
            "name2": NSMutableString(string: "777"),
            "name3": [1,[2,3],"4"],
            "name4": longDecimalNumber,
            "name5": 6.66,
            "name6": false,
            "name7": NSURL(fileURLWithPath: "/users/mj/desktop"),
            "name8": URL(string: "http://www.520suanfa.com") as Any
        ]
        
        let student = json.kk.model(Student.self)
        XCTAssert(student?.name1 == "666")
        XCTAssert(student?.name2 == "777")
        XCTAssert(student?.name3 == "[1, [2, 3], \"4\"]")
        XCTAssert(student?.name4 == longDecimalString as NSString)
        XCTAssert(student?.name5 == "6.66")
        XCTAssert(student?.name6 == "false")
        XCTAssert(student?.name7 == "file:///users/mj/desktop")
        XCTAssert(student?.name8 == "http://www.520suanfa.com")
    }
    
    // MARK: - Decimal Type
    func testDecimal() {
        struct Student: Convertible {
            var money1: Decimal = 0
            var money2: Decimal = 0
            var money3: Decimal = 0
            var money4: Decimal = 0
            var money5: Decimal = 0
            var money6: Decimal = 0
        }
        
        let json: [String: Any] = [
            "money1": longDouble,
            "money2": true,
            "money3": longDecimalNumber,
            "money4": longDecimalString,
            "money5": 666,
            "money6": "NO" // true\false\yes\no\TRUE\FALSE\YES\NO
        ]
        
        let student = json.kk.model(Student.self)
        XCTAssert(student?.money1 == Decimal(string: longDoubleString))
        XCTAssert(student?.money2 == 1)
        XCTAssert(student?.money3 == Decimal(string: longDecimalString))
        XCTAssert(student?.money4 == Decimal(string: longDecimalString))
        XCTAssert(student?.money5 == 666)
        XCTAssert(student?.money6 == 0)
    }
        
    // MARK: - Decimal Number Type
    func testDecimalNumber() {
        struct Student: Convertible {
            var money1: NSDecimalNumber = 0
            var money2: NSDecimalNumber = 0
            var money3: NSDecimalNumber = 0
            var money4: NSDecimalNumber = 0
            var money5: NSDecimalNumber = 0
            var money6: NSDecimalNumber = 0
        }
        
        let json: [String: Any] = [
            "money1": longDouble,
            "money2": true,
            "money3": longDecimal,
            "money4": longDecimalString,
            "money5": 666.0,
            "money6": "NO" // true\false\yes\no\TRUE\FALSE\YES\NO
        ]
        
        let student = json.kk.model(Student.self)
        XCTAssert(student?.money1 == NSDecimalNumber(string: longDoubleString))
        XCTAssert(student?.money2 == true)
        XCTAssert(student?.money2 == 1)
        XCTAssert(student?.money3 == longDecimalNumber)
        XCTAssert(student?.money4 == longDecimalNumber)
        XCTAssert(student?.money5 == 666)
        XCTAssert(student?.money6 == false)
        XCTAssert(student?.money6 == 0)
    }
    
    // MARK: - Number Type
    func testNumber() {
        struct Student: Convertible {
            var money1: NSNumber = 0
            var money2: NSNumber = 0
            var money3: NSNumber = 0
            var money4: NSNumber = 0
            var money5: NSNumber = 0
            var money6: NSNumber = 0
        }
        
        let json: [String: Any] = [
            "money1": longDouble,
            "money2": true,
            "money3": Decimal(string: longDoubleString) as Any,
            "money4": longDoubleString,
            "money5": 666.0,
            "money6": "NO" // true\false\yes\no\TRUE\FALSE\YES\NO
        ]
        
        let student = json.kk.model(Student.self)
        XCTAssert(student?.money1 == NSNumber(value: longDouble))
        XCTAssert(student?.money2 == true)
        XCTAssert(student?.money2 == 1)
        XCTAssert(student?.money2 == 1.0)
        XCTAssert(student?.money3 == NSNumber(value: longDouble))
        XCTAssert(student?.money4 == NSNumber(value: longDouble))
        XCTAssert(student?.money5 == 666)
        XCTAssert(student?.money5 == 666.0)
        XCTAssert(student?.money6 == false)
        XCTAssert(student?.money6 == 0)
        XCTAssert(student?.money6 == 0.0)
    }
    
    // MARK: - Optional Type
    func testOptional() {
        struct Student: Convertible {
            var rich1: Bool = false
            var rich2: Bool? = false
            var rich3: Bool?? = false
            var rich4: Bool??? = false
            var rich5: Bool???? = false
            var rich6: Bool????? = false
        }
        
        let rich1: Int????? = 100
        let rich2: Double???? = 0.0
        let rich3: String??? = "0"
        let rich4: NSNumber?? = NSNumber(value: 0.666)
        let rich5: String? = "true"
        let rich6: String = "NO" // true\false\yes\no\TRUE\FALSE\YES\NO
        
        // 0 -> false , other -> true
        let json: [String: Any] = [
            "rich1": rich1 as Any,
            "rich2": rich2 as Any,
            "rich3": rich3 as Any,
            "rich4": rich4 as Any,
            "rich5": rich5 as Any,
            "rich6": rich6
        ]
        
        let student = json.kk.model(Student.self)
        XCTAssert(student?.rich1 == true)
        XCTAssert(student?.rich2 == false)
        XCTAssert(student?.rich3 == false)
        XCTAssert(student?.rich4 == true)
        XCTAssert(student?.rich5 == true)
        XCTAssert(student?.rich6 == false)
    }
    
    // MARK: - URL Type
    func testURL() {
        struct Student: Convertible {
            var url1: NSURL?
            var url2: NSURL?
            var url3: URL?
            var url4: URL?
        }
    
        let url = "http://520suanfa.com/红黑树"
        let encodedUrl = "http://520suanfa.com/%E7%BA%A2%E9%BB%91%E6%A0%91"
        
        let json: [String: Any] = [
            "url1": url,
            "url2": URL(string: encodedUrl) as Any,
            "url3": url,
            "url4": NSURL(string: encodedUrl) as Any
        ]
        
        let student = json.kk.model(Student.self)
        XCTAssert(student?.url1?.absoluteString == encodedUrl)
        XCTAssert(student?.url2?.absoluteString == encodedUrl)
        XCTAssert(student?.url3?.absoluteString == encodedUrl)
        XCTAssert(student?.url4?.absoluteString == encodedUrl)
    }
    
    // MARK: - Data Type
    func testData() {
        struct Student: Convertible {
            var data1: NSData?
            var data2: NSData?
            var data3: Data?
            var data4: Data?
        }
        
        let utf8 = String.Encoding.utf8
        let str = "RedBlackTree"
        let data = str.data(using: utf8)!
        
        let json: [String: Any] = [
            "data1": str,
            "data2": data,
            "data3": str,
            "data4": NSData(data: data)
        ]
        
        let student = json.kk.model(Student.self)
        XCTAssert(String(data: (student?.data1)! as Data, encoding: utf8) == str)
        XCTAssert(String(data: (student?.data2)! as Data, encoding: utf8) == str)
        XCTAssert(String(data: (student?.data3)!, encoding: utf8) == str)
        XCTAssert(String(data: (student?.data4)!, encoding: utf8) == str)
    }
    
    // MARK: - Enum Type
    func testEnum1() {
        enum Grade: String, ConvertibleEnum {
            case perfect = "A"
            case great = "B"
            case good = "C"
            case bad = "D"
        }
        
        struct Student: Convertible {
            var grade1: Grade = .perfect
            var grade2: Grade = .perfect
        }
        
        let json: [String: Any] = [
            "grade1": "C",
            "grade2": "D"
        ]
        
        let student = json.kk.model(Student.self)
        XCTAssert(student?.grade1 == .good)
        XCTAssert(student?.grade2 == .bad)
    }
    
    func testEnum2() {
        enum Grade: Double, ConvertibleEnum {
            case perfect = 8.88
            case great = 7.77
            case good = 6.66
            case bad = 5.55
        }
        
        struct Student: Convertible {
            var grade1: Grade = .perfect
            var grade2: Grade = .perfect
            var grade3: Grade = .perfect
            var grade4: Grade = .perfect
        }
        
        let json: [String: Any] = [
            "grade1": "5.55kaka",
            "grade2": 6.66,
            "grade3": NSNumber(value: 7.77),
            "grade4": NSDecimalNumber(string: "8.88")
        ]
        
        let student = json.kk.model(Student.self)
        XCTAssert(student?.grade1 == .bad)
        XCTAssert(student?.grade2 == .good)
        XCTAssert(student?.grade3 == .great)
        XCTAssert(student?.grade4 == .perfect)
    }
}
