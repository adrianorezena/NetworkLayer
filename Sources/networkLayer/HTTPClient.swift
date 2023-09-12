//
//  HTTPClient.swift
//  
//
//  Created by Adriano Rezena on 10/09/23.
//

import Foundation

public protocol HTTPClient {
    typealias HTTPClientResponse = Result<(Data, HTTPURLResponse), Error>
    
    @discardableResult
    func execute(_ apiRequest: APIProtocol, completion: @escaping (HTTPClientResponse) -> Void) -> HTTPClientTask?
}
