//
//  FlickerClient.swift
//  VirtualTourist
//
//  Created by Sophia Lu on 8/8/21.
//

import Foundation


class FlickerClient {
   static let apiKey = "a95b1d68dda7b2be039f8ce06b9f13d3"
    
   enum Endpoints {
        static let base = "https://www.flickr.com/services/rest/?method=flickr.photos.search"
    
        case searchPhoto(String, String, Int)
        case getImage(Int, String, String, String)
        
        var stringValue: String {
            switch self {
            case .searchPhoto(let lat, let lon, let page):
                return Endpoints.base +
                    "&api_key=\(FlickerClient.apiKey)" +
                    "&lat=\(lat)" +
                    "&lon=\(lon)" +
                    "&per_page=51" +
                    "&page=\(page)" +
                    "&format=json&nojsoncallback=1"
            case .getImage(let farm, let server, let id, let secret):
               return "http://farm\(farm).static.flickr.com/\(server)/\(id)_\(secret).jpg"
            }
        }
    
        var url: URL {
            return URL(string: stringValue)!
        }
   }
    
    class func getPhotoList(lat: String, lon: String, page: Int, completion: @escaping([PhotoInfo], Error?) -> Void) {
        HttpRequests.taskForGETRequest(url: Endpoints.searchPhoto(lat, lon, page).url, response: SearchResults.self) { response, error in
                
            if let response = response {
                print(response.photos.photo)
                completion(response.photos.photo, error)
            } else {
                completion([], error)
            }
        }
    }
    
    class func downloadImage(photo: PhotoInfo, completion: @escaping(Data?, Error?) -> Void) {
        
        let task = URLSession.shared.dataTask(with: Endpoints.getImage(photo.farm, photo.server, photo.id, photo.secret).url) {data, response, error in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
        
        task.resume()
    }
}
