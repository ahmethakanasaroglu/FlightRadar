import MapKit
import CoreLocation

protocol MapKitManagerDelegate: AnyObject {
    func didUpdateUserLocation(_ location: CLLocation)
    func didUpdateMapType(_ mapType: MKMapType)
}

class MapKitManager: NSObject, CLLocationManagerDelegate, MKMapViewDelegate {
    static let shared = MapKitManager()
    
    var locationManager: CLLocationManager?
    weak var delegate: MapKitManagerDelegate?
    private var favoriteFlights: Set<String> = []
    var flightsModel: [State] = []
    var favoritesViewModel = FavoritesViewModel()
    
    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
    }
    
    // Annotations eklemek için fonksiyon
    // Annotations eklemek için fonksiyon (Sadece ekran içindekileri ekler)
    func addAnnotations(to mapView: MKMapView, with flights: [State]) {
        mapView.removeAnnotations(mapView.annotations) // Eski annotation'ları temizle
        
        let visibleRegion = mapView.region
        let minLat = visibleRegion.center.latitude - visibleRegion.span.latitudeDelta / 2
        let maxLat = visibleRegion.center.latitude + visibleRegion.span.latitudeDelta / 2
        let minLon = visibleRegion.center.longitude - visibleRegion.span.longitudeDelta / 2
        let maxLon = visibleRegion.center.longitude + visibleRegion.span.longitudeDelta / 2
        
        let visibleFlights = flights.filter { flight in
            guard let latitude = flight.latitude, let longitude = flight.longitude else { return false }
            return latitude >= minLat && latitude <= maxLat && longitude >= minLon && longitude <= maxLon
        }
        
        for flight in visibleFlights {
            if let latitude = flight.latitude, let longitude = flight.longitude {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
                flightsModel.append(flight)
                mapView.addAnnotation(annotation)
            }
        }
    }
    
    // annotation'a özel görsel ekleme
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "FlightAnnotation"
        
        if annotation is MKUserLocation {
            return nil // Kullanıcının konumu için özel bir görünüm atama
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.image = UIImage(named: "plane_icon")?.withTintColor(.yellow, renderingMode: .alwaysOriginal) // Uçak simgesi
            annotationView?.tintColor = .yellow
            annotationView?.frame.size = CGSize(width: 20, height: 20) // Simge boyutu
        } else {
            annotationView?.annotation = annotation
        }
        
        // Uçağın yönünü ayarla
        if let flight = flightsModel.first(where: { $0.latitude == annotation.coordinate.latitude && $0.longitude == annotation.coordinate.longitude }),
           let trueTrack = flight.trueTrack {
            annotationView?.updateRotation(with: CLLocationDegrees(trueTrack))
        }
        
        return annotationView
    }
    
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        addAnnotations(to: mapView, with: flightsModel) // Zoom değiştiğinde güncelle
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }
        
        if let flight = flightsModel.first(where: { $0.latitude == annotation.coordinate.latitude && $0.longitude == annotation.coordinate.longitude }) {
            let detailVC = BottomSheetViewController()
            detailVC.flight = flight
            
            if let topVC = UIApplication.shared.windows.first?.rootViewController {
                topVC.presentPanModal(detailVC)
            }
        }
        
        
    }
    
    
    func addFlightToFavorites(annotation: MKAnnotation) {
        guard let title = annotation.title ?? "", let subtitle = annotation.subtitle ?? "" else {
            print("Favorilere eklenemedi: Başlık veya alt başlık eksik.")
            return
        }
        
        // Yeni uçuş verisini oluştur
        let flight = State(
            icao24: flightsModel.first?.icao24,
            callSign: title,
            originCountry: subtitle,
            timePosition: nil,
            lastContact: nil,
            longitude: annotation.coordinate.longitude,
            latitude: annotation.coordinate.latitude,
            baroAltitude: nil,
            onGround: nil,
            velocity: nil,
            trueTrack: nil,
            verticalRate: nil,
            sensors: nil,
            geoAltitude: nil,
            squawk: nil,
            spi: nil,
            positionSource: nil
        )
        
        // Favorilere ekleyelim
        favoritesViewModel.addFlightToFavorites(flight)
        
        // ICAO24 kodunu favori listesine ekleyelim
        //        favoriteFlights.insert(flightICAO24!)
        //
        //            print("Uçuş favorilere eklendi: \(flightICAO24)")
    }
    
    
    /// **Konum İzni İsteme**
    func requestLocationPermission() {
        guard let locationManager = locationManager else {
            return
        }
        
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .notDetermined:
            print("Konum izni isteniyor...")
            locationManager.requestWhenInUseAuthorization()
            
        case .denied, .restricted:
            print("Konum izni reddedilmiş! Kullanıcıyı ayarlara yönlendiriyorum...")
            showSettingsAlert()
            
        case .authorizedWhenInUse, .authorizedAlways:
            print("Konum izni zaten verilmiş.")
            locationManager.startUpdatingLocation()
            
        @unknown default:
            print("Bilinmeyen yetki durumu!")
        }
    }
    
    /// **Konum izni değiştiğinde ne olacağını belirler**
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            print("Kullanıcı konum izni verdi, güncelleniyor...")
            locationManager?.startUpdatingLocation()
            
        case .denied:
            print("Kullanıcı konum iznini reddetti, ayarlara yönlendir...")
            showSettingsAlert()
            
        case .restricted:
            print("Konum izni kısıtlanmış, işlem yapılamaz.")
            
        default:
            break
        }
    }
    
    /// **Kullanıcının manuel olarak ayarları açmasını sağlar**
    func showSettingsAlert() {
        let alert = UIAlertController(
            title: "Konum İzni Gerekli",
            message: "Uygulamanın konumunuzu kullanabilmesi için lütfen ayarlardan izin verin.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Ayarları Aç", style: .default, handler: { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Vazgeç", style: .cancel))
        
        if let topVC = UIApplication.shared.windows.first?.rootViewController {
            topVC.present(alert, animated: true)
        }
    }
    
    
    
    /// **Kullanıcının konumunu güncellemeye başlar**
    func startUpdatingLocation() {
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager?.startUpdatingLocation()
        } else {
            requestLocationPermission()
        }
    }
    
    /// **Kullanıcının konumu değiştikçe güncelleme yapar**
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.last else { return }
        delegate?.didUpdateUserLocation(userLocation)
        
    }
    
    /// **Harita tipini değiştirir**
    func changeMapType(to mapType: MKMapType) {
        delegate?.didUpdateMapType(mapType)
    }
}

extension MKAnnotationView {
    
    func updateRotation(with trueTrack: CLLocationDegrees) {
        let rotationAngle = CGFloat(trueTrack * .pi / 270) // Dereceyi radyana çevir  // başta 180'di. derece düzeltildi.
        self.transform = CGAffineTransform(rotationAngle: rotationAngle)
    }
}

