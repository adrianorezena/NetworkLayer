//
//  HTTPClientURLSession.swift
//  
//
//  Created by Adriano Rezena on 10/09/23.
//

import Foundation

public final class HTTPClientURLSession: HTTPClient {
    struct InvalidURLError: Error {}
    struct UnexpectedError: Error {}
    
    private let session: URLSession
    
    public init(session: URLSession = URLSession(configuration: .ephemeral)) {
        self.session = session
    }
    
    public func execute(_ apiRequest: APIProtocol, completion: @escaping (HTTPClientResponse) -> Void) -> HTTPClientTask? {
        guard let url: URL = URL(string: apiRequest.url) else {
            completion(.failure(InvalidURLError()))
            return nil
        }
        
        debugPrint("⬆️ \(url.absoluteString)")
        
        let task = session.dataTask(with: url) { data, response, error in
            if let data {
                debugPrint("⬇️ Data: \(String(data: data, encoding: .utf8) ?? "")")
            }
            
            if let response {
                debugPrint("⬇️ Response: \(response)")
            }
            
            if let error {
                debugPrint("⬇️ Error: \(error)")
            }
            
            completion(
                Result {
                    if let error = error {
                        throw error
                    } else if let data = data, let response = response as? HTTPURLResponse {
                        return (data, response)
                    } else {
                        throw UnexpectedError()
                    }
                }
            )
        }
        
        task.resume()
        return task
    }
}

extension URLSessionDataTask: HTTPClientTask {}
