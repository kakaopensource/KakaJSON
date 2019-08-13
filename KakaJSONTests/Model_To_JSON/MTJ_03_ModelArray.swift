//
//  MTJ_03_ModelArray.swift
//  KakaJSONTests
//
//  Created by MJ Lee on 2019/8/12.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

class MTJ_03_ModelArray: XCTestCase {
    // Equatable is only for test cases, is not necessary for Model-To-JSON.
    struct SCar: Convertible, Equatable, Hashable {
        var name: String = ""
        var price: Double = 0.0
    }

    func testArray() {
        // NSArray\NSMutableArray
        let models = [
            SCar(name: "BMW", price: 100.0),
            SCar(name: "Audi", price: 70.0),
            SCar(name: "Bently", price: 300.0)
        ]
        
        XCTAssert(models.kk.JSON()?.kk.modelArray(SCar.self) == models)
        XCTAssert(models.kk.JSONString()?.kk.modelArray(SCar.self) == models)
    }
    
    func testSet() {
        let models: Set<SCar> = [
            SCar(name: "BMW", price: 100.0)
        ]
        
        var cars: [SCar] = []
        cars.append(contentsOf: models)
        
        XCTAssert(models.kk.JSON()?.kk.modelArray(SCar.self) == cars)
        XCTAssert(models.kk.JSONString()?.kk.modelArray(SCar.self) == cars)
    }
}
