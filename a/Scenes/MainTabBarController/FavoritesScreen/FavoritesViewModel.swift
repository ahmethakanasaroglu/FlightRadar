import UIKit
import CoreData

class FavoritesViewModel {
    private let coreDataManager: CoreDataManager
    private(set) var favoriteFlights: [State] = []

    
    init(coreDataManager: CoreDataManager = CoreDataManager.shared) {
        self.coreDataManager = coreDataManager
        loadFavorites()
    }
    
    // Favorilere uçuş ekleme
    func addFlightToFavorites(_ flight: State) {
        guard !coreDataManager.isFlightInFavorites(flight) else {
            print("Bu uçuş zaten favorilerde: \(flight.icao24!)")
            return
        }
        
        coreDataManager.addFlightToFavorites(flight)
        loadFavorites()  // Listeyi güncelle
    }
    
    // Favorilerden uçuş kaldırma
    func removeFlightFromFavorites(_ flight: State) {
        coreDataManager.removeFlightFromFavorites(flight)
        loadFavorites()  // Listeyi güncelle
    }
    
    // Favori uçuşları yükleme
    func loadFavorites() {
        let flightEntities = coreDataManager.fetchFavoriteFlights()
        
        favoriteFlights = flightEntities.map { flightEntity in
            let icao24 = flightEntity.icao24 ?? "Bilinmiyor"
            let callSign = flightEntity.callSign ?? "Bilinmiyor"
            let longitude = flightEntity.longitude
            let latitude = flightEntity.latitude
            
            return State(
                icao24: icao24,
                callSign: callSign,
                longitude: longitude,
                latitude: latitude
            )
        }
        
        // Güncelleme bildirimini gönder
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .favoritesUpdated, object: nil)
        }
    }
    
    
    // Uçuş favorilerde mi?
    func isFlightInFavorites(_ flight: State) -> Bool {
        return coreDataManager.isFlightInFavorites(flight)
    }
}

// Favori uçuşlar güncellendiğinde tetiklenecek bildirim
extension Notification.Name {
    static let favoritesUpdated = Notification.Name("favoritesUpdated")
}
