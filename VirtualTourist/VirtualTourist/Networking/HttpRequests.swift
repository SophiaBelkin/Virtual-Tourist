//
//  HTTPClient.swift
//  VirtualTourist
//
//  Created by Sophia Lu on 8/8/21.
//

import Foundation

class HttpRequests {
    class func taskForGETRequest<ResponseType: Decodable> (url: URL, response: ResponseType.Type, completion:  @escaping  (ResponseType?, Error?) -> Void) {
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(nil, error)
                return
            }

            do {
                let data = try JSONDecoder().decode(ResponseType.self, from: data)
                completion(data, nil)
            } catch {
                completion(nil, error)
            }
        }
        
        task.resume()
    }
}
