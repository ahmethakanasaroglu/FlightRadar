import Foundation
import CoreData

class FavoritesViewModel: ObservableObject {
    static let shared = FavoritesViewModel()
    
    @Published private(set) var favoriteFlights: [State] = []
    
    private init() {
        loadFavorites()
    }
    
    // Favorilere uçuş ekleme
    func addFlightToFavorites(_ flight: State) {
        guard !CoreDataManager.shared.isFlightInFavorites(flight) else {
            print("Bu uçuş zaten favorilerde: \(flight.icao24!)")
            return
        }
        
        CoreDataManager.shared.addFlightToFavorites(flight)
        loadFavorites()  // Listeyi güncelle
    }
    
    // Favorilerden uçuş kaldırma
    func removeFlightFromFavorites(_ flight: State) {
        CoreDataManager.shared.removeFlightFromFavorites(flight)
        loadFavorites()  // Listeyi güncelle
    }
    
    // Favori uçuşları yükleme (Core Data'dan çekiyoruz)
    func loadFavorites() {
        let flightEntities = CoreDataManager.shared.fetchFavoriteFlights()
        
        favoriteFlights = flightEntities.map { flightEntity in
            let icao24 = flightEntity.icao24 ?? "Bilinmiyor"
            let callSign = flightEntity.callSign ?? "Bilinmiyor"
            let longitude = flightEntity.longitude
            let latitude = flightEntity.latitude
            
            print("Uçuş: \(icao24), CallSign: \(callSign), Longitude: \(longitude), Latitude: \(latitude)")
            
            return State(
                icao24: icao24,
                callSign: callSign,
                longitude: longitude,
                latitude: latitude
            )
        }
        
        print("Favoriler yüklendi: \(favoriteFlights.count) uçuş")
    }
    
    // Uçuş favorilerde mi?
    func isFlightInFavorites(_ flight: State) -> Bool {
        return CoreDataManager.shared.isFlightInFavorites(flight)
    }
}
