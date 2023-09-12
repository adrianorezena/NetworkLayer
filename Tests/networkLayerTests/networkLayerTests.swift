import XCTest
@testable import networkLayer

final class NetworkLayerTests: XCTestCase {
    
    override func tearDown() {
        super.tearDown()
        
        URLProtocolStub.removeStub()
    }
    
    func test_fetchInvalidURL_fails_on_invalid_url() {
        let expectedResult: NSError = HTTPClientURLSession.InvalidURLError() as NSError
        
        let sut = makeSUT()
        sut.execute(MockAPI.fetchInvalidURL) { result in
            switch result {
            case .success:
                XCTFail("Expected failure, got success instead")
            case .failure(let failure as NSError):
                XCTAssertEqual(failure, expectedResult)
            }
        }
    }
    
    func test_fetchArtists_succeeded_request() {
        let exp = expectation(description: "Finish request")
        
        let sut = makeSUT()
        MockAPI.baseURL = anyURLString()
        sut.execute(MockAPI.fetchArtists) { result in
            debugPrint("RESULT: \(result)")
            
            switch result {
            case .success(let response):
                debugPrint("RESPONSE: \(response)")
                exp.fulfill()
                
            case .failure(let failure as NSError):
                XCTFail("Expected success, got failure instead: \(failure.localizedDescription)")
            }
        }
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_cancel_actually_cancel_the_request() {
        let exp = expectation(description: "Finish request")
        
        let expectedError: Int = URLError.cancelled.rawValue
        
        let sut = makeSUT()
        let task = sut.execute(MockAPI.fetchArtists) { result in
            switch result {
            case .success:
                XCTFail("Expected cancelation, got success instead")
            case .failure(let failure as NSError):
                XCTAssertEqual(failure.code, expectedError)
            }
            
            exp.fulfill()
        }
        
        task?.cancel()
        
        wait(for: [exp], timeout: 1)
    }
    
}

// MARK: - Helpers
extension NetworkLayerTests {
    
    func makeSUT() -> HTTPClient {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: configuration)
        let sut: HTTPClient = HTTPClientURLSession(session: session)
        
        let successResponse: HTTPURLResponse = HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!
        URLProtocolStub.stub(data: Stub.data, response: successResponse, error: nil)
        
        return sut
    }
    
}

private enum MockAPI {
    case fetchArtists
    case fetchInvalidURL
}

extension MockAPI: APIProtocol {
    static var baseURL: String = ""
    
    var path: String {
        switch self {
        case .fetchArtists:
            return "/v3/d26d86ec-fb82-48a7-9c73-69e2cb728070"
        case .fetchInvalidURL:
            return ""
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchArtists:
            return .get
        case .fetchInvalidURL:
            return .get
        }
    }
    
    var url: String {
        switch self {
        case .fetchArtists:
            return Self.baseURL + path
        case .fetchInvalidURL:
            return ""
        }
    }

}

private struct Stub {
    static var data: Data {
        """
        [{
          "id": 2,
          "name": "Beyonce",
          "photoURL": "https://api.adorable.io/avatars/285/a2.png"
        }]
        """.data(using: .utf8)!
    }
}
