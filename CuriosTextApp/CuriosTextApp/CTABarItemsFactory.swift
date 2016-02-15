//
//  CTABarItemsFactory.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/27/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation

class CTABarItemsFactory {
    
    //Fonts, Size, Rotator, Aligments, TextSpacing, Colors, Animation
//    static let textTypes: [CTAContainerFeatureType] = [
//        .Fonts,
//        .Size,
//        .Rotator,
//        .Aligments,
//        .TextSpacing,
//        .TextSpacing,
//        .Colors,
//        .Animation
//    ]
    
    static let emptySelectorItems: [CTABarItem] = [
    
    ]
    
    static let imgSelectorItems = [
        
        CTABarItem(
            normalImage: CTAStyleKit.imageOfSizeBarItemNormal,
            selectedImage: CTAStyleKit.imageOfSizeBarItemSelected,
            normalColor: CTAStyleKit.normalColor,
            selectedColor: CTAStyleKit.selectedColor,
            title: "Size"),
        
        CTABarItem(
            normalImage: CTAStyleKit.imageOfRotationBarItemNormal,
            selectedImage: CTAStyleKit.imageOfRotationBarItemSelected,
            normalColor: CTAStyleKit.normalColor,
            selectedColor: CTAStyleKit.selectedColor,
            title: "Rotation")
    ]
    
    static let textSelectorItems = [
    
        CTABarItem(
            normalImage: CTAStyleKit.imageOfFontBarItemNormal,
            selectedImage: CTAStyleKit.imageOfFontBarItemSelected,
            normalColor: CTAStyleKit.normalColor,
            selectedColor: CTAStyleKit.selectedColor,
            title: "Font"),
        
        CTABarItem(
            normalImage: CTAStyleKit.imageOfSizeBarItemNormal,
            selectedImage: CTAStyleKit.imageOfSizeBarItemSelected,
            normalColor: CTAStyleKit.normalColor,
            selectedColor: CTAStyleKit.selectedColor,
            title: "Size"),
        
        CTABarItem(
            normalImage: CTAStyleKit.imageOfRotationBarItemNormal,
            selectedImage: CTAStyleKit.imageOfRotationBarItemSelected,
            normalColor: CTAStyleKit.normalColor,
            selectedColor: CTAStyleKit.selectedColor,
            title: "Rotation"),
        
        CTABarItem(
            normalImage: CTAStyleKit.imageOfSpacingBarItemNormal,
            selectedImage: CTAStyleKit.imageOfSpacingBarItemSelected,
            normalColor: CTAStyleKit.normalColor,
            selectedColor: CTAStyleKit.selectedColor,
            title: "Spacing"),
        
        CTABarItem(
            normalImage: CTAStyleKit.imageOfAlignmentBarItemNormal,
            selectedImage: CTAStyleKit.imageOfAlignmentBarItemSelected,
            normalColor: CTAStyleKit.normalColor,
            selectedColor: CTAStyleKit.selectedColor,
            title: "Alignment"),
        
        CTABarItem(
            normalImage: CTAStyleKit.imageOfColorBarItemNormal,
            selectedImage: CTAStyleKit.imageOfColorBarItemSelected,
            normalColor: CTAStyleKit.normalColor,
            selectedColor: CTAStyleKit.selectedColor,
            title: "Color"),
        
        CTABarItem(
            normalImage: CTAStyleKit.imageOfAnimationBarItemNormal,
            selectedImage: CTAStyleKit.imageOfAnimationBarItemSelected,
            normalColor: CTAStyleKit.normalColor,
            selectedColor: CTAStyleKit.selectedColor,
            title: "Animation")
    
    ]
}