# networkLayer

Simple Network Layer, to facilitate the development of small projects.

Add an `enum` with your requests
```swift
enum ProductAPI {
    case fetchProducts
    case fetchProduct(id: String)
}
```

Make your `enum` conform to `APIProtocol`
```swift
extension ProductAPI: APIProtocol {
    static var baseURL: String = "http://any-base-url.com"
    
    var path: String {
        switch self {
        case .fetchProducts:
            return "/products"
            
        case let .fetchProduct(id):
            return "/products/\(id)"
        }
    }
    
    var method: networkLayer.HTTPMethod {
        .get
    }
    
    var url: String {
        Self.baseURL + path
    }
}

```

## How to use?

```swift
let client: HTTPClient = HTTPClientURLSession()
client.execute(ProductAPI.fetchProducts) { result in
    switch result {
    case let .success((data, response)):
        doSomething()
        
    case let .failure(error):
        doSomething()
    }
}
```
