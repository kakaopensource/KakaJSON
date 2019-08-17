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
            var name: String = "Bently"
            var new: Bool = true
            var age: Int = 10
            var area: Float = longFloat
            var weight: Double = longDouble
            var height: Decimal = longDecimal
            var price: NSDecimalNumber = longDecimalNumber
            var minSpeed: Double = 66.66
            var maxSpeed: NSNumber = 77.77
            var capacity: CGFloat = 88.88
            var birthday: Date = time
            var url: URL? = URL(string: "http://520suanfa.com")
            
            func kk_willConvertToJSON() {
                print("Car - kk_willConvertToJSON")
            }
            
            func kk_didConvertToJSON(json: JSONObject?) {
                print("Car - kk_didConvertToJSON", json as Any)
            }
        }
        
        let car = Car()
        
        let json = car.kk.JSON()
//        let json = JSON(from: car)
        XCTAssert(json?["new"].kk.bool == true)
        XCTAssert(json?["age"].kk.int == 10)
        XCTAssert(json?["area"].kk.float == longFloat)
        XCTAssert(json?["weight"].kk.double  == longDouble)
        XCTAssert(json?["height"].kk.decimal == longDecimal)
        XCTAssert(json?["name"].kk.string == "Bently")
        XCTAssert(json?["price"].kk.decimalNumber == longDecimalNumber)
        XCTAssert(json?["minSpeed"].kk.double == 66.66)
        XCTAssert(json?["maxSpeed"].kk.number == 77.77)
        XCTAssert(json?["capacity"].kk.cgFloat == 88.88)
        XCTAssert(json?["birthday"].kk.double == timeInteval)
        XCTAssert(json?["url"].kk.string == "http://520suanfa.com")
        
        var jsonString = car.kk.JSONString()
        print(jsonString!)
//        var jsonString = JSONString(from: car)
        /* {"birthday":1565922866,"new":true,"height":0.123456789012345678901234567890123456789,"weight":0.1234567890123456,"minSpeed":66.66,"price":0.123456789012345678901234567890123456789,"age":10,"name":"Bently","area":0.12345678,"maxSpeed":77.77,"capacity":88.88,"url":"http:\/\/520suanfa.com"} */
        
        XCTAssert(jsonString?.contains("Bently") == true)
        XCTAssert(jsonString?.contains("true") == true)
        XCTAssert(jsonString?.contains("10") == true)
        XCTAssert(jsonString?.contains(longFloatString) == true)
        XCTAssert(jsonString?.contains(longDoubleString) == true)
        XCTAssert(jsonString?.contains(longDecimalString) == true)
        XCTAssert(jsonString?.contains("66.66") == true)
        XCTAssert(jsonString?.contains("77.77") == true)
        XCTAssert(jsonString?.contains("88.88") == true)
        XCTAssert(jsonString?.contains(timeIntevalString) == true)
        XCTAssert(jsonString?.contains("520suanfa.com") == true)
        
        jsonString = car.kk.JSONString(prettyPrinted: false)
        print(jsonString!)
        /*
         {
             "height" : 0.123456789012345678901234567890123456789,
             "weight" : 0.1234567890123456,
             "minSpeed" : 66.66,
             "new" : true,
             "maxSpeed" : 77.77,
             "age" : 10,
             "capacity" : 88.88,
             "birthday" : 1565922866,
             "name" : "Bently",
             "price" : 0.123456789012345678901234567890123456789,
             "area" : 0.12345678
         }
         */
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
        
        let jsonString = Student().kk.JSONString(prettyPrinted: true)
        /*
         {
            "op1" : 10,
            "op4" : "Jack",
            "op2" : 66.66,
            "op5" : true,
             "op6" : [
                 44.44,
                 55.55
             ],
             "op3" : 77.77
         }
         */
        
        XCTAssert(jsonString?.contains("66.66") == true)
        XCTAssert(jsonString?.contains("77.77") == true)
        XCTAssert(jsonString?.contains("true") == true)
        XCTAssert(jsonString?.contains("44.44") == true)
        XCTAssert(jsonString?.contains("55.55") == true)
        
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
        
        let jsonString = Student().kk.JSONString()
        /* {"grade2":"D","grade1":"B"} */
        
        XCTAssert(jsonString?.contains("B") == true)
        XCTAssert(jsonString?.contains("D") == true)
        
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
