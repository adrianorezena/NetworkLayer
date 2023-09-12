//
//  File.swift
//  
//
//  Created by Adriano Rezena on 12/09/23.
//

import Foundation

func anyURL() -> URL {
    URL(string: anyURLString())!
}

func anyURLString() -> String {
    "http://any-url.com"
}

func anyNSError() -> NSError {
    NSError(domain: "any error", code: 0)
}
