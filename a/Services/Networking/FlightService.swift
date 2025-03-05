import Foundation

final class FlightService {
    
    static let shared = FlightService()
    
    func flightRequest(completion: @escaping (FlightModel?) -> ()) {
        //let baseURL = "https://api.aviationstack.com/v1/flights" // Gerçek API URL'sini buraya ekleyin
        //let urlString = "\(baseURL)?access_key=b8d8340825143919a7d6e63d4c162cde" // API Key eklemeyi unutma!
        NetworkManager.shared.request(type: FlightModel.self, url: "https://opensky-network.org/api/states/all") { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let data):
                completion(data)
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
    }
    
}
