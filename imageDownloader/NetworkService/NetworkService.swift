import Foundation

class NetworkService {
    
    // построение данных по URL
    func request(searchTerm: String, completion: @escaping (Data?, Error?) -> Void) {
        
        let params = self.prepareparams(searchTerm: searchTerm)
        let url = self.url(params: params)
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = prepareHeaders() as? [String : String]
        request.httpMethod = "get"
        
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
    
    private func prepareHeaders() -> [String: String?] {
        var headers = [String: String]()
        // add in Client id your own access key in https://unsplash.com/oauth/applications
        headers["Authorization"] = "Client-ID "
        return headers
    }
    
    private func prepareparams(searchTerm: String?) -> [String: String] {
        var parametrs = [String:String]()
        parametrs["query"] = searchTerm
        parametrs["page"] = String(1)
        parametrs["per_page"] = String(30)
        return parametrs
    }
    
    private func url(params: [String:String]) -> URL {
        var componetnts = URLComponents()
        componetnts.scheme = "https"
        componetnts.host = "api.unsplash.com"
        componetnts.path = "/search/photos"
        componetnts.queryItems = params.map{ URLQueryItem(name: $0, value: $1) }
        return componetnts.url!
    }
    
    private func createDataTask(from request: URLRequest, completion: @escaping (Data?,Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                completion(data, error)
            }
        })
    }
}
