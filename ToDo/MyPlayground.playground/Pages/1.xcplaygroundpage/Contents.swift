//: [Previous](@previous)

import Foundation

protocol T{
    
}
struct A:T {
    var b:B()
}

struct B:T{
    
}
var refe:R
if true{
//    var b = B()
    var b =  B.malloc()
    refe = b.refe
}
refe.value // B

//: [Next](@next)
