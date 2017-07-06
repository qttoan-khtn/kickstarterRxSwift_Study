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
  
  var task: Task { get }
  
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
  
  var basePath: String { return Environment.serverConfig.apiBaseUrlStr }
  
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
  
  // default task
  var task: Task {
    return .request
  }
  
  func toObservable() -> Observable<Element> {
    return Observable<Element>.create { (observer) -> Disposable in
      
      guard let urlRequest = try? self.asURLRequest() else {
        observer.on(.error(NSError.unknowError()))
        return Disposables.create {}
      }
      
      switch self.task {
        case .request:
          self.request(urlRequest, observer: observer)
        
        case let .upload(uploadType):
          switch uploadType {
            case let .multipart(multipartBody):
              self.upload(multipartBody, urlRequest: urlRequest)
            break
          
            default: break
          }
        break
        
        case .download:
        break
      }
      
      
      
      return Disposables.create()
    }
  }
  
  // local method
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
  
  /// Request
  private func request(_ urlRequest: URLRequest, observer: AnyObserver<Element>) {
    Alamofire.request(urlRequest)
      .validate(contentType: ["application/json"])
      .responseJSON(completionHandler: { (response) in
        print(response)
        // Check error
        if let error = response.result.error {
          
          //FIXME : Smell code
          // https://developer.uber.com/docs/riders/references/api/v1.2/places-place_id-get
          // 422 = No personal Place
          // Need to refactor all of request which adapt Requestable protocol
          //
          // HOW TO FIX
          //
          // convert
          // func toObservable() -> Observable<Element>
          // to
          // func toObservable() -> Observable<Element?>
          if response.response?.statusCode == 422 {
            
            // Stupid force cast
            // By-pass error
            //observer.onNext(UberPersonalPlaceObj.invalidPlace as! Element)
            observer.on(.completed)
            return
          }
          
          observer.onError(error)
          return
        }
        
        // Check Response
        guard let data = response.result.value else {
          observer.onError(NSError.jsonMapperError())
          return
        }
        
        // Parse here
        guard let result = self.decode(data: data) else {
          observer.onError(NSError.jsonMapperError())
          return
        }
        
        // Fill
        observer.on(.next(result))
        observer.on(.completed)
      })
  }
  
  /// Upload
  private func upload(_ multipartBody: [MultipartFormData], urlRequest: URLRequest) {
    
    let multipartFormData: (Alamofire.MultipartFormData) -> Void = { form in
      for bodyPart in multipartBody {
        switch bodyPart.provider {
        case .data(let data):
          self.append(data: data, bodyPart: bodyPart, to: form)
        case .file(let url):
          self.append(fileURL: url, bodyPart: bodyPart, to: form)
        case .stream(let stream, let length):
          self.append(stream: stream, length: length, bodyPart: bodyPart, to: form)
        }
      }
      
//      if let parameters = self.param {
//        parameters.toDictionary()
//          .flatMap { key, value in multipartQueryComponents(key, value) }
//          .forEach { key, value in
//            if let data = value.data(using: .utf8, allowLossyConversion: false) {
//              form.append(data, withName: key)
//            }
//        }
//      }
    }
    
    Alamofire.upload(multipartFormData: multipartFormData,
                     with: urlRequest) { result in
//                      switch result {
//                      case .success(let alamoRequest, _, _):
//                        if cancellable.isCancelled {
//                          self.cancelCompletion(completion, target: target)
//                          return
//                        }
//                        cancellable.innerCancellable = self.sendAlamofireRequest(alamoRequest, target: target, queue: queue, progress: progress, completion: completion)
//                      case .failure(let error):
//                        completion(.failure(MoyaError.underlying(error as NSError)))
//                      }
        
    }
  }
}

extension Requestable {
  func append(data: Data, bodyPart: MultipartFormData, to form: Alamofire.MultipartFormData) {
    if let mimeType = bodyPart.mimeType {
      if let fileName = bodyPart.fileName {
        form.append(data, withName: bodyPart.name, fileName: fileName, mimeType: mimeType)
      } else {
        form.append(data, withName: bodyPart.name, mimeType: mimeType)
      }
    } else {
      form.append(data, withName: bodyPart.name)
    }
  }
  func append(fileURL url: URL, bodyPart: MultipartFormData, to form: Alamofire.MultipartFormData) {
    if let fileName = bodyPart.fileName, let mimeType = bodyPart.mimeType {
      form.append(url, withName: bodyPart.name, fileName: fileName, mimeType: mimeType)
    } else {
      form.append(url, withName: bodyPart.name)
    }
  }
  func append(stream: InputStream, length: UInt64, bodyPart: MultipartFormData, to form: Alamofire.MultipartFormData) {
    form.append(stream, withLength: length, name: bodyPart.name, fileName: bodyPart.fileName ?? "", mimeType: bodyPart.mimeType ?? "")
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

/// Encode parameters for multipart/form-data
private func multipartQueryComponents(_ key: String, _ value: Any) -> [(String, String)] {
  var components: [(String, String)] = []
  
  if let dictionary = value as? [String: Any] {
    for (nestedKey, value) in dictionary {
      components += multipartQueryComponents("\(key)[\(nestedKey)]", value)
    }
  } else if let array = value as? [Any] {
    for value in array {
      components += multipartQueryComponents("\(key)[]", value)
    }
  } else {
    components.append((key, "\(value)"))
  }
  
  return components
}
