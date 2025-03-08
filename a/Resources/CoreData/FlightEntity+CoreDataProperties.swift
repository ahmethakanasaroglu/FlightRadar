import Foundation
import CoreData

extension FlightEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FlightEntity> {
        return NSFetchRequest<FlightEntity>(entityName: "FlightEntity")
    }

    @NSManaged public var icao24: String?
    @NSManaged public var callSign: String?
    @NSManaged public var originCountry: String?
    @NSManaged public var longitude: Double
    @NSManaged public var latitude: Double
    @NSManaged public var baroAltitude: Float
    @NSManaged public var velocity: Float
    @NSManaged public var trueTrack: Float
    @NSManaged public var geoAltitude: Float
}
