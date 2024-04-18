import UIKit
/* Lv1, Lv2
class Calculator {
    func calculate(oper:String, a:Double, b:Double) -> Double {
        switch oper {
        case "+" :
            return a + b
        case "-" :
            return a - b
        case "/":
            return a / b
        case "*" :
            return a * b
        case "%":
            return Double(Int(a) % Int(b))
        default:
            return 0
        }
    }
}

let calculator = Calculator()
let addResult = calculator.calculate(oper: "+", a: 5, b: 3)
let subtractResult = calculator.calculate(oper: "-", a: 4, b: 2)
let multiplyResult = calculator.calculate(oper: "*", a: 2, b: 7)
let divideResult = calculator.calculate(oper: "/", a: 6, b: 3)
let remainderResult = calculator.calculate(oper: "%", a: 5, b: 3)

print("addResult : \(addResult)")
print("subtractResult : \(subtractResult)")
print("multiplyResult : \(multiplyResult)")
print("divideResult : \(divideResult)")
print("remainderResult: \(remainderResult)")
*/

//Lv3
class Calculator {
    let addOperation = AddOperation()
    let subtractOperation = SubtractOperation()
    let multiplyOperation = MultiplyOperation()
    let divideOperation = DivideOperation()
    
    func calculate
    (oper:String, a:Double, b:Double) -> Double {
        switch oper {
        case "+" :
            return addOperation.oper(a,b)
        case "-" :
            return subtractOperation.oper(a,b)
        case "/":
            return divideOperation.oper(a,b)
        case "*" :
            return multiplyOperation.oper(a,b)
        default:
            return 0
        }
    }
}

class AddOperation {
    func oper(_ a:Double, _ b:Double) -> Double {
        return a + b
    }
}
class SubtractOperation {
    func oper(_ a:Double, _ b:Double) -> Double {
        return a - b
    }
}
class MultiplyOperation {
    func oper(_ a:Double, _ b:Double) -> Double {
        return a * b
    }
}
class DivideOperation {
    func oper(_ a:Double, _ b:Double) -> Double {
        if b == 0 { return 0.0 }
        return a / b
    }
}

let calculator = Calculator()

let addResult = calculator.calculate(oper: "+", a: 5, b: 3)
let subtractResult = calculator.calculate(oper: "-", a: 4, b: 2)
let multiplyResult = calculator.calculate(oper: "*", a: 2, b: 7)
let divideResult = calculator.calculate(oper: "/", a: 6, b: 0)

print("addResult : \(addResult)")
print("subtractResult : \(subtractResult)")
print("multiplyResult : \(multiplyResult)")
print("divideResult : \(divideResult)")
