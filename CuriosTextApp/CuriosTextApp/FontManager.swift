//
//  FontManager.swift
//  FontsManager
//
//  Created by Emiaostein on 4/11/16.
//  Copyright © 2016 Emiaostein. All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct FontInfo: FontInfoAttributes {
    
    let familyName: String
    let fullName: String
    let postscriptName: String
    let copyRight: String
    let style: String
    let size: String
    let version: String
}

protocol FontInfoAttributes {
    
    var familyName: String { get }
    var fullName: String { get }
    var postscriptName: String { get }
    var copyRight: String { get }
    var style: String { get }
    var version: String { get }
}

protocol FontManagerInterface {

}

class FontManager {
    
    enum FontManagerError {
        case fileNotFound
        case insufficientPermissions
        case unrecognizedFormat
        case invalidFontData
        case notRegistered
        case inUse
        case systemRequired
    }
    
    enum FontManagerRegisteResult {
        case success(FontInfoAttributes)
        case failture(FontManagerError)
    }
    
    fileprivate static let defaultFontFamiliesListName = "com.botai.deaultFontFamiliesName"
    static let share = FontManager()
    fileprivate let record: DataController
    
    fileprivate init() {
        record = DataController()
        
    }
    
    @objc func notiRegisteredFontsDidChanged(_ noti: Notification) {
        
//        print(noti)
//        
//        guard noti.name == kCTFontManagerRegisteredFontsChangedNotification as String else { return }
//        guard let userInfo = noti.userInfo, let fontURLs = userInfo["CTFontManagerAvailableFontURLsAdded"] as? [NSURL] else { return }
//        
//        for url in fontURLs {
//            if let descriptor = CTFontManagerCreateFontDescriptorsFromURL(url) {
////                let r = CTFontDescriptorCopyAttributes(descriptor)
//            }
//            
//        }
        
    }
    
    class func cleanCacheFamily() {
        share._cleanFontFamily()
    }
    
    class func cleanFontFamilyList() {
        share._cleanFontFamilyList()
    }
    
    class func registerFontAt(_ url: URL, customInfo: FontInfoAttributes? = nil) {
        share.registerFontAt(url)
    }
    
    class func registerFontWith(_ info: FontInfoAttributes) {
        share.beganAdd(info)
        share.save()
    }
    
    class func registeredFamilies() -> [String] {
       return share.families()
        
    }
    
    class func registeredFontsBy(_ familyName: String) -> [String] {
        return share.fontsBy(familyName)
    }
    
    class func unregisterFontWith(_ info: FontInfoAttributes) {
        share.beganAdd(info)
        share.save()
    }
    
    class func familiesList() -> FontFamiliesList {
        return share.familiesList()
    }
    
    class func familiesListMoveFrom(_ index: Int, toIndex: Int) {
        share.familiesListMoveFrom(index, toIndex: toIndex)
    }
}

// search 
extension FontManager {
    
    fileprivate func families() -> [String] {
        
        let familiesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "FontFamily")
        
        do {
           let result = try record.managedObjectContext.fetch(familiesFetch) as! [FontFamily]
            return result.map {$0.familyName!}
        } catch {
            
            return []
        }
    }
    
    fileprivate func fontsBy(_ familyName: String) -> [String] {
        
        let predicate = NSPredicate(format: "familyName == %@", familyName)
        let fullNameFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Font")
        fullNameFetch.predicate = predicate
        
        do {
            let result = try record.managedObjectContext.fetch(fullNameFetch) as! [Font]
            
            return result.map { $0.postscriptName! }
        } catch {
            return []
        }
    }
}

// manage the register fontInfo
extension FontManager {
    
    enum FontManagerInsertResult {
        case shouldAdd
        case existed
        case failture(Error)
    }
    
    enum FontManagerRemoveResult {
        case notExisted
        case shouldRemove(NSManagedObject)
        case failture(Error)
    }
    
    fileprivate func _cleanFontFamily() {
        let context = record.managedObjectContext
        let fullNameFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "FontFamily")
        
        do {
            if let list = try record.managedObjectContext.fetch(fullNameFetch) as? [FontFamily] {
                
                for l in list {
                    context.delete(l)
                }
            }
            
        } catch {
            fatalError()
        }
        
        save()
    }
    
    fileprivate func _cleanFontFamilyList() {
        let context = record.managedObjectContext
        let name = FontManager.defaultFontFamiliesListName
        let predicate = NSPredicate(format: "name == %@", name)
        let fullNameFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "FontFamiliesList")
        fullNameFetch.predicate = predicate
        
        do {
            if let list = try record.managedObjectContext.fetch(fullNameFetch) as? [FontFamiliesList] {
                
                for l in list {
                    context.delete(l)
                }
            }
            
        } catch {
            fatalError()
        }
        
        save()
    }
    
    fileprivate func familiesListMoveFrom(_ index: Int, toIndex: Int) {
        let list = familiesList()
        guard let order = list.families?.mutableCopy() as? NSMutableOrderedSet else { return }
        order.exchangeObject(at: index, withObjectAt: toIndex)
        list.families = order
        save()
    }
    
    fileprivate func shouldRemoveFontBy(_ fullName: String) -> FontManagerRemoveResult {
        let predicate = NSPredicate(format: "fullName == %@", fullName)
        let fullNameFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Font")
//        fullNameFetch.resultType = .CountResultType
        fullNameFetch.fetchLimit = 1
        fullNameFetch.predicate = predicate
        
        do {
            let result = try record.managedObjectContext.fetch(fullNameFetch)
            
            
            return result.count > 0 ? .shouldRemove(result.first! as! NSManagedObject) : .notExisted
        } catch let error {
            return .failture(error)
        }
    }
    
    fileprivate func shouldInsertFontBy(_ fullName: String) -> FontManagerInsertResult {

        let predicate = NSPredicate(format: "fullName == %@", fullName)
        let fullNameFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Font")
        fullNameFetch.resultType = .countResultType
        fullNameFetch.fetchLimit = 1
        fullNameFetch.predicate = predicate
        
        do {
            let resultCount = try record.managedObjectContext.fetch(fullNameFetch).first! as! Int
            
            return resultCount > 0 ? .existed : .shouldAdd
        } catch let error {
            return .failture(error)
        }
    }
    
    fileprivate func shouldInsertFamilyBy(_ familyName: String) -> FontManagerInsertResult {
        
        let predicate = NSPredicate(format: "familyName == %@", familyName)
        let fullNameFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "FontFamily")
        fullNameFetch.resultType = .countResultType
        fullNameFetch.fetchLimit = 1
        fullNameFetch.predicate = predicate
        
        do {
            let resultCount = try record.managedObjectContext.fetch(fullNameFetch).first! as! Int
            
            return resultCount > 0 ? .existed : .shouldAdd
        } catch let error {
            return .failture(error)
        }
    }
    
    fileprivate func beganRemove(_ info: FontInfoAttributes) {
        let fullName = info.fullName
        let familyName = info.familyName
        let result = shouldInsertFontBy(fullName)
        let familyResult = shouldInsertFamilyBy(familyName)
        
        if  case .existed = result { addFont(info) }
    }
    
    fileprivate func removeFont(_ info: FontInfoAttributes) {
        let context = record.managedObjectContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Font", in: context) else { return }
        
    }
    
    fileprivate func beganAdd(_ info: FontInfoAttributes) {
        
        let fullName = info.fullName
        let familyName = info.familyName
        let result = shouldInsertFontBy(fullName)
        let familyResult = shouldInsertFamilyBy(familyName)
        
        if  case .shouldAdd = result { addFont(info) } //else { print("not add font") }
        if case .shouldAdd = familyResult { addFamily(info) } //else { print("not add family") }
    }
    
    fileprivate func addFont(_ info: FontInfoAttributes) {
        
        let context = record.managedObjectContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Font", in: context) else { return }

        let font = Font(entity: entity, insertInto: context)
        font.congfigWith(info)
        
       // print(" add font")
    }
    
    fileprivate func addFamily(_ info: FontInfoAttributes) {
        
        let context = record.managedObjectContext
        guard let entity = NSEntityDescription.entity(forEntityName: "FontFamily", in: context) else { return }
        
        let font = FontFamily(entity: entity, insertInto: context)
        font.configWith(info)
        
        // print(" add family")
        
        let list = familiesList()
        if let families = list.families {
            let order = families.mutableCopy() as! NSMutableOrderedSet
            order.add(font)
            list.families = order
        } else {
            let order = NSOrderedSet(array: [font])
            list.families = order
        }
    }
    
    fileprivate func familiesList(_ name: String = FontManager.defaultFontFamiliesListName) -> FontFamiliesList {
        
        let predicate = NSPredicate(format: "name == %@", name)
        let fullNameFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "FontFamiliesList")
        fullNameFetch.fetchLimit = 1
        fullNameFetch.predicate = predicate
        
        do {
            let list = try record.managedObjectContext.fetch(fullNameFetch) as! [FontFamiliesList]
            
            if let alist = list.first {
                return alist
            } else {
                let context = record.managedObjectContext
                guard let entity = NSEntityDescription.entity(forEntityName: "FontFamiliesList", in: context) else { fatalError() }
                
                let font = FontFamiliesList(entity: entity, insertInto: context)
                font.name = name
                
                // print(" add list")
                return font
            }

        } catch {
            fatalError()
        }
    }
    
    fileprivate func save() {
        if record.managedObjectContext.hasChanges {
            do {
                try record.managedObjectContext.save()
            } catch {
                
            }
        }
    }
}


// register Font
extension FontManager {
    
    fileprivate func registerFontsAt(_ directoryUrl: URL) {
        
    }
    
    fileprivate func registerFontAt(_ url: URL, customInfo: FontInfoAttributes? = nil) {
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(FontManager.notiRegisteredFontsDidChanged(_:)), name: kCTFontManagerRegisteredFontsChangedNotification as String, object: nil)
        
        // 0. registe and get the info
//        if CTFontManagerRegisterFontsForURL(url, .Process, nil) {
//        }
        
//        let urls = CTFontManagerCreateFontDescriptorsFromURL(url).map{ $0 as! CTFontDescriptor }
//        
//        print(urls)
        
        guard
            let data = try? Data(contentsOf: url),
            let provider = CGDataProvider(data: data as CFData) else { return }
      
      
        let cgfont = CGFont(provider)
      
      guard CTFontManagerRegisterGraphicsFont(cgfont, nil) else {
        return
      }
      
        let ctFont = CTFontCreateWithGraphicsFont(cgfont, 1, nil, nil)
        
        guard
            let familyName = CTFontCopyName(ctFont, kCTFontFamilyNameKey)?.toString(),
            let fullName = CTFontCopyName(ctFont,kCTFontFullNameKey)?.toString(),
            let postscriptName = CTFontCopyName(ctFont, kCTFontPostScriptNameKey)?.toString() else { return }
        
        let style = CTFontCopyName(ctFont, kCTFontStyleNameKey)?.toString() ?? ""
        let copyRight = CTFontCopyName(ctFont, kCTFontCopyrightNameKey)?.toString() ?? ""
        let version = CTFontCopyName(ctFont, kCTFontVersionNameKey)?.toString() ?? ""
        
        let fontInfo = FontInfo(
            familyName: familyName,
            fullName: fullName,
            postscriptName: postscriptName,
            copyRight: copyRight,
            style: style,
            size: "",
            version: version)
        
        beganAdd(fontInfo)
        
        save()
    }
}

private extension Font {
    func congfigWith(_ info: FontInfoAttributes) {
       familyName = info.familyName
       fullName = info.fullName
       postscriptName = info.postscriptName
       copyRight = info.postscriptName
       style = info.style
       version = info.version
    }
}

private extension FontFamily {
    func configWith(_ info: FontInfoAttributes) {
        familyName = info.familyName
    }
}

private extension CFString {
    
    func toString() -> String {
        return self as String
    }
}





private class DataController {
    let managedObjectContext: NSManagedObjectContext
    let manageObjectModel: NSManagedObjectModel
    
    var childObjectContext: NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = managedObjectContext
        return context
    }
    
    init(modelName: String = "FontManager", unitTest: Bool = false) {
        // 1.This resource is the same name as your xcdatamodeld contained in your project.
        guard let modelURL = Bundle.main.url(forResource: modelName, withExtension:"momd") else {
            fatalError("Error loading model from bundle")
        }
        
        // 2. The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        manageObjectModel = mom
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = psc
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docURL = urls[urls.endIndex-1]
        /* The directory the application uses to store the Core Data store file.
         This code uses a file named "DataModel.sqlite" in the application's documents directory.
         */
        
        let storeURL = docURL.appendingPathComponent("\(modelName).sqlite")
        //            let options = [NSMigratePersistentStoresAutomaticallyOption : true]
        do {
            try psc.addPersistentStore(ofType: unitTest ? NSInMemoryStoreType : NSSQLiteStoreType, configurationName: nil, at: unitTest ? nil : storeURL, options: nil)
        } catch {
            fatalError("Error migrating store: \(error)")
        }
    }
}
