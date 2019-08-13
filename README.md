# KakaJSON
Fast conversion between json and model in swift.

## Usages
- JSON To Model
```swift
let name = "Miaomiao"
let weight = 6.66

let JSON: [String: Any] = [
    "weight": weight,
    "name": name
]

// let cat = model(from: JSON, SCat.self)
let cat = JSON.kk.model(SCat.self)
```

- Model To JSON
```swift
struct SCar: Convertible, Equatable {
    var new: Bool = true
    var age: Int = 10
    var weight: Double = 0.1234567890123456
    var height: Decimal = 0.123456789012345678901234567890123456789
    var name: String = "Bently"
    var price: NSDecimalNumber = 0.123456789012345678901234567890123456789
    var minSpeed: Double = 66.66
    var maxSpeed: NSNumber = 77.77
}

let car = SCar()
// let json = JSON(from: car)
let json = car.kk.JSON()
// let jsonString = JSONString(from: car)
let jsonString = car.kk.JSONString()
```
## More documentation will be coming out soon....