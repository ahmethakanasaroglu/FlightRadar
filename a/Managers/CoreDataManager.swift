import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer
    
    init() {
        persistentContainer = NSPersistentContainer(name: "CoreData") // Data Model adını buraya yaz
        persistentContainer.loadPersistentStores { (_, error) in
            if let error = error {
                print("Core Data yüklenirken hata oluştu: \(error.localizedDescription)")
            }
        }
    }
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // Favori uçuşu kaydetme
    func addFlightToFavorites(_ flight: State) {
        let flightEntity = FlightEntity(context: context)
        flightEntity.icao24 = flight.icao24
        flightEntity.callSign = flight.callSign
        flightEntity.latitude = flight.latitude ?? 0.0
        flightEntity.longitude = flight.longitude ?? 0.0
        
        saveContext()
    }
    
    // Favori uçuşu silme
    func removeFlightFromFavorites(_ flight: State) {
        let fetchRequest: NSFetchRequest<FlightEntity> = FlightEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "icao24 == %@", flight.icao24!)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let flightToDelete = results.first {
                context.delete(flightToDelete)
                saveContext()
            }
        } catch {
            print("Favori uçuş silinirken hata oluştu: \(error.localizedDescription)")
        }
    }
    
    // Favori uçuşları getirme
    func fetchFavoriteFlights() -> [FlightEntity] {
        let fetchRequest: NSFetchRequest<FlightEntity> = FlightEntity.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Favori uçuşlar çekilirken hata oluştu: \(error.localizedDescription)")
            return []
        }
    }
    
    // Belirli bir uçuş favorilerde mi?
    func isFlightInFavorites(_ flight: State) -> Bool {
        let fetchRequest: NSFetchRequest<FlightEntity> = FlightEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "icao24 == %@", flight.icao24!)
        
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Favori kontrol edilirken hata oluştu: \(error.localizedDescription)")
            return false
        }
    }
    
    // Veriyi kaydetme
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Core Data kaydetme hatası: \(error.localizedDescription)")
        }
    }
}
