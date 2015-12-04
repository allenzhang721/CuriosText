//
//  CTARequestResponse.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 12/4/15.
//  Copyright © 2015 botai. All rights reserved.
//

import Foundation

/// Used to store all response data returned from a completed `Request`.
public struct CTARequestResponse<Value, Error: ErrorType> {
  /// The URL request sent to the server.
  public let request: NSURLRequest?
  
  /// The server's response to the URL request.
  public let response: NSHTTPURLResponse?
  
  /// The data returned by the server.
  public let data: NSData?
  
  /// The result of response serialization.
  public let result: CTARequestResult<Value, Error>
  
  /**
   Initializes the `Response` instance with the specified URL request, URL response, server data and response
   serialization result.
   
   - parameter request:  The URL request sent to the server.
   - parameter response: The server's response to the URL request.
   - parameter data:     The data returned by the server.
   - parameter result:   The result of response serialization.
   
   - returns: the new `Response` instance.
   */
  public init(request: NSURLRequest?, response: NSHTTPURLResponse?, data: NSData?, result: CTARequestResult<Value, Error>) {
    self.request = request
    self.response = response
    self.data = data
    self.result = result
  }
}

// MARK: - CustomStringConvertible

extension CTARequestResponse: CustomStringConvertible {
  /// The textual representation used when written to an output stream, which includes whether the result was a
  /// success or failure.
  public var description: String {
    return result.debugDescription
  }
}

// MARK: - CustomDebugStringConvertible

extension CTARequestResponse: CustomDebugStringConvertible {
  /// The debug textual representation used when written to an output stream, which includes the URL request, the URL
  /// response, the server data and the response serialization result.
  public var debugDescription: String {
    var output: [String] = []
    
    output.append(request != nil ? "[Request]: \(request!)" : "[Request]: nil")
    output.append(response != nil ? "[Response]: \(response!)" : "[Response]: nil")
    output.append("[Data]: \(data?.length ?? 0) bytes")
    output.append("[Result]: \(result.debugDescription)")
    
    return output.joinWithSeparator("\n")
  }
}