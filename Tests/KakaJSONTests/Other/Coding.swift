//
//  Coding.swift
//  KakaJSONTests
//
//  Created by MJ Lee on 2019/8/22.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

import XCTest
@testable import KakaJSON

class TestCoding: XCTestCase {
    // Please input your file path
    var file: String = {
        var str = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        str.append("/kj_test.json")
        return str
    }()
    
    func testModel() {
        // Equatable is only for test cases, is not necessary for Coding.
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
        }
        
        checkCoding(Car.self)
    }
    
    func testOptional() {
        // Equatable is only for test cases, is not necessary for Coding.
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
        
        checkCoding(Student.self)
    }
    
    func testNested() {
        // Equatable is only for test cases, is not necessary for Coding.
        struct Book: Convertible, Equatable {
            var name: String = ""
            var price: Double = 0.0
        }
        
        // Equatable is only for test cases, is not necessary for Coding.
        struct Car: Convertible, Equatable {
            var name: String = ""
            var price: Double = 0.0
        }
        
        // Equatable is only for test cases, is not necessary for Coding.
        struct Dog: Convertible, Equatable {
            var name: String = ""
            var age: Int = 0
        }
        
        // Equatable is only for test cases, is not necessary for Coding.
        struct Person: Convertible, Equatable {
            var name: String = "Jack"
            var car: Car? = Car(name: "Bently", price: 106.666)
            var books: [Book]? = [
                Book(name: "Fast C++", price: 666.6),
                Book(name: "Data Structure And Algorithm", price: 666.6),
            ]
            var dogs: [String: Dog]? = [
                "dog0": Dog(name: "Wang", age: 5),
                "dog1": Dog(name: "ErHa", age: 3),
            ]
        }
        
        checkCoding(Person.self)
        
        write(Person(), to: file)
        let person = read(Person.self, from: file)
        
        XCTAssert(person?.name == "Jack")
        XCTAssert(person?.car?.name == "Bently")
        XCTAssert(person?.car?.price == 106.666)
        XCTAssert(person?.books?.count == 2)
        XCTAssert(person?.dogs?.count == 2)
    }
    
    func testAny() {
        struct Book: Convertible {
            var name: String = ""
            var price: Double = 0.0
        }
        
        struct Dog: Convertible {
            var name: String = ""
            var age: Int = 0
        }
        
        struct Person: Convertible {
            // NSArray\NSMutableArray
            var books: [Any]? = [
                Book(name: "Fast C++", price: 666.6),
                Book(name: "Data Structure And Algorithm", price: 1666.6),
            ]
            
            // NSDictionary\NSMutableDictionary
            var dogs: [String: Any]? = [
                "dog0": Dog(name: "Wang", age: 5),
                "dog1": Dog(name: "ErHa", age: 3),
            ]
        }
        
        write(Person(), to: file)
        let person = read(Person.self, from: file)
        XCTAssert(person?.books?.count == 2)
        XCTAssert(person?.dogs?.count == 2)
        let personString = "\(person as Any)"
        XCTAssert(personString.contains("Fast C++"))
        XCTAssert(personString.contains("Data Structure And Algorithm"))
        XCTAssert(personString.contains("666.6"))
        XCTAssert(personString.contains("1666.6"))
        // prevent from 66.6499999999999998
        XCTAssert(!personString.contains("99999"))
        // prevent from 66.6600000000000001
        XCTAssert(!personString.contains("00000"))
    }
    
    func testDate() {
        let date1 = Date(timeIntervalSince1970: timeInteval)
        write(date1, to: file)
        
        let date2 = read(Date.self, from: file)
        XCTAssert(date2 == date1)
        
        XCTAssert(read(Double.self, from: file) == timeInteval)
    }
    
    func testString() {
        let string1 = "123"
        write(string1, to: file)
        
        let string2 = read(String.self, from: file)
        XCTAssert(string2 == string1)
        
        XCTAssert(read(Int.self, from: file) == 123)
    }
    
    func testArray() {
        let array1 = ["Jack", "Rose"]
        write(array1, to: file)
        
        let array2 = read([String].self, from: file)
        XCTAssert(array2 == array1)
    }
    
    func testModelArray() {
        struct Car: Convertible {
            var name: String = ""
            var price: Double = 0.0
        }
        
        let models1 = [
            Car(name: "BMW", price: 100.0),
            Car(name: "Audi", price: 70.0)
        ]
        
        write(models1, to: file)
        
        let models2 = read([Car].self, from: file)
        XCTAssert(models2?.count == models1.count)
        XCTAssert(models2?[0].name == "BMW")
        XCTAssert(models2?[0].price == 100.0)
        XCTAssert(models2?[1].name == "Audi")
        XCTAssert(models2?[1].price == 70.0)
    }
    
    func testModelSet() {
        struct Car: Convertible, Hashable {
            var name: String = ""
            var price: Double = 0.0
        }
        
        let models1: Set<Car> = [
            Car(name: "BMW", price: 100.0),
            Car(name: "Audi", price: 70.0)
        ]
        
        write(models1, to: file)
        
        let models2 = read(Set<Car>.self, from: file)!
        
        XCTAssert(models2.count == models1.count)
        for car in models2 {
            XCTAssert(["BMW", "Audi"].contains(car.name))
            XCTAssert([100.0, 70.0].contains(car.price))
        }
    }
    
    func testModelDictionary() {
        struct Car: Convertible {
            var name: String = ""
            var price: Double = 0.0
        }
        
        let models1 = [
            "car0": Car(name: "BMW", price: 100.0),
            "car1": Car(name: "Audi", price: 70.0)
        ]
        
        write(models1, to: file)
        
        let models2 = read([String: Car].self, from: file)
        XCTAssert(models2?.count == models1.count)
        
        let car0 = models2?["car0"]
        XCTAssert(car0?.name == "BMW")
        XCTAssert(car0?.price == 100.0)
        
        let car1 = models2?["car1"]
        XCTAssert(car1?.name == "Audi")
        XCTAssert(car1?.price == 70.0)
    }
    
    func checkCoding<M: Convertible & Equatable>(_ type: M.Type) {
        let obj1 = type.init()
        // write to file
        write(obj1, to: file)
        
        // read from file
        let obj2 = read(type, from: file)
        XCTAssert(obj1 == obj2)
        
        let objString = "\(obj2 as Any)"
        // prevent from 66.6499999999999998
        XCTAssert(!objString.contains("99999"))
        // prevent from 66.6600000000000001
        XCTAssert(!objString.contains("00000"))
    }
    
    static var allTests = [
        "testModel": testModel,
        "testOptional": testOptional,
        "testNested": testNested,
        "testAny": testAny,
        "testDate": testDate,
        "testString": testString,
        "testArray": testArray,
        "testModelArray": testModelArray,
        "testModelSet": testModelSet,
        "testModelDictionary": testModelDictionary
    ]
}
