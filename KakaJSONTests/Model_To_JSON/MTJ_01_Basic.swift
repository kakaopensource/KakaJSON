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
        struct SCar: Convertible, Equatable {
            var new: Bool = true
            var age: Int = 10
            var weight: Double = longDouble
            var height: Decimal = longDecimal
            var name: String = "Bently"
            var price: NSDecimalNumber = longDecimalNumber
            var minSpeed: Double = 66.66
            var maxSpeed: NSNumber = 77.77
        }
        
        let jsonString = SCar().kk.JSONString()
        XCTAssert(jsonString?.contains("true") == true)
        XCTAssert(jsonString?.contains("66.66") == true)
        XCTAssert(jsonString?.contains("77.77") == true)
        XCTAssert(jsonString?.contains(longDoubleString) == true)
        XCTAssert(jsonString?.contains(longDecimalString) == true)
        
        checkModelToJSon(SCar.self)
    }
    
    // MARK: - Optional Type
    func testOptional() {
        // Equatable is only for test cases, is not necessary for Model-To-JSON.
        struct SStudent: Convertible, Equatable {
            var op1: Int? = 10
            var op2: Double?? = 66.66
            var op3: Float??? = 77.77
            var op4: String???? = "Jack"
            var op5: Bool????? = true
            // NSArray\Set<Double>\NSSet
            // NSMutableArray\NSMutableSet
            var op6: [Double]?????? = [44.44, 55.55]
        }
        
        let jsonString = SStudent().kk.JSONString()
        XCTAssert(jsonString?.contains("66.66") == true)
        XCTAssert(jsonString?.contains("77.77") == true)
        XCTAssert(jsonString?.contains("true") == true)
        XCTAssert(jsonString?.contains("44.44") == true)
        XCTAssert(jsonString?.contains("55.55") == true)
        
        checkModelToJSon(SStudent.self)
    }
    
    // MARK: - URL Type
    func testURL() {
        // Equatable is only for test cases, is not necessary for Model-To-JSON.
        struct SStudent: Convertible, Equatable {
            var url1: NSURL? = NSURL(string: "file:///520suanfa")
            var url2: URL? = URL(string: "http://520suanfa.com")
        }
        
        checkModelToJSon(SStudent.self)
    }
    
    // MARK: - Enum Type
    func testEnum() {
        enum Grade: String, ConvertibleEnum {
            case perfect = "A"
            case great = "B"
            case good = "C"
            case bad = "D"
        }
        
        // Equatable is only for test cases, is not necessary for Model-To-JSON.
        struct SStudent: Convertible, Equatable {
            var grade1: Grade = .great
            var grade2: Grade = .bad
        }
        
        checkModelToJSon(SStudent.self)
    }
}
