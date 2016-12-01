//
//  CTABarItemsFactory.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/27/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation
import UIKit

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
            normalImage: CTAStyleKit.imageOfTemplatesNormal,
            selectedImage: CTAStyleKit.imageOfTemplatesSelected,
            normalColor: CTAStyleKit.normalColor,
            selectedColor: CTAStyleKit.selectedColor,
            title: LocalStrings.templates.description),
        
        CTABarItem(
            normalImage: UIImage(named: "filters_Normal")!,
            selectedImage: UIImage(named: "filters_Selected")!,
            normalColor: CTAStyleKit.normalColor,
            selectedColor: CTAStyleKit.selectedColor,
            title: LocalStrings.filters.description),
        
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
            title: LocalStrings.animation.description),
    
        CTABarItem(
            normalImage: CTAStyleKit.imageOfFontBarItemNormal,
            selectedImage: CTAStyleKit.imageOfFontBarItemSelected,
            normalColor: CTAStyleKit.normalColor,
            selectedColor: CTAStyleKit.selectedColor,
            title: LocalStrings.font.description),
        
        
        CTABarItem(
            normalImage: CTAStyleKit.imageOfColorBarItemNormal,
            selectedImage: CTAStyleKit.imageOfColorBarItemSelected,
            normalColor: CTAStyleKit.normalColor,
            selectedColor: CTAStyleKit.selectedColor,
            title: LocalStrings.color.description),
        
        CTABarItem(
            normalImage: UIImage(named:"alpha_Normal")!,
            selectedImage: UIImage(named:"alpha_Selected")!,
            normalColor: CTAStyleKit.normalColor,
            selectedColor: CTAStyleKit.selectedColor,
            title: LocalStrings.alpha.description),
        
        CTABarItem(
            normalImage: CTAStyleKit.imageOfSizeBarItemNormal,
            selectedImage: CTAStyleKit.imageOfSizeBarItemSelected,
            normalColor: CTAStyleKit.normalColor,
            selectedColor: CTAStyleKit.selectedColor,
            title: LocalStrings.size.description),
        
        CTABarItem(
            normalImage: CTAStyleKit.imageOfRotationBarItemNormal,
            selectedImage: CTAStyleKit.imageOfRotationBarItemSelected,
            normalColor: CTAStyleKit.normalColor,
            selectedColor: CTAStyleKit.selectedColor,
            title: LocalStrings.rotation.description),
        
        CTABarItem(
            normalImage: CTAStyleKit.imageOfSpacingBarItemNormal,
            selectedImage: CTAStyleKit.imageOfSpacingBarItemSelected,
            normalColor: CTAStyleKit.normalColor,
            selectedColor: CTAStyleKit.selectedColor,
            title: LocalStrings.spacing.description),
        
        CTABarItem(
            normalImage: CTAStyleKit.imageOfAlignmentBarItemNormal,
            selectedImage: CTAStyleKit.imageOfAlignmentBarItemSelected,
            normalColor: CTAStyleKit.normalColor,
            selectedColor: CTAStyleKit.selectedColor,
            title: LocalStrings.alignment.description),
        
//        CTABarItem(
//            normalImage: UIImage(named: "shadow_Normal")!,
//            selectedImage: UIImage(named: "shadow_Selected")!,
//            normalColor: CTAStyleKit.normalColor,
//            selectedColor: CTAStyleKit.selectedColor,
//            title: LocalStrings.Shadow.description),
    
    ]
}
