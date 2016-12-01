//
//  LocaleHelper.swift
//  CountryFilter
//
//  Created by Emiaostein on 15/8/25.
//  Copyright (c) 2015年 BoTai Technology. All rights reserved.
//

import Foundation

struct CountryLocale {
  
  let displayName: String
  let countryCode: String
  let languageCode: String
  let transformLatin: String
  let initialWord: String
  
}

struct CountryZone {
  let displayName: String
  let zoneCode: String
  let transiformLatin: String
}

 func transfromStringToLatin(_ string: String) -> String {
  let transformContents = CFStringCreateMutableCopy(nil, 0, string as CFString!)
  CFStringTransform(transformContents, nil, kCFStringTransformToLatin, false)
//  let traStr:String = transformContents as String
  let traStr:String = String(describing: transformContents)
  return traStr
}

class LocaleHelper {
  
  static func transformCountryDisplayNameToLatin(_ countryName: String) -> String {
    return transfromStringToLatin(countryName)
  }
  
  class func allCountriesFromLocalFile() -> Dictionary<String, Array<CountryZone>> {
    
    let countriesFilePath = Bundle.main.path(forResource: "Countries", ofType: "plist")!
    let dic = NSDictionary(contentsOfFile: countriesFilePath) as! Dictionary<String, Array<String>>
    
    var con = Dictionary<String, Array<CountryZone>>()
    for (key, countries) in dic {
      let sortCountries = countries.sorted(by: <)
      let countryZones = sortCountries
          
          .map { string -> CountryZone in
        let component = string.components(separatedBy: "+")
        let name = component.first!
        let zoneCode = component.last!
        let latin = self.transformCountryDisplayNameToLatin(name)
        return CountryZone(displayName: name, zoneCode: zoneCode, transiformLatin: latin)
      }
      con[key] = countryZones
    }
    return con
  }
  
  class func AllCountryLocale() -> [CountryLocale] {
  
    let localIdentifiers = Locale.availableIdentifiers 
    
    let countryLocales = localIdentifiers
      
  .filter { indentifier -> Bool in
      let compoent = Locale.components(fromIdentifier: indentifier)
      let countryCode = compoent["kCFLocaleCountryCodeKey"]
      return (countryCode?.isEmpty != nil)
    }
  .map { identifer -> CountryLocale in
      let compoent = Locale.components(fromIdentifier: identifer)
      let countryCode = compoent["kCFLocaleCountryCodeKey"] ?? ""
      let languageCode = compoent["kCFLocaleLanguageCodeKey"] ?? ""
      let otherLocal = Locale(identifier: identifer)
      let displayName =  (otherLocal as NSLocale).displayName(forKey: NSLocale.Key.countryCode, value: countryCode)!
      let latin = self.transformCountryDisplayNameToLatin(displayName)
//      let index = advance(latin.startIndex, 1)
      let index = latin.characters.index(latin.startIndex, offsetBy: 1)
      let initialWord = latin.uppercased().substring(to: index)
      return CountryLocale(displayName: displayName, countryCode: countryCode, languageCode: languageCode, transformLatin: latin, initialWord: initialWord)
  }
    
    return countryLocales
  }
}
