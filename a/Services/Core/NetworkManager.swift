import Alamofire

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    // Generic method to handle all API requests
    func request<T: Decodable>(type: T.Type, url: String, method: HTTPMethod = .get, parameters: [String: Any]? = nil, completion: @escaping (Result<T, AFError>) -> Void) {
        
        AF.request(url, method: method, parameters: parameters)
            .validate() // Validates response status codes (200-299)
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
