//
//  APIProtocol.swift
//  
//
//  Created by Adriano Rezena on 10/09/23.
//

import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

public protocol APIProtocol {
    static var baseURL: String  { get set }
    var path: String { get }
    var method: HTTPMethod { get }
    // var body: Data? { get }
    // header: [String: String]? { get }
    var url: String { get }
}
