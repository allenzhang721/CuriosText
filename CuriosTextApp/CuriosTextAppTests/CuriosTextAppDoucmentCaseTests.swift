//
//  CuriosTextAppDoucmentCaseTests.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 12/15/15.
//  Copyright © 2015 botai. All rights reserved.
//

import XCTest
@testable import CuriosTextApp

class CuriosTextAppDoucmentCaseTests: XCTestCase {
    
    let page = CTAPage()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        page.removeAll()
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
            
        }
    }
    
    func testPageArchive() {
        
        self.measureBlock { () -> Void in
            for _ in 0..<1000 {
                let container = TestHelper.generateTextContainer(0, y: 0, pageWidth: 512.0, pageHeigh: 512.0, text: "Emiaostein", attributes: [String : AnyObject]())
                self.page.append(container)
            }
            let _ = NSKeyedArchiver.archivedDataWithRootObject(self.page)
        }
    }
    
    func testUUID() {
        
        let uuid = CTAIDGenerator.generateID()
        XCTAssertTrue(uuid.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 12, "gernerateID length should equal to 12")
    }
    
    func testCreateDocument() {
        
        // Given
        let presenter = CTAPresenter(page: page)
        let fileURL = TestHelper.documentFileURL()
        
        // When
        let expecation = self.expectationWithDescription("Create Document")
        let document = CTADocument(fileURL: fileURL, accesser: presenter)
        document.saveToURL(document.fileURL, forSaveOperation: .ForCreating) { (success) -> Void in
            
            expecation.fulfill()
            XCTAssertTrue(success, "document create fail")
            
        }
        // Then
        self.waitForExpectationsWithTimeout(1.0) { (error) -> Void in
            
            print(document.fileURL)
            XCTAssertTrue(NSFileManager.defaultManager().fileExistsAtPath(document.fileURL.path!), "The document created fail.")
        }
    }
    
    func testDocumentStoreAndRetriveResouce() {
        
        // Given
        let presenter = CTAPresenter(page: page)
        let fileURL = TestHelper.documentFileURL()
        
        // When
        let expecation = self.expectationWithDescription("Create Document")
        let document = CTADocument(fileURL: fileURL, accesser: presenter)
        document.saveToURL(document.fileURL, forSaveOperation: .ForCreating) { (success) -> Void in
            
            expecation.fulfill()
            XCTAssertTrue(success, "document create fail")
            
        }
        
        let imageName = "2.jpg"
        let image = UIImage(named: imageName)!
        
        func storeAndLoadImage(document: CTADocument) {
            
            let imageData = UIImageJPEGRepresentation(image, 0.01)
            document.storeResource(imageData!, withName: imageName)
            
            let retriveData = document.resourceBy(imageName)
            
           XCTAssertTrue(imageData == retriveData && imageData != nil && retriveData != nil, "saved data should same as retrived data")
            
//            let aimage = UIImage(data: retriveData!)
        }
        
        
        // Then
        self.waitForExpectationsWithTimeout(1.0) { (error) -> Void in
            
            storeAndLoadImage(document)
        }
    }
    

//    func testPageJsonSerializtion() {
//        for _ in 0..<1000 {
//            let container = TestHelper.generateTextContainer(0, y: 0, pageWidth: 512.0, pageHeigh: 512.0, text: "Emiaostein", attributes: [String : AnyObject]())
//            self.page.append(container)
//        }
//        
//        self.measureBlock { () -> Void in
//            let _ = try! NSJSONSerialization.dataWithJSONObject(self.page, options: NSJSONWritingOptions(rawValue: 0))
//        }
//    }

}
