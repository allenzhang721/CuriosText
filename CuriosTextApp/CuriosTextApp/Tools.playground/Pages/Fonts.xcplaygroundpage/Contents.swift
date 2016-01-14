//: [Previous](@previous)

import Foundation
import UIKit

let families = UIFont.familyNames()

let valildFamilies = families.filter {UIFont.fontNamesForFamilyName($0).count > 0}

//: [Next](@next)
