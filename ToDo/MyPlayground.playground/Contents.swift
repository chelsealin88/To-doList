import UIKit

var str = "Hello, playground"


 func strikeThroughText (_ text:String) -> NSAttributedString {
    
    let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: text)
    attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
    return attributeString
}

 func normalText (_ text:String) -> NSAttributedString {
    
    let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: text)
//    attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
    return attributeString
}

strikeThroughText("test")
normalText("normal")
