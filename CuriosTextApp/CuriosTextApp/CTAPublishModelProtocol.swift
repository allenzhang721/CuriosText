//
//  CTAPublishModelProtocol.swift
//  CuriosTextApp
//
//  Created by allen on 16/6/20.
//  Copyright © 2016年 botai. All rights reserved.
//

import Foundation

func DateString(date:NSDate) -> String{
    var time = date.timeIntervalSinceNow
    if time < 0{
        time = 0-time
    }
    var dateString:String = ""
    if time < 60{
        dateString = NSLocalizedString("PublishDateJustNow", comment: "")
    }else if time < 3600{
        let mins = Int(time / 60)
        dateString = String(mins)+NSLocalizedString("PublishDateMins", comment: "")
    }else if time < 3600*2{
        dateString = NSLocalizedString("PublishDateOneHour", comment: "")
    }else if time < 86400{
        let hours = Int(time / 3600)
        dateString = String(hours)+NSLocalizedString("PublishDateHours", comment: "")
    }else if time < 86400 * 2{
        dateString = NSLocalizedString("PublishDateYesterDay", comment: "")
    }else if time < 86400*30{
        let days = Int(time / 86400)
        dateString = String(days)+NSLocalizedString("PublishDateDays", comment: "")
    }else if time < 86400*30*2{
        dateString = NSLocalizedString("PublishDateOneMonth", comment: "")
    }else if time < 86400*365{
        let months = Int(time / (86400*30))
        dateString = String(months)+NSLocalizedString("PublishDateMonths", comment: "")
    }else if time < 86400*365*2{
        dateString = NSLocalizedString("PublishDateOneYear", comment: "")
    }else{
        let years = Int(time / (86400*365))
        dateString = String(years)+NSLocalizedString("PublishDateYears", comment: "")
    }
    return dateString
}

protocol CTAPublishModelProtocol: CTASystemLanguageProtocol{
    func getPublishIndex(publishID:String, publishArray:Array<CTAPublishModel>) -> Int
    func checkPublishModelIsHave(publish:CTAPublishModel, publishArray:Array<CTAPublishModel>) -> Bool
    func resetPublishModel(publish:CTAPublishModel, newPublish:CTAPublishModel) -> CTAPublishModel
    func removePublishModelByID(publishID:String, publishArray:Array<CTAPublishModel>) -> Array<CTAPublishModel>
    func changeCountToString(count:Int) -> String
    func changeCountToAllString(count:Int) -> String
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
    
    func checkPublishModelIsHave(publish:CTAPublishModel, publishArray:Array<CTAPublishModel>) -> Bool{
        for i in 0..<publishArray.count{
            let oldPublihModel = publishArray[i]
            if oldPublihModel.publishID == publish.publishID {
                return true
            }
        }
        return false
    }
    
    func resetPublishModel(publish:CTAPublishModel, newPublish:CTAPublishModel) -> CTAPublishModel{
        publish.commentCount = newPublish.commentCount
        publish.likeCount = newPublish.likeCount
        publish.shareCount = newPublish.shareCount
        publish.rebuildCount = newPublish.rebuildCount
        publish.likeStatus = newPublish.likeStatus
        return publish
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
    
    func changeCountToAllString(count:Int) -> String{
        let countString:String = self.getCountThStr(count)
        return countString
    }
    
    func getCountThStr(count:Int) -> String{
        var countString:String = ""
        let remainder = Int(count % 1000)
        let divided   = Int(count / 1000)
        if divided > 0{
            countString = self.getCountThStr(divided)+","+String(remainder)
        }else {
            countString = String(remainder)
        }
        return countString
    }
}