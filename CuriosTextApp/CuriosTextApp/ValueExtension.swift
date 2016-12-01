import Foundation
import UIKit

extension CGSize: SizeIntegerable {}
extension CGPoint: PointIntegerable {}
extension CGRect: RectIntegerable {}

//extension CGSize: Valueable {
//    
//    public typealias T = NSValue
//    
//    public func toValue() -> NSValue {
//
//        return NSValue(CGSize: CGSize(width: width, height: height))
//    }
//}
//
//extension CGPoint: Valueable {
//    
//    public typealias T = NSValue
//    
//    public func toValue() -> NSValue {
//        
//        return NSValue(CGPoint: CGPoint(x: x, y: y))
//    }
//}

public protocol Integerable {
    associatedtype T
    
    func toCeil() -> T
    func toFloor() -> T
}

public protocol Valueable {
    associatedtype T
    
    func toValue() -> T
}

public protocol SizeIntegerable: Integerable {
    
    var width: CGFloat { get }
    var height: CGFloat { get }
}

public protocol PointIntegerable: Integerable {
    
    var x: CGFloat { get }
    var y: CGFloat { get }
}

public protocol RectIntegerable: Integerable {
    
    var origin: CGPoint { get }
    var size: CGSize { get }
}

extension SizeIntegerable {
    public typealias T = CGSize
    
    public func toCeil() -> CGSize {
        return CGSize(width: ceil(width), height: ceil(height))
    }
    
    public func toFloor() -> CGSize {
        return CGSize(width: floor(width), height: floor(height))
    }
}

extension PointIntegerable {
    public typealias T = CGPoint
    
    public func toCeil() -> CGPoint {
        return CGPoint(x: ceil(x), y: ceil(y))
    }
    
    public func toFloor() -> CGPoint {
        
        return CGPoint(x: floor(x), y: floor(y))
    }
}

extension RectIntegerable {
    public typealias T = CGRect
    
    public func toCeil() -> CGRect {
        return CGRect(origin: origin.toCeil(), size: size.toCeil())
    }
    
    public func toFloor() -> CGRect {
        return CGRect(origin: origin.toFloor(), size: size.toFloor())
    }
}

