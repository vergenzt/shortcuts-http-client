import Intents

class IntentHandler: INExtension {
  override func handler(for intent: INIntent) -> Any {
    return self
  }
  
  func handle(intent: MakeHTTPRequestIntent) {

    var url = if intent.useBaseUrl!.boolValue {
      intent.baseUrl!.appending(path: intent.path!)
    } else {
      intent.url!
    }

    if let queryItemStrs = intent.queryParams {
      let queryItems = queryItemStrs.map {
        let kv = $0.split(separator: "=", maxSplits: 1)
        return URLQueryItem(name: String(kv[0]), value: String(kv[1]))
      }
      url.append(queryItems: queryItems)
    }

    var request = URLRequest(url: url)
    request.httpMethod = String(describing: intent.method)
    
    switch intent.method {
    case .post:
      request.httpBody = intent.postBody!.data(using: .utf8)
    case .put:
      request.httpBody = intent.putBody!.data(using: .utf8)
    case .patch:
      request.httpBody = intent.patchBody!.data(using: .utf8)
    default:
      break;
    }
    
    if let headers = intent.headers {
      for header in headers {
        let kv = header.split(separator: /:\s*/, maxSplits: 1)
        request.addValue(String(kv[1]), forHTTPHeaderField: String(kv[0]))
      }
    }
    
    if intent.useBasicAuth!.boolValue {
      let headerVal = "\(intent.username!):\(intent.password!)".data(using: .utf8)!.base64EncodedString()
      request.addValue("Basic \(headerVal)", forHTTPHeaderField: "Authorization")
    }
    
    
  }
}
