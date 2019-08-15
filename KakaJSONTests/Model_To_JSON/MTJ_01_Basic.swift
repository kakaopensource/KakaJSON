//
//  MTJ_01_Basic.swift
//  KakaJSONTests
//
//  Created by MJ Lee on 2019/8/11.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

class MTJ_01_Basic: XCTestCase {
    // MARK: - Normal
    func testNormal() {
        // Equatable is only for test cases, is not necessary for Model-To-JSON.
        struct Car: Convertible, Equatable {
            var new: Bool = true
            var age: Int = 10
            var weight: Double = longDouble
            var height: Decimal = longDecimal
            var name: String = "Bently"
            var price: NSDecimalNumber = longDecimalNumber
            var minSpeed: Double = 66.66
            var maxSpeed: NSNumber = 77.77
            var capacity: CGFloat = 88.88
        }
        
        let jsonString = Car().kk.JSONString()
        XCTAssert(jsonString?.contains("true") == true)
        XCTAssert(jsonString?.contains("66.66") == true)
        XCTAssert(jsonString?.contains("77.77") == true)
        XCTAssert(jsonString?.contains("88.88") == true)
        XCTAssert(jsonString?.contains(longDoubleString) == true)
        XCTAssert(jsonString?.contains(longDecimalString) == true)
        
        checkModelToJSon(Car.self)
    }
    
    // MARK: - Optional Type
    func testOptional() {
        // Equatable is only for test cases, is not necessary for Model-To-JSON.
        struct Student: Convertible, Equatable {
            var op1: Int? = 10
            var op2: Double?? = 66.66
            var op3: Float??? = 77.77
            var op4: String???? = "Jack"
            var op5: Bool????? = true
            // NSArray\Set<CGFloat>\NSSet
            // NSMutableArray\NSMutableSet
            var op6: [CGFloat]?????? = [44.44, 55.55]
        }
        
        let jsonString = Student().kk.JSONString()
        XCTAssert(jsonString?.contains("66.66") == true)
        XCTAssert(jsonString?.contains("77.77") == true)
        XCTAssert(jsonString?.contains("true") == true)
        XCTAssert(jsonString?.contains("44.44") == true)
        XCTAssert(jsonString?.contains("55.55") == true)
        
        checkModelToJSon(Student.self)
    }
    
    // MARK: - URL Type
    func testURL() {
        // Equatable is only for test cases, is not necessary for Model-To-JSON.
        struct Student: Convertible, Equatable {
            var url1: NSURL? = NSURL(string: "file:///520suanfa")
            var url2: URL? = URL(string: "http://520suanfa.com")
        }
        
        checkModelToJSon(Student.self)
    }
    
    // MARK: - Enum Type
    func testEnum1() {
        enum Grade: String, ConvertibleEnum {
            case perfect = "A"
            case great = "B"
            case good = "C"
            case bad = "D"
        }
        
        // Equatable is only for test cases, is not necessary for Model-To-JSON.
        struct Student: Convertible, Equatable {
            var grade1: Grade = .great
            var grade2: Grade = .bad
        }
        
        checkModelToJSon(Student.self)
    }
    
    func testEnum2() {
        enum Grade: Double, ConvertibleEnum {
            case perfect = 8.88
            case great = 7.77
            case good = 6.66
            case bad = 5.55
        }
        
        struct Student: Convertible, Equatable {
            var grade1: Grade = .perfect
            var grade2: Grade = .great
            var grade3: Grade = .good
            var grade4: Grade = .bad
        }
        
        let jsonString = Student().kk.JSONString()
        XCTAssert(jsonString?.contains("5.55") == true)
        XCTAssert(jsonString?.contains("6.66") == true)
        XCTAssert(jsonString?.contains("7.77") == true)
        XCTAssert(jsonString?.contains("8.88") == true)
        
        checkModelToJSon(Student.self)
    }
}
