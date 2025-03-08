import MapKit

class HomeScreenViewModel: MapKitManagerDelegate {
    
    var mapType: ((MKMapType) -> Void)?
    var userLocation: ((CLLocation) -> Void)?
    var flightData: ((FlightModel?) -> Void)?
    
    var onInternetStatusChanged: ((Bool, String) -> Void)?
    
    private var timer: Timer?

    init() {
        MapKitManager.shared.delegate = self
        MapKitManager.shared.startUpdatingLocation()
        fetchFlightData()
        observeInternetConnection()
        // startUpdatingFlightData()
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
            } else {
                print("API'den Veri Alınamadı!")
            }
        }
    }
    
    // 5sn de bir servisi tetikliyor, sunum esnasında acılacak, daily-400 api request limit
//    func startUpdatingFlightData() {
//        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(fetchFlightData), userInfo: nil, repeats: true)
//    }

    
    func stopUpdatingFlightData() {
        timer?.invalidate()
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
