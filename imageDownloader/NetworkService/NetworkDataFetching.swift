import Foundation

class NetworkDataFetching {
    
    var networkService = NetworkService()
    
    func fetchImages(searchTerms: String, completion: @escaping (SearchResults?)->()) {
        
        networkService.request(searchTerm: searchTerms) { (data, error) in
            
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
            }
            
            let decoded = self.decodeJSON(type: SearchResults.self, from: data)
            completion(decoded)
        }
    }
    
    func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        
        let decoder = JSONDecoder()
        
        guard let data = from  else { return nil }
        
        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects
        } catch let JSONError {
            print("Failed to decode JSON",JSONError)
            return nil
        }
    }
}
