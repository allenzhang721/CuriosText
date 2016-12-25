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
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testUploadFile500KB() {
        uploadTemplateFileBy(500 * 1024, index:10)
    }
    
    func testUploadFile600KB() {
        for i in 0  ..< 10 {
            uploadTemplateFileBy(600 * 1024, index:i)
        }
    }
    
    func testPublishUpload(){
        uploadPubilshFile()
    }
    
}

extension UploadTests {
    
    func upTokenRequest(){
        let publishID = CTAIDGenerator.generateID()
        
        let publishIconURL = generateTempFileBy(1024*1024)
        let publishIconKey = publishID+"/icon.jpg"
        
        let previewIconURL = generateTempFileBy(2048*1024)
        let previewIconKey = publishID+"/preview.jpg"
        
        let publishJsonURL = generateTempFileBy(10*1024)
        let publishJsonKey = publishID+"/publish.json"
        
        let publishImageURL = generateTempFileBy(800*1024)
        let publishImageKey = publishID+"/publish.jpg"
        
        var upTokenArray:Array<CTAUpTokenModel> = []
        upTokenArray.append(CTAUpTokenModel.init(upTokenKey: publishIconKey))
        upTokenArray.append(CTAUpTokenModel.init(upTokenKey: previewIconKey))
        upTokenArray.append(CTAUpTokenModel.init(upTokenKey: publishJsonKey))
        upTokenArray.append(CTAUpTokenModel.init(upTokenKey: publishImageKey))
        
        var uploadArray:Array<CTAUploadModel> = []
        
        let expecation = self.expectation(description: "Async upload waiting")
        CTAUpTokenDomain.getInstance().publishUpToken(upTokenArray) { (listInfo) -> Void in
            if listInfo.result {
                let modelArray = listInfo.modelArray;
                if modelArray != nil {
                    
                    var uploadModel:CTAUploadModel?;
                    for var i=0 ; i < modelArray!.count; i++ {
                        let uptokenModel:CTAUpTokenModel = modelArray![i] as! CTAUpTokenModel
                        switch uptokenModel.upTokenKey {
                        case publishIconKey:
                            uploadModel = CTAUploadModel.init(key: uptokenModel.upTokenKey, token: uptokenModel.upToken, filePath: publishIconURL.path!)
                        case previewIconKey:
                            uploadModel = CTAUploadModel.init(key: uptokenModel.upTokenKey, token: uptokenModel.upToken, filePath: previewIconURL.path!)
                        case publishJsonKey:
                            uploadModel = CTAUploadModel.init(key: uptokenModel.upTokenKey, token: uptokenModel.upToken, filePath: publishJsonURL.path!)
                        case publishImageKey:
                            uploadModel = CTAUploadModel.init(key: uptokenModel.upTokenKey, token: uptokenModel.upToken, filePath: publishImageURL.path!)
                        default:
                            uploadModel = nil;
                        }
                        if uploadModel != nil {
                            uploadArray.append(uploadModel!)
                        }
                    }
                }
            }
            expecation.fulfill()
        }
        
        self.waitForExpectations(timeout: 20) { (error) -> Void in
            for var i = 0; i < uploadArray.count ; i += 1 {
                let model:CTAUploadModel = uploadArray[i]
                print("index = \(i+1) key = \(model.key) token = \(model.token)")
            }
        }
    }
}

extension UploadTests {
    func uploadPubilshFile(){
        let publishID = "7CF67EE53E1742B686E1CAB0D53B81CC"
        
        let publishIconURL = generateTempFileBy(1024*1024)
        let publishIconKey = publishID+"/icon.jpg"
        let publishIconToken  = "zXqNlKjpzQpFzydm6OCcngSa76aVNp-SwmqG-kUy:btAuExeNs-YYCLktkquBPZ9MhVE=:eyJzY29wZSI6ImN1cmlvc3RleHRwdWJsaXNoOjdDRjY3RUU1M0UxNzQyQjY4NkUxQ0FCMEQ1M0I4MUNDL2ljb24uanBnIiwiZGVhZGxpbmUiOjE0NTE0NjUzMTd9"
        
        let previewIconURL = generateTempFileBy(2048*1024)
        let previewIconKey = publishID+"/preview.jpg"
        let previewIconToken = "zXqNlKjpzQpFzydm6OCcngSa76aVNp-SwmqG-kUy:M_0v8ep1B6JjFTG4Qcy8Xt2KZ0w=:eyJzY29wZSI6ImN1cmlvc3RleHRwdWJsaXNoOjdDRjY3RUU1M0UxNzQyQjY4NkUxQ0FCMEQ1M0I4MUNDL3ByZXZpZXcuanBnIiwiZGVhZGxpbmUiOjE0NTE0NjUzMTd9"
        
        let publishJsonURL = generateTempFileBy(10*1024)
        let publishJsonKey = publishID+"/publish.json"
        let publishJsonToken = "zXqNlKjpzQpFzydm6OCcngSa76aVNp-SwmqG-kUy:TLfCQM0wH9LM6etmCbJNUYwy_98=:eyJzY29wZSI6ImN1cmlvc3RleHRwdWJsaXNoOjdDRjY3RUU1M0UxNzQyQjY4NkUxQ0FCMEQ1M0I4MUNDL3B1Ymxpc2guanNvbiIsImRlYWRsaW5lIjoxNDUxNDY1MzE3fQ=="
        
        let publishImageURL = generateTempFileBy(800*1024)
        let publishImageKey = publishID+"/publish.jpg"
        let publishImageToken = "zXqNlKjpzQpFzydm6OCcngSa76aVNp-SwmqG-kUy:wLHd2RDZ0LueSL8KwDTNiqkcJ9o=:eyJzY29wZSI6ImN1cmlvc3RleHRwdWJsaXNoOjdDRjY3RUU1M0UxNzQyQjY4NkUxQ0FCMEQ1M0I4MUNDL3B1Ymxpc2guanBnIiwiZGVhZGxpbmUiOjE0NTE0NjUzMTd9"
        
        var uploadArray:Array<CTAUploadModel> = []
        uploadArray.append(CTAUploadModel.init(key: publishIconKey, token: publishIconToken, filePath: publishIconURL.path!))
        uploadArray.append(CTAUploadModel.init(key: previewIconKey, token: previewIconToken, filePath: previewIconURL.path!))
        uploadArray.append(CTAUploadModel.init(key: publishJsonKey, token: publishJsonToken, filePath: publishJsonURL.path!))
        uploadArray.append(CTAUploadModel.init(key: publishImageKey, token: publishImageToken, filePath: publishImageURL.path!))
        
       
    }
}

extension UploadTests {
    
    func uploadTemplateFileBy(_ fileSize: Int, index:Int) {
        let tempFileURL = generateTempFileBy(fileSize)
        let tempfileKey = String(index)+"_"+tempFileURL.lastPathComponent // such as 'xxx/xxx/xxx.jpg'
        
        // uploadOption
        let option = QNUploadOption(mime: nil, progressHandler: { (fileKey, progress) -> Void in
            
            print("key: \(fileKey) progress: \(progress)")
            
            }, params: nil, checkCrc: true, cancellationSignal: nil)
        
        
        // upload
        var ainfo: QNResponseInfo?
        var afileKey: String?
        var aresponse:  [AnyHashable: Any]?
        
        let expecation = self.expectation(description: "Async upload waiting")
        uploadManager.putFile(tempFileURL.path!, key: tempfileKey, token: gobalToken, complete: { (info: QNResponseInfo!, fileKey, response: [AnyHashable: Any]!) -> Void in
            
            
            
            ainfo = info
            afileKey = fileKey
            aresponse = response
            
            expecation.fulfill()
            print("info = \(info)\n\nfilekey = \(fileKey)\n\nresponse = \(response)")

            }, option: option)
        
        func uploadCompleted(_ info: QNResponseInfo?, filekey: String?, response: [AnyHashable: Any]?) {
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
            print("info = \(info)\n\nfilekey = \(filekey)\n\nresponse = \(response)")
            
            XCTAssertTrue(info!.ok, "The upload was fail")
            XCTAssertTrue(info!.reqId != nil, "The upload info should contain a request ID")
            XCTAssertTrue(filekey! == tempfileKey, "The feed back fileKey should same as tempFileKey:\(tempfileKey)")
            
        }
        
        
        
        
    }
    
    func generateTempFileBy(_ fileSize: Int) -> URL {
        let fileName = ProcessInfo.processInfo.globallyUniqueString + "_file.extension"
        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory() + "/" + fileName)
        let tempData = NSMutableData(length: fileSize)
        tempData?.write(to: fileURL, atomically: false)
        return fileURL
    }
    
}
