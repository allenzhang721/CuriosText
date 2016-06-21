//
//  CTAPublishModelProtocol.swift
//  CuriosTextApp
//
//  Created by allen on 16/6/20.
//  Copyright © 2016年 botai. All rights reserved.
//

import Foundation
protocol CTAPublishModelProtocol: CTASystemLanguageProtocol{
    func getPublishIndex(publishID:String, publishArray:Array<CTAPublishModel>) -> Int
    func checkPublishModelIsHave(publishID:String, publishArray:Array<CTAPublishModel>) -> Bool
    func removePublishModelByID(publishID:String, publishArray:Array<CTAPublishModel>) -> Array<CTAPublishModel>
    func changeCountToString(count:Int) -> String
}

extension CTAPublishModelProtocol{
    
    func getPublishIndex(publishID:String, publishArray:Array<CTAPublishModel>) -> Int{
        for i in 0..<publishArray.count{
            let oldPublihModel = publishArray[i]
            if oldPublihModel.publishID == publishID{
                return i
            }
        }
        return -1
    }
    
    func checkPublishModelIsHave(publishID:String, publishArray:Array<CTAPublishModel>) -> Bool{
        for i in 0..<publishArray.count{
            let oldPublihModel = publishArray[i]
            if oldPublihModel.publishID == publishID{
                return true
            }
        }
        return false
    }
    
    func removePublishModelByID(publishID:String, publishArray:Array<CTAPublishModel>) -> Array<CTAPublishModel>{
        var newArray = publishArray
        for i in 0..<newArray.count{
            let oldPublihModel = newArray[i]
            if oldPublihModel.publishID == publishID {
                newArray.removeAtIndex(i)
                break
            }
        }
        return newArray
    }
    
    func changeCountToString(count:Int) -> String{
        var countString:String = ""
        let language = self.getCurrentLanguage()
        if language == "zh-Hant-US" || language == "zh-Hans-US" || language == "zh-HK" {
            if count < 10000 {
                countString = String(count)
            }else if count < 100000000{
                if count < 1000000{
                    var countFloat = Double(count) / 10000.00
                    let countNumber = floor(countFloat*10)
                    countFloat = Double(countNumber)/10
                    if (countFloat - floor(countFloat))*10 < 1 {
                        countString = String(Int(countFloat)) + NSLocalizedString("TenThousand", comment: "")
                    }else {
                        countString = String(format: "%.1f", countFloat) + NSLocalizedString("TenThousand", comment: "")
                    }
                }else {
                    let countInt = count / 10000
                    countString = String(countInt) + NSLocalizedString("TenThousand", comment: "")
                }
            }else {
                var countFloat = Double(count) / 100000000.00
                let countNumber = floor(countFloat*10)
                countFloat = Double(countNumber)/10
                if (countFloat - floor(countFloat))*10 < 1 {
                    countString = String(Int(countFloat)) + NSLocalizedString("HundredMillion", comment: "")
                }else {
                    countString =  String(format: "%.1f", countFloat) + NSLocalizedString("HundredMillion", comment: "")
                }
            }
        }else {
            if count < 1000 {
                countString = String(count)
            }else if count < 1000000{
                if count < 100000{
                    var countFloat = Double(count) / 1000.00
                    let countNumber = floor(countFloat*10)
                    countFloat = Double(countNumber)/10
                    if (countFloat - floor(countFloat))*10 < 1 {
                        countString = String(Int(countFloat)) + NSLocalizedString("Thousand", comment: "")
                    }else {
                        countString =  String(format: "%.1f", countFloat) + NSLocalizedString("Thousand", comment: "")
                    }
                }else {
                    let countInt = count / 1000
                    countString = String(countInt) + NSLocalizedString("Thousand", comment: "")
                }
            }else if count < 1000000000{
                if count < 100000000{
                    var countFloat = Double(count) / 1000000.00
                    let countNumber = floor(countFloat*10)
                    countFloat = Double(countNumber)/10
                    if (countFloat - floor(countFloat))*10 < 1 {
                        countString = String(Int(countFloat)) + NSLocalizedString("Million", comment: "")
                    }else {
                        countString =  String(format: "%.1f", countFloat) + NSLocalizedString("Million", comment: "")
                    }
                }else {
                    let countInt = count / 1000000
                    countString = String(countInt) + NSLocalizedString("Million", comment: "")
                }
            }else {
                var countFloat = Double(count) / 1000000000.00
                let countNumber = floor(countFloat*10)
                countFloat = Double(countNumber)/10
                if (countFloat - floor(countFloat))*10 < 1 {
                    countString = String(Int(countFloat)) + NSLocalizedString("Billion", comment: "")
                }else {
                    countString =  String(format: "%.1f", countFloat) + NSLocalizedString("Billion", comment: "")
                }
            }
        }
        return countString
    }
}