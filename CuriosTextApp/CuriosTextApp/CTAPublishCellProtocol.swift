//
//  CTAPublishCellProtocol.swift
//  CuriosTextApp
//
//  Created by allen on 16/1/21.
//  Copyright © 2016年 botai. All rights reserved.
//

import UIKit

let cellScale:CGFloat = 0.8

protocol CTAPublishCellProtocol{
    func getHorRate() -> CGFloat
    func getVerRate() -> CGFloat
    func getHorSpace() -> CGFloat
    func getVerSpace() -> CGFloat
    func getCellCount() -> Int
    func getCellSpace() -> CGFloat
    func getCellRect() -> CGSize
    func getFullCellRect(cellRect:CGSize?, rate:CGFloat) -> CGSize
    func getFullVerSpace() -> CGFloat
    func getFullHorSpace() -> CGFloat
}

extension CTAPublishCellProtocol{
    func getHorRate() -> CGFloat{
        let rate =  UIScreen.mainScreen().bounds.width / 375
        return rate
    }
    
    func getVerRate() -> CGFloat{
        let rate =  UIScreen.mainScreen().bounds.height / 667
        return rate
    }
    
    func getHorSpace() -> CGFloat{
        let minCellRect:CGSize = self.getCellRect()
        let cellspace = self.getCellSpace()
        let minHorSpace = cellspace + minCellRect.width
        return minHorSpace
    }
    
    func getVerSpace() -> CGFloat{
        let minCellRect:CGSize = self.getCellRect()
        let cellspace = self.getCellSpace()
        let minVerSpace =  cellspace + minCellRect.height
        return minVerSpace
    }
    
    func getCellCount() -> Int{
        let space = self.getCellSpace()
        let rect  = self.getCellRect()
        let screenHeight = UIScreen.mainScreen().bounds.height
        let countFloat = (screenHeight+space) / (rect.height + space)
        let countInt   = Int(countFloat)
        let count = (countInt+1) * 3
        return count
    }
    
    func getCellSpace() -> CGFloat{
        let screenWidth = UIScreen.mainScreen().bounds.width
        let space:CGFloat = 2.00/375.00*screenWidth
        return space
    }
    
    func getCellRect() -> CGSize{
        let screenWidth = UIScreen.mainScreen().bounds.width
        let space = getCellSpace()
        let itemWidth = (screenWidth - space*3)/3
        return CGSize.init(width: itemWidth, height: itemWidth)
    }
    
    func getFullCellRect(cellRect:CGSize?, rate:CGFloat) -> CGSize{
        let fullWidth  = 371 * self.getHorRate()
        var fullHeight:CGFloat
        if cellRect == nil{
            fullHeight = fullWidth
        }else {
            fullHeight = cellRect!.height * fullWidth / cellRect!.width
        }
        return CGSize.init(width: fullWidth * rate, height: fullHeight * rate)
    }
    
    func getFullVerSpace() -> CGFloat{
        let midY = UIScreen.mainScreen().bounds.height / 2
        let fullSize = self.getFullCellRect(nil , rate: 1)
        let space = (midY - (90 - fullSize.height / 2))
        return space
    }
    
    func getFullHorSpace() -> CGFloat{
//        let minRect:CGSize = self.getCellRect()
//        let minHorSpace = self.getHorSpace()
//        let rect = self.getFullCellRect(minRect, rate: 1.0)
//        let space = minHorSpace * rect.width / minRect.width
        let space = self.getFullVerSpace()
        return space
    }
}