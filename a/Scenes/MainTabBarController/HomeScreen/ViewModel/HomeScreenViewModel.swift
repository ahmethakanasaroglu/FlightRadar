import MapKit

class HomeScreenViewModel: MapKitManagerDelegate {
    
    var mapType: ((MKMapType) -> Void)?
    var userLocation: ((CLLocation) -> Void)?
    var flightData: ((FlightModel?) -> Void)?
    
    var onInternetStatusChanged: ((Bool, String) -> Void)?
    
    
    init() {
        MapKitManager.shared.delegate = self
        MapKitManager.shared.startUpdatingLocation()
        fetchFlightData()
        observeInternetConnection()
        
    }
    
    
    private func observeInternetConnection() {
        NetworkMonitor.shared.connectionStatusChanged = { [weak self] isConnected in
            let statusText = isConnected ? "" : "İnternet bağlantınız yok!"
            self?.onInternetStatusChanged?(isConnected, statusText)
        }
    }
    
    func checkInternetConnection() {
        let isConnected = NetworkMonitor.shared.isConnected
        let statusText = isConnected ? "" : "İnternet bağlantınız yok! Çıkış Yapılıyor."
        onInternetStatusChanged?(isConnected, statusText)
    }
    
    func fetchFlightData() {
        FlightService.shared.flightRequest { [weak self] data in
            if let data = data {
                print(data)
                self?.flightData?(data)
                print(data)
            } else {
                print("API'den Veri Alınamadı!")
            }
        }
    }
    
    func didUpdateUserLocation(_ location: CLLocation) {
        userLocation?(location)
    }
    
    func didUpdateMapType(_ mapType: MKMapType) {
        self.mapType?(mapType)
    }
    
    func updateMapType(to mapType: MKMapType) {
        MapKitManager.shared.changeMapType(to: mapType)
    }
}
