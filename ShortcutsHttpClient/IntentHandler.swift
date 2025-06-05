import Intents

class IntentHandler: INExtension, MakeHTTPRequestIntentHandling {
  override func handler(for intent: INIntent) -> Any {
    return self
  }
  
  func handle(intent: MakeHTTPRequestIntent) async -> MakeHTTPRequestIntentResponse {
    var url = intent.url!;
    
    if let queryItemStrs = intent.query {
      let queryItems = queryItemStrs.map {
        let kv = $0.split(separator: "=", maxSplits: 1)
        return URLQueryItem(name: String(kv[0]), value: String(kv[1]))
      }
      url.append(queryItems: queryItems)
    }

    var request = URLRequest(url: url)
    request.httpMethod = String(describing: intent.method)
    request.httpBody = intent.body!.data;

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
    
    do {
      let (data, response) = try await URLSession.shared.data(for: request)
      let httpResponse = response as! HTTPURLResponse
      let intentResponse = MakeHTTPRequestIntentResponse(code: .success, userActivity: nil)
      intentResponse.responseBody = String(data: data, encoding: .utf8)
      intentResponse.responseCode = NSNumber(value: httpResponse.statusCode)
      return intentResponse
    } catch {
      let intentResponse = MakeHTTPRequestIntentResponse(code: .failure, userActivity: nil)
      intentResponse.responseBody = error.localizedDescription
      return intentResponse
    }
  }
}
