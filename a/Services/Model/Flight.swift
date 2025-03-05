


struct FlightModel: Codable {
    
    var time: Int?
    var states: [State]?
    
}

struct State: Codable {
    var icao24: String?
    var callSign: String?
    var originCountry: String?
    var timePosition: Int?
    var lastContact: Int?
    var longitude: Double?
    var latitude: Double?
    var baroAltitude: Float?
    var onGround: Bool?
    var velocity: Float?
    var trueTrack: Float?
    var verticalRate: Float?
    var sensors: [Int]?
    var geoAltitude: Float?
    var squawk: String?
    var spi: Bool?
    var positionSource: Int?
    
    // Manuel init ekledik! (Decoder init bozulmadan çalışır.)
    init(
        icao24: String? = nil,
        callSign: String? = nil,
        originCountry: String? = nil,
        timePosition: Int? = nil,
        lastContact: Int? = nil,
        longitude: Double? = nil,
        latitude: Double? = nil,
        baroAltitude: Float? = nil,
        onGround: Bool? = nil,
        velocity: Float? = nil,
        trueTrack: Float? = nil,
        verticalRate: Float? = nil,
        sensors: [Int]? = nil,
        geoAltitude: Float? = nil,
        squawk: String? = nil,
        spi: Bool? = nil,
        positionSource: Int? = nil
    ) {
        self.icao24 = icao24
        self.callSign = callSign
        self.originCountry = originCountry
        self.timePosition = timePosition
        self.lastContact = lastContact
        self.longitude = longitude
        self.latitude = latitude
        self.baroAltitude = baroAltitude
        self.onGround = onGround
        self.velocity = velocity
        self.trueTrack = trueTrack
        self.verticalRate = verticalRate
        self.sensors = sensors
        self.geoAltitude = geoAltitude
        self.squawk = squawk
        self.spi = spi
        self.positionSource = positionSource
    }
    
    // Decoder init (Bunu değiştirmiyoruz)
    init(from decoder: Decoder) throws {
        var values = try decoder.unkeyedContainer()
        self.icao24 = try values.decode(String.self)
        self.callSign = try values.decode(String.self)
        self.originCountry = try values.decode(String.self)
        self.timePosition = try values.decodeIfPresent(Int.self)
        self.lastContact = try values.decode(Int.self)
        self.longitude = try values.decodeIfPresent(Double.self)
        self.latitude = try values.decodeIfPresent(Double.self)
        self.baroAltitude = try values.decodeIfPresent(Float.self)
        self.onGround = try values.decode(Bool.self)
        self.velocity = try values.decodeIfPresent(Float.self)
        self.trueTrack = try values.decodeIfPresent(Float.self)
        self.verticalRate = try values.decodeIfPresent(Float.self)
        self.sensors = try values.decodeIfPresent([Int].self)
        self.geoAltitude = try values.decodeIfPresent(Float.self)
        self.squawk = try values.decodeIfPresent(String.self)
        self.spi = try values.decode(Bool.self)
        self.positionSource = try values.decode(Int.self)
    }
}
