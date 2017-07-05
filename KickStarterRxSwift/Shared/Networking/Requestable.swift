import Foundation
import RxSwift
import Alamofire

protocol Requestable: URLRequestConvertible {
  
  associatedtype Element
  
  var basePath: String { get }
  
  var endpoint: String { get }
  
  var httpMethod: HTTPMethod { get }
  
  var param: Parameter? { get }
  
  var addionalHeader: HeaderParameter? { get }
  
  var parameterEncoding: ParameterEncoding { get }
  
  func toObservable() -> Observable<Element>
  
  func decode(data: Any) -> Element?
}

//
// MARK: - Conform URLConvitible from Alamofire
extension Requestable {
  public func asURLRequest() -> URLRequest {
    return self.buildURLRequest()
  }
}

extension Requestable {
  
  typealias HeaderParameter = [String: String]
  typealias JSONDictionary = [String: Any]
  
  var basePath: String { return "https://www.googleapis.com/youtube/v3/" }
  
  var param: Parameter? { return nil }
  
  var addionalHeader: HeaderParameter? { return nil }
  
  var defaultHeader: HeaderParameter { return ["Accept": "application/json", "Accept-Language": "en_US"] }
  
  var urlPath: String { return basePath + endpoint }
  
  var url: URL { return URL(string: urlPath)! }
  
  var parameterEncoding: ParameterEncoding {
    if self.httpMethod == .get {
      return URLEncoding.default
    }
    return JSONEncoding.default
  }
  
  func buildURLRequest() -> URLRequest {
    
    // Init
    var urlRequest = URLRequest(url: self.url)
    urlRequest.httpMethod = self.httpMethod.rawValue
    urlRequest.timeoutInterval = TimeInterval(10 * 1000)
    
    // Encode param
    guard var request = try? self.parameterEncoding.encode(urlRequest, with: self.param?.toDictionary()) else {
      fatalError("Can't handle unknow request")
    }
    
    // Add addional Header if need
    if let additinalHeaders = self.addionalHeader {
      for (key, value) in additinalHeaders {
        request.addValue(value, forHTTPHeaderField: key)
      }
    }
    
    return request
  }
  
  func toObservable() -> Observable<Element> {
    return Observable<Element>.create { (observer) -> Disposable in
      
      guard let urlRequest = try? self.asURLRequest() else {
        observer.on(.error(NSError.unknowError()))
        return Disposables.create {}
      }
      
      Alamofire.request(urlRequest)
              .validate(contentType: ["application/json"])
              .responseJSON(completionHandler: { (response) in
                print(response)
              })
      
      return Disposables.create()
    }
  }
}

extension NSError {
  
  // Unknow error
  static func unknowError() -> NSError {
    let userInfo = [NSLocalizedDescriptionKey: "Unknow error"]
    return NSError(domain: "com.fe.titan.defaultError", code: 999, userInfo: userInfo)
  }
  
  // JSON Mapper Error
  static func jsonMapperError() -> NSError {
    let userInfo = [NSLocalizedDescriptionKey: "JSON Mapper error"]
    return NSError(domain: "com.fe.titan.defaultError", code: 998, userInfo: userInfo)
  }
}
