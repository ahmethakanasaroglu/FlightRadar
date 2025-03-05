import MapKit

class FlightAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var trueTrack: Float? // Uçuş yönü burada tanımlandı
    var icao24: String?
    var callSign: String?
    var originCountry: String?

    init(flight: State) {
        self.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(flight.latitude ?? 0.0),
                                                 longitude: CLLocationDegrees(flight.longitude ?? 0.0))
        self.title = flight.callSign ?? "Bilinmeyen Uçuş"
        self.subtitle = flight.originCountry ?? "Bilinmeyen Ülke"
        self.trueTrack = flight.trueTrack //  TrueTrack değerini atadık
        self.icao24 = flight.icao24 ?? "UNKNOWN"
        self.callSign = flight.callSign
        self.originCountry = flight.originCountry
    }
}
