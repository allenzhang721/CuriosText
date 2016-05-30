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
            title: LocalStrings.Size.description),
        
//        CTABarItem(
//            normalImage: CTAStyleKit.imageOfRotationBarItemNormal,
//            selectedImage: CTAStyleKit.imageOfRotationBarItemSelected,
//            normalColor: CTAStyleKit.normalColor,
//            selectedColor: CTAStyleKit.selectedColor,
//            title: LocalStrings.Rotation.description)
    ]
    
    // Sort Search in CTAContainerViewModel
    static let textSelectorItems = [
        
        
        CTABarItem(
            normalImage: CTAStyleKit.imageOfAnimationBarItemNormal,
            selectedImage: CTAStyleKit.imageOfAnimationBarItemSelected,
            normalColor: CTAStyleKit.normalColor,
            selectedColor: CTAStyleKit.selectedColor,
            title: LocalStrings.Animation.description),
    
        CTABarItem(
            normalImage: CTAStyleKit.imageOfFontBarItemNormal,
            selectedImage: CTAStyleKit.imageOfFontBarItemSelected,
            normalColor: CTAStyleKit.normalColor,
            selectedColor: CTAStyleKit.selectedColor,
            title: LocalStrings.Font.description),
        
        
        CTABarItem(
            normalImage: CTAStyleKit.imageOfColorBarItemNormal,
            selectedImage: CTAStyleKit.imageOfColorBarItemSelected,
            normalColor: CTAStyleKit.normalColor,
            selectedColor: CTAStyleKit.selectedColor,
            title: LocalStrings.Color.description),
        
        CTABarItem(
            normalImage: CTAStyleKit.imageOfSizeBarItemNormal,
            selectedImage: CTAStyleKit.imageOfSizeBarItemSelected,
            normalColor: CTAStyleKit.normalColor,
            selectedColor: CTAStyleKit.selectedColor,
            title: LocalStrings.Size.description),
        
        CTABarItem(
            normalImage: CTAStyleKit.imageOfRotationBarItemNormal,
            selectedImage: CTAStyleKit.imageOfRotationBarItemSelected,
            normalColor: CTAStyleKit.normalColor,
            selectedColor: CTAStyleKit.selectedColor,
            title: LocalStrings.Rotation.description),
        
        CTABarItem(
            normalImage: CTAStyleKit.imageOfSpacingBarItemNormal,
            selectedImage: CTAStyleKit.imageOfSpacingBarItemSelected,
            normalColor: CTAStyleKit.normalColor,
            selectedColor: CTAStyleKit.selectedColor,
            title: LocalStrings.Spacing.description),
        
        CTABarItem(
            normalImage: CTAStyleKit.imageOfAlignmentBarItemNormal,
            selectedImage: CTAStyleKit.imageOfAlignmentBarItemSelected,
            normalColor: CTAStyleKit.normalColor,
            selectedColor: CTAStyleKit.selectedColor,
            title: LocalStrings.Alignment.description),
        
    
    ]
}