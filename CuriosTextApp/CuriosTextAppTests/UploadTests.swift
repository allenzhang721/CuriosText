//
//  UploadTests.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 12/16/15.
//  Copyright © 2015 botai. All rights reserved.
//

import XCTest
import Qiniu
@testable import CuriosTextApp

class UploadTests: XCTestCase {
    
    let uploadManager = QNUploadManager()
    let gobalToken = "QWYn5TFQsLLU1pL5MFEmX3s5DmHdUThav9WyOWOm:FRHDJVxqvEregQ2N_h8xCtJ0n1k=:eyJzY29wZSI6Imlvc3NkayIsImRlYWRsaW5lIjoyMDQzMzcxNDYzfQ=="
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
    
    func testUploadFile500KB() {
        uploadTemplateFileBy(500 * 1024, index:10)
    }
    
    func testUploadFile600KB() {
        for var i=0 ; i < 10; i++ {
            uploadTemplateFileBy(600 * 1024, index:i)
        }
    }
    
}

extension UploadTests {
    
    func uploadTemplateFileBy(fileSize: Int, index:Int) {
        let tempFileURL = generateTempFileBy(fileSize)
        let tempfileKey = String(index)+"_"+tempFileURL.lastPathComponent!  // such as 'xxx/xxx/xxx.jpg'
        
        // uploadOption
        let option = QNUploadOption(mime: nil, progressHandler: { (fileKey, progress) -> Void in
            
            print("key: \(fileKey) progress: \(progress)")
            
            }, params: nil, checkCrc: true, cancellationSignal: nil)
        
        
        // upload
        var ainfo: QNResponseInfo?
        var afileKey: String?
        var aresponse:  [NSObject : AnyObject]?
        
        let expecation = self.expectationWithDescription("Async upload waiting")
        uploadManager.putFile(tempFileURL.path!, key: tempfileKey, token: gobalToken, complete: { (info: QNResponseInfo!, fileKey, response: [NSObject : AnyObject]!) -> Void in
            
            
            
            ainfo = info
            afileKey = fileKey
            aresponse = response
            
            expecation.fulfill()
            print("info = \(info)\n\nfilekey = \(fileKey)\n\nresponse = \(response)")

            }, option: option)
        
        func uploadCompleted(info: QNResponseInfo?, filekey: String?, response: [NSObject : AnyObject]?) {
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
            print("info = \(info)\n\nfilekey = \(filekey)\n\nresponse = \(response)")
            
            XCTAssertTrue(info!.ok, "The upload was fail")
            XCTAssertTrue(info!.reqId != nil, "The upload info should contain a request ID")
            XCTAssertTrue(filekey! == tempfileKey, "The feed back fileKey should same as tempFileKey:\(tempfileKey)")
            
        }
        
        self.waitForExpectationsWithTimeout(20) { (error) -> Void in
            
            uploadCompleted(ainfo, filekey: afileKey, response: aresponse)
        }
        
        
    }
    
    func generateTempFileBy(fileSize: Int) -> NSURL {
        let fileName = NSProcessInfo.processInfo().globallyUniqueString + "_file.extension"
        let fileURL = NSURL(fileURLWithPath: NSTemporaryDirectory() + "/" + fileName)
        let tempData = NSMutableData(length: fileSize)
        tempData?.writeToURL(fileURL, atomically: false)
        return fileURL
    }
    
}
