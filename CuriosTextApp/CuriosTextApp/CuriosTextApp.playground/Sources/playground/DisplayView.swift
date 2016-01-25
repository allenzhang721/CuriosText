import Foundation
import UIKit
import XCPlayground

public func display(view: UIView) {
    
    XCPlaygroundPage.currentPage.liveView = view
}

public class ViewController: UIViewController {
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.blueColor()
    }
}