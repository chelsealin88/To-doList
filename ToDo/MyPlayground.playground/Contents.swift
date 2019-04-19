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


//func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//    
////    let cell = tableView.cellForRow(at: indexPath) as! jobCell
//    
//    //Check condition and change value of jobStatus
//    
//    if jobComplete == ["true"] {
//        let jobUncompleteAction = UIContextualAction(style: .normal, title: "Uncomplete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
//            print("Job Complete")
//            success(true)
//            
//            self.jobComplete = false
//            
//        })
//        
//        jobUncompleteAction.backgroundColor = UIColor(red:0.80, green:0.00, blue:0.00, alpha:1.0)
//        return UISwipeActionsConfiguration(actions: [jobUncompleteAction])
//        
//        
//    } else {
//        
//        
//        let jobCompleteAction = UIContextualAction(style: .normal, title: "Complete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
//            print("Job Complete")
//            success(true)
//            
//            self.jobComplete = true
//        })
//        
//        jobUncompleteAction.backgroundColor = UIColor(red:0.00, green:0.61, blue:0.02, alpha:1.0)
//        return UISwipeActionsConfiguration(actions: [jobCompleteAction])
//    }
//}
