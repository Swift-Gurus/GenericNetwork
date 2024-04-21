# GenericNetworks

A high-level convenient api for making network requests.
Contains default error handling for codes with the possibility to extend 
Contains default json decoding with the possibility to extend

## Generic network class
The main idea is to encapsulate network request behind enums and let a factory to contain
logic to construct a url request

```swift
enum CustomRequest {
    case fetchUser(id: String)
    case loginUser(password: String, name: String)
}

struct CustomRequestFactory: RequestFactory {
   func request(for type: RequestType) throws -> URLRequestConvertible {
     switch type {
       case let .fetchUser(id):
          return DefaultNetworkRequest(base: "myserver.com/user/(\id)")
       case let .loginUser(password, name):
            var request DefaultNetworkRequest(base: "myserver.com/auth")
            request.body = JSONEncoder().encode(Auth(password:password, name: Name))
            return request
     }
   }
}


let network = GenericNetworkLayer(factory: CustomRequestFactory())
let user = try await network.data(for: .fetchUser("ID"))

```
