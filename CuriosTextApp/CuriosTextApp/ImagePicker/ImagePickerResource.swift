//
//  ImagePickerResource.swift
//  ImagePicker
//
//  Created by Emiaostein on 3/1/16.
//  Copyright (c) 2016 com.botai. All rights reserved.
//
//  Generated by PaintCode (www.paintcodeapp.com)
//



import UIKit

public class ImagePickerResource : NSObject {

    //// Cache

    private struct Cache {
        static var imageOfCamera: UIImage?
        static var imageOfCameraSelected: UIImage?
        static var cameraTargets: [AnyObject]?
        static var imageOfPhotoLibrary: UIImage?
        static var imageOfPhotoLibrarySelected: UIImage?
        static var photoLibraryTargets: [AnyObject]?
    }

    //// Drawing Methods

    public class func drawCamera(color: UIColor = UIColor.blackColor()) {
        //// Color Declarations
        let fillColor = color

        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPointMake(24.89, 3.33))
        bezierPath.addCurveToPoint(CGPointMake(26.4, 3.92), controlPoint1: CGPointMake(25.5, 3.33), controlPoint2: CGPointMake(26, 3.53))
        bezierPath.addCurveToPoint(CGPointMake(27, 5.49), controlPoint1: CGPointMake(26.8, 4.32), controlPoint2: CGPointMake(27, 4.84))
        bezierPath.addLineToPoint(CGPointMake(27, 17.71))
        bezierPath.addCurveToPoint(CGPointMake(26.4, 19.34), controlPoint1: CGPointMake(27, 18.36), controlPoint2: CGPointMake(26.8, 18.9))
        bezierPath.addCurveToPoint(CGPointMake(24.89, 20), controlPoint1: CGPointMake(26, 19.78), controlPoint2: CGPointMake(25.5, 20))
        bezierPath.addLineToPoint(CGPointMake(2.39, 20))
        bezierPath.addCurveToPoint(CGPointMake(0.7, 19.31), controlPoint1: CGPointMake(1.73, 20), controlPoint2: CGPointMake(1.17, 19.77))
        bezierPath.addCurveToPoint(CGPointMake(0, 17.71), controlPoint1: CGPointMake(0.23, 18.84), controlPoint2: CGPointMake(0, 18.31))
        bezierPath.addLineToPoint(CGPointMake(0, 5.49))
        bezierPath.addCurveToPoint(CGPointMake(0.7, 3.96), controlPoint1: CGPointMake(0, 4.88), controlPoint2: CGPointMake(0.23, 4.38))
        bezierPath.addCurveToPoint(CGPointMake(2.39, 3.33), controlPoint1: CGPointMake(1.17, 3.54), controlPoint2: CGPointMake(1.73, 3.33))
        bezierPath.addLineToPoint(CGPointMake(3.3, 3.33))
        bezierPath.addLineToPoint(CGPointMake(3.3, 2.22))
        bezierPath.addLineToPoint(CGPointMake(5.7, 2.22))
        bezierPath.addLineToPoint(CGPointMake(5.7, 3.33))
        bezierPath.addLineToPoint(CGPointMake(6.61, 3.33))
        bezierPath.addCurveToPoint(CGPointMake(9.18, 0.62), controlPoint1: CGPointMake(7.83, 1.94), controlPoint2: CGPointMake(8.68, 1.04))
        bezierPath.addCurveToPoint(CGPointMake(10.48, 0), controlPoint1: CGPointMake(9.67, 0.21), controlPoint2: CGPointMake(10.1, 0))
        bezierPath.addLineToPoint(CGPointMake(16.66, 0))
        bezierPath.addCurveToPoint(CGPointMake(17.96, 0.62), controlPoint1: CGPointMake(17.04, 0), controlPoint2: CGPointMake(17.47, 0.21))
        bezierPath.addCurveToPoint(CGPointMake(20.53, 3.33), controlPoint1: CGPointMake(18.46, 1.04), controlPoint2: CGPointMake(19.31, 1.94))
        bezierPath.addLineToPoint(CGPointMake(24.89, 3.33))
        bezierPath.closePath()
        bezierPath.moveToPoint(CGPointMake(25.88, 17.71))
        bezierPath.addLineToPoint(CGPointMake(25.88, 5.49))
        bezierPath.addCurveToPoint(CGPointMake(24.89, 4.44), controlPoint1: CGPointMake(25.88, 4.79), controlPoint2: CGPointMake(25.55, 4.44))
        bezierPath.addLineToPoint(CGPointMake(20.53, 4.44))
        bezierPath.addLineToPoint(CGPointMake(20.04, 4.44))
        bezierPath.addLineToPoint(CGPointMake(19.69, 4.24))
        bezierPath.addCurveToPoint(CGPointMake(18.98, 3.47), controlPoint1: CGPointMake(19.55, 4.05), controlPoint2: CGPointMake(19.31, 3.8))
        bezierPath.addCurveToPoint(CGPointMake(17.96, 2.29), controlPoint1: CGPointMake(18.7, 3.15), controlPoint2: CGPointMake(18.36, 2.75))
        bezierPath.addCurveToPoint(CGPointMake(17.16, 1.39), controlPoint1: CGPointMake(17.57, 1.83), controlPoint2: CGPointMake(17.3, 1.53))
        bezierPath.addLineToPoint(CGPointMake(16.66, 1.11))
        bezierPath.addLineToPoint(CGPointMake(10.48, 1.11))
        bezierPath.addCurveToPoint(CGPointMake(9.98, 1.39), controlPoint1: CGPointMake(10.38, 1.11), controlPoint2: CGPointMake(10.22, 1.2))
        bezierPath.addCurveToPoint(CGPointMake(8.23, 3.26), controlPoint1: CGPointMake(9.66, 1.67), controlPoint2: CGPointMake(9.07, 2.29))
        bezierPath.addCurveToPoint(CGPointMake(7.45, 4.24), controlPoint1: CGPointMake(7.8, 3.82), controlPoint2: CGPointMake(7.55, 4.14))
        bezierPath.addLineToPoint(CGPointMake(7.1, 4.44))
        bezierPath.addLineToPoint(CGPointMake(6.61, 4.44))
        bezierPath.addLineToPoint(CGPointMake(2.39, 4.44))
        bezierPath.addCurveToPoint(CGPointMake(1.51, 4.76), controlPoint1: CGPointMake(2.06, 4.44), controlPoint2: CGPointMake(1.77, 4.55))
        bezierPath.addCurveToPoint(CGPointMake(1.12, 5.49), controlPoint1: CGPointMake(1.25, 4.97), controlPoint2: CGPointMake(1.12, 5.21))
        bezierPath.addLineToPoint(CGPointMake(1.12, 17.71))
        bezierPath.addCurveToPoint(CGPointMake(1.51, 18.54), controlPoint1: CGPointMake(1.12, 18.03), controlPoint2: CGPointMake(1.25, 18.31))
        bezierPath.addCurveToPoint(CGPointMake(2.39, 18.89), controlPoint1: CGPointMake(1.77, 18.77), controlPoint2: CGPointMake(2.06, 18.89))
        bezierPath.addLineToPoint(CGPointMake(24.89, 18.89))
        bezierPath.addCurveToPoint(CGPointMake(25.88, 17.71), controlPoint1: CGPointMake(25.55, 18.89), controlPoint2: CGPointMake(25.88, 18.5))
        bezierPath.closePath()
        bezierPath.moveToPoint(CGPointMake(13.5, 5.42))
        bezierPath.addCurveToPoint(CGPointMake(17.75, 7.15), controlPoint1: CGPointMake(15.14, 5.42), controlPoint2: CGPointMake(16.56, 6))
        bezierPath.addCurveToPoint(CGPointMake(19.55, 11.32), controlPoint1: CGPointMake(18.95, 8.31), controlPoint2: CGPointMake(19.55, 9.7))
        bezierPath.addCurveToPoint(CGPointMake(17.75, 15.49), controlPoint1: CGPointMake(19.55, 12.94), controlPoint2: CGPointMake(18.95, 14.33))
        bezierPath.addCurveToPoint(CGPointMake(13.5, 17.22), controlPoint1: CGPointMake(16.56, 16.64), controlPoint2: CGPointMake(15.14, 17.22))
        bezierPath.addCurveToPoint(CGPointMake(9.25, 15.49), controlPoint1: CGPointMake(11.86, 17.22), controlPoint2: CGPointMake(10.44, 16.64))
        bezierPath.addCurveToPoint(CGPointMake(7.45, 11.32), controlPoint1: CGPointMake(8.05, 14.33), controlPoint2: CGPointMake(7.45, 12.94))
        bezierPath.addCurveToPoint(CGPointMake(9.25, 7.15), controlPoint1: CGPointMake(7.45, 9.7), controlPoint2: CGPointMake(8.05, 8.31))
        bezierPath.addCurveToPoint(CGPointMake(13.5, 5.42), controlPoint1: CGPointMake(10.44, 6), controlPoint2: CGPointMake(11.86, 5.42))
        bezierPath.closePath()
        bezierPath.moveToPoint(CGPointMake(13.5, 16.11))
        bezierPath.addCurveToPoint(CGPointMake(16.98, 14.69), controlPoint1: CGPointMake(14.86, 16.11), controlPoint2: CGPointMake(16.02, 15.64))
        bezierPath.addCurveToPoint(CGPointMake(18.42, 11.32), controlPoint1: CGPointMake(17.94, 13.74), controlPoint2: CGPointMake(18.42, 12.62))
        bezierPath.addCurveToPoint(CGPointMake(16.98, 7.95), controlPoint1: CGPointMake(18.42, 10.02), controlPoint2: CGPointMake(17.94, 8.9))
        bezierPath.addCurveToPoint(CGPointMake(13.5, 6.53), controlPoint1: CGPointMake(16.02, 7), controlPoint2: CGPointMake(14.86, 6.53))
        bezierPath.addCurveToPoint(CGPointMake(10.02, 7.95), controlPoint1: CGPointMake(12.14, 6.53), controlPoint2: CGPointMake(10.98, 7))
        bezierPath.addCurveToPoint(CGPointMake(8.58, 11.32), controlPoint1: CGPointMake(9.06, 8.9), controlPoint2: CGPointMake(8.58, 10.02))
        bezierPath.addCurveToPoint(CGPointMake(10.02, 14.69), controlPoint1: CGPointMake(8.58, 12.62), controlPoint2: CGPointMake(9.06, 13.74))
        bezierPath.addCurveToPoint(CGPointMake(13.5, 16.11), controlPoint1: CGPointMake(10.98, 15.64), controlPoint2: CGPointMake(12.14, 16.11))
        bezierPath.closePath()
        bezierPath.moveToPoint(CGPointMake(20.25, 6.74))
        bezierPath.addLineToPoint(CGPointMake(20.25, 5.56))
        bezierPath.addLineToPoint(CGPointMake(21.45, 5.56))
        bezierPath.addLineToPoint(CGPointMake(21.45, 6.74))
        bezierPath.addLineToPoint(CGPointMake(20.25, 6.74))
        bezierPath.closePath()
        bezierPath.moveToPoint(CGPointMake(11.25, 11.32))
        bezierPath.addCurveToPoint(CGPointMake(13.5, 9.1), controlPoint1: CGPointMake(11.25, 9.84), controlPoint2: CGPointMake(12, 9.1))
        bezierPath.addCurveToPoint(CGPointMake(15.75, 11.32), controlPoint1: CGPointMake(15, 9.1), controlPoint2: CGPointMake(15.75, 9.84))
        bezierPath.addCurveToPoint(CGPointMake(13.5, 13.54), controlPoint1: CGPointMake(15.75, 12.8), controlPoint2: CGPointMake(15, 13.54))
        bezierPath.addCurveToPoint(CGPointMake(11.25, 11.32), controlPoint1: CGPointMake(12, 13.54), controlPoint2: CGPointMake(11.25, 12.8))
        bezierPath.closePath()
        bezierPath.miterLimit = 4;

        fillColor.setFill()
        bezierPath.fill()
    }

    public class func drawPhotoLibrary(color: UIColor = UIColor.blackColor()) {
        //// Color Declarations
        let fillColor = color

        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPointMake(0, 0))
        bezierPath.addLineToPoint(CGPointMake(0, 20))
        bezierPath.addLineToPoint(CGPointMake(20, 20))
        bezierPath.addLineToPoint(CGPointMake(20, 0))
        bezierPath.addLineToPoint(CGPointMake(0, 0))
        bezierPath.closePath()
        bezierPath.moveToPoint(CGPointMake(0.8, 12.59))
        bezierPath.addLineToPoint(CGPointMake(6.42, 6.44))
        bezierPath.addLineToPoint(CGPointMake(11.94, 12.24))
        bezierPath.addLineToPoint(CGPointMake(14.75, 9.76))
        bezierPath.addLineToPoint(CGPointMake(18.92, 14.15))
        bezierPath.addLineToPoint(CGPointMake(0.8, 14.15))
        bezierPath.addLineToPoint(CGPointMake(0.8, 12.59))
        bezierPath.closePath()
        bezierPath.moveToPoint(CGPointMake(19.2, 19.17))
        bezierPath.addLineToPoint(CGPointMake(0.8, 19.17))
        bezierPath.addLineToPoint(CGPointMake(0.8, 14.98))
        bezierPath.addLineToPoint(CGPointMake(19.2, 14.98))
        bezierPath.addLineToPoint(CGPointMake(19.2, 19.17))
        bezierPath.closePath()
        bezierPath.moveToPoint(CGPointMake(19.2, 13.27))
        bezierPath.addLineToPoint(CGPointMake(14.85, 8.59))
        bezierPath.addLineToPoint(CGPointMake(12.04, 11.07))
        bezierPath.addLineToPoint(CGPointMake(6.42, 5.27))
        bezierPath.addLineToPoint(CGPointMake(0.8, 11.37))
        bezierPath.addLineToPoint(CGPointMake(0.8, 0.83))
        bezierPath.addLineToPoint(CGPointMake(19.2, 0.83))
        bezierPath.addLineToPoint(CGPointMake(19.2, 13.27))
        bezierPath.closePath()
        bezierPath.moveToPoint(CGPointMake(14.8, 6.68))
        bezierPath.addCurveToPoint(CGPointMake(15.57, 6.51), controlPoint1: CGPointMake(15.08, 6.68), controlPoint2: CGPointMake(15.34, 6.63))
        bezierPath.addCurveToPoint(CGPointMake(16.21, 6.05), controlPoint1: CGPointMake(15.81, 6.4), controlPoint2: CGPointMake(16.02, 6.24))
        bezierPath.addCurveToPoint(CGPointMake(16.63, 5.41), controlPoint1: CGPointMake(16.39, 5.89), controlPoint2: CGPointMake(16.53, 5.67))
        bezierPath.addCurveToPoint(CGPointMake(16.77, 4.59), controlPoint1: CGPointMake(16.72, 5.15), controlPoint2: CGPointMake(16.77, 4.88))
        bezierPath.addCurveToPoint(CGPointMake(16.63, 3.78), controlPoint1: CGPointMake(16.77, 4.29), controlPoint2: CGPointMake(16.72, 4.02))
        bezierPath.addCurveToPoint(CGPointMake(16.21, 3.12), controlPoint1: CGPointMake(16.53, 3.54), controlPoint2: CGPointMake(16.39, 3.32))
        bezierPath.addCurveToPoint(CGPointMake(15.57, 2.66), controlPoint1: CGPointMake(16.02, 2.93), controlPoint2: CGPointMake(15.81, 2.77))
        bezierPath.addCurveToPoint(CGPointMake(14.8, 2.49), controlPoint1: CGPointMake(15.34, 2.54), controlPoint2: CGPointMake(15.08, 2.49))
        bezierPath.addCurveToPoint(CGPointMake(14, 2.66), controlPoint1: CGPointMake(14.52, 2.49), controlPoint2: CGPointMake(14.25, 2.54))
        bezierPath.addCurveToPoint(CGPointMake(13.35, 3.12), controlPoint1: CGPointMake(13.75, 2.77), controlPoint2: CGPointMake(13.54, 2.93))
        bezierPath.addCurveToPoint(CGPointMake(12.95, 3.78), controlPoint1: CGPointMake(13.19, 3.32), controlPoint2: CGPointMake(13.06, 3.54))
        bezierPath.addCurveToPoint(CGPointMake(12.79, 4.59), controlPoint1: CGPointMake(12.84, 4.02), controlPoint2: CGPointMake(12.79, 4.29))
        bezierPath.addCurveToPoint(CGPointMake(12.95, 5.41), controlPoint1: CGPointMake(12.79, 4.88), controlPoint2: CGPointMake(12.84, 5.15))
        bezierPath.addCurveToPoint(CGPointMake(13.35, 6.05), controlPoint1: CGPointMake(13.06, 5.67), controlPoint2: CGPointMake(13.19, 5.89))
        bezierPath.addCurveToPoint(CGPointMake(14, 6.51), controlPoint1: CGPointMake(13.54, 6.24), controlPoint2: CGPointMake(13.75, 6.4))
        bezierPath.addCurveToPoint(CGPointMake(14.8, 6.68), controlPoint1: CGPointMake(14.25, 6.63), controlPoint2: CGPointMake(14.52, 6.68))
        bezierPath.closePath()
        bezierPath.moveToPoint(CGPointMake(14.8, 3.32))
        bezierPath.addCurveToPoint(CGPointMake(15.27, 3.41), controlPoint1: CGPointMake(14.96, 3.32), controlPoint2: CGPointMake(15.11, 3.35))
        bezierPath.addCurveToPoint(CGPointMake(15.64, 3.71), controlPoint1: CGPointMake(15.43, 3.48), controlPoint2: CGPointMake(15.55, 3.58))
        bezierPath.addCurveToPoint(CGPointMake(15.88, 4.1), controlPoint1: CGPointMake(15.74, 3.8), controlPoint2: CGPointMake(15.82, 3.93))
        bezierPath.addCurveToPoint(CGPointMake(15.97, 4.59), controlPoint1: CGPointMake(15.94, 4.26), controlPoint2: CGPointMake(15.97, 4.42))
        bezierPath.addCurveToPoint(CGPointMake(15.88, 5.1), controlPoint1: CGPointMake(15.97, 4.78), controlPoint2: CGPointMake(15.94, 4.95))
        bezierPath.addCurveToPoint(CGPointMake(15.64, 5.46), controlPoint1: CGPointMake(15.82, 5.24), controlPoint2: CGPointMake(15.74, 5.37))
        bezierPath.addCurveToPoint(CGPointMake(15.27, 5.76), controlPoint1: CGPointMake(15.55, 5.59), controlPoint2: CGPointMake(15.43, 5.69))
        bezierPath.addCurveToPoint(CGPointMake(14.8, 5.85), controlPoint1: CGPointMake(15.11, 5.82), controlPoint2: CGPointMake(14.96, 5.85))
        bezierPath.addCurveToPoint(CGPointMake(14.31, 5.76), controlPoint1: CGPointMake(14.61, 5.85), controlPoint2: CGPointMake(14.45, 5.82))
        bezierPath.addCurveToPoint(CGPointMake(13.91, 5.46), controlPoint1: CGPointMake(14.17, 5.69), controlPoint2: CGPointMake(14.04, 5.59))
        bezierPath.addCurveToPoint(CGPointMake(13.68, 5.1), controlPoint1: CGPointMake(13.82, 5.37), controlPoint2: CGPointMake(13.74, 5.24))
        bezierPath.addCurveToPoint(CGPointMake(13.58, 4.59), controlPoint1: CGPointMake(13.61, 4.95), controlPoint2: CGPointMake(13.58, 4.78))
        bezierPath.addCurveToPoint(CGPointMake(13.68, 4.1), controlPoint1: CGPointMake(13.58, 4.42), controlPoint2: CGPointMake(13.61, 4.26))
        bezierPath.addCurveToPoint(CGPointMake(13.91, 3.71), controlPoint1: CGPointMake(13.74, 3.93), controlPoint2: CGPointMake(13.82, 3.8))
        bezierPath.addCurveToPoint(CGPointMake(14.31, 3.41), controlPoint1: CGPointMake(14.04, 3.58), controlPoint2: CGPointMake(14.17, 3.48))
        bezierPath.addCurveToPoint(CGPointMake(14.8, 3.32), controlPoint1: CGPointMake(14.45, 3.35), controlPoint2: CGPointMake(14.61, 3.32))
        bezierPath.closePath()
        bezierPath.miterLimit = 4;

        fillColor.setFill()
        bezierPath.fill()
    }

    //// Generated Images

    public class var imageOfCamera: UIImage {
        if Cache.imageOfCamera != nil {
            return Cache.imageOfCamera!
        }

        UIGraphicsBeginImageContextWithOptions(CGSizeMake(27, 20), false, 0)
            ImagePickerResource.drawCamera()

        Cache.imageOfCamera = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return Cache.imageOfCamera!
    }
    
    public class var imageOfCameraSelected: UIImage {
        if Cache.imageOfCameraSelected != nil {
            return Cache.imageOfCameraSelected!
        }
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(27, 20), false, 0)
        ImagePickerResource.drawCamera(UIColor.redColor())
        
        Cache.imageOfCameraSelected = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return Cache.imageOfCameraSelected!
    }

    public class var imageOfPhotoLibrary: UIImage {
        if Cache.imageOfPhotoLibrary != nil {
            return Cache.imageOfPhotoLibrary!
        }

        UIGraphicsBeginImageContextWithOptions(CGSizeMake(20, 20), false, 0)
            ImagePickerResource.drawPhotoLibrary()

        Cache.imageOfPhotoLibrary = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return Cache.imageOfPhotoLibrary!
    }
    
    public class var imageOfPhotoLibrarySelected: UIImage {
        if Cache.imageOfPhotoLibrarySelected != nil {
            return Cache.imageOfPhotoLibrarySelected!
        }
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(20, 20), false, 0)
        ImagePickerResource.drawPhotoLibrary(UIColor.redColor())
        
        Cache.imageOfPhotoLibrarySelected = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return Cache.imageOfPhotoLibrarySelected!
    }

    //// Customization Infrastructure

    @IBOutlet var cameraTargets: [AnyObject]! {
        get { return Cache.cameraTargets }
        set {
            Cache.cameraTargets = newValue
            for target: AnyObject in newValue {
                target.performSelector("setImage:", withObject: ImagePickerResource.imageOfCamera)
            }
        }
    }

    @IBOutlet var photoLibraryTargets: [AnyObject]! {
        get { return Cache.photoLibraryTargets }
        set {
            Cache.photoLibraryTargets = newValue
            for target: AnyObject in newValue {
                target.performSelector("setImage:", withObject: ImagePickerResource.imageOfPhotoLibrary)
            }
        }
    }

}
