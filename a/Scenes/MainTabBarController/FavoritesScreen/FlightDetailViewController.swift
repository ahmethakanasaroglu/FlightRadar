import UIKit
import MapKit

class FlightDetailViewController: UIViewController {
    
    private let flight: State
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let mapView = MKMapView()
    private let infoStackView = UIStackView()
    private let callSignLabel = UILabel()
    private let countryLabel = UILabel()
    private let altitudeLabel = UILabel()
    private let onGroundLabel = UILabel()
    private let velocityLabel = UILabel()
    private let trackLabel = UILabel()
    private let icao24Label = UILabel()
    private let airlineLogoImageView = UIImageView() // LOGO EKLENDİ
    
    init(flight: State) {
        self.flight = flight
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureUI()
    }
    
    private func setupUI() {
        title = "Uçuş Detayları"
        view.backgroundColor = .systemBackground
        
        // ScrollView ve ContentView ayarları
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // Map View Ayarları
        mapView.layer.cornerRadius = 12
        contentView.addSubview(mapView)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            mapView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mapView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mapView.heightAnchor.constraint(equalToConstant: 250)
        ])
        
        // LOGO İÇİN IMAGEVIEW AYARLAMALARI
        airlineLogoImageView.contentMode = .scaleAspectFit
        airlineLogoImageView.clipsToBounds = true
        airlineLogoImageView.layer.cornerRadius = 8
        contentView.addSubview(airlineLogoImageView)
        
        airlineLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            airlineLogoImageView.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 20),
            airlineLogoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            airlineLogoImageView.widthAnchor.constraint(equalToConstant: 100),
            airlineLogoImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        // Stack View Ayarları
        infoStackView.axis = .vertical
        infoStackView.spacing = 12
        infoStackView.alignment = .leading
        contentView.addSubview(infoStackView)
        
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoStackView.topAnchor.constraint(equalTo: airlineLogoImageView.bottomAnchor, constant: 20),
            infoStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            infoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            infoStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
        
        // Label Ayarları
        setupLabel(callSignLabel, fontSize: 20, weight: .bold)
        setupLabel(countryLabel, fontSize: 16, weight: .medium)
        setupLabel(altitudeLabel, fontSize: 16, weight: .medium)
        setupLabel(velocityLabel, fontSize: 16, weight: .medium)
        setupLabel(trackLabel, fontSize: 16, weight: .medium)
        setupLabel(icao24Label, fontSize: 16, weight: .medium)
        setupLabel(onGroundLabel, fontSize: 16, weight: .medium)

        
        // Stack'e ekleme
        infoStackView.addArrangedSubview(callSignLabel)
        infoStackView.addArrangedSubview(countryLabel)
        infoStackView.addArrangedSubview(altitudeLabel)
        infoStackView.addArrangedSubview(velocityLabel)
        infoStackView.addArrangedSubview(trackLabel)
        infoStackView.addArrangedSubview(icao24Label)
        infoStackView.addArrangedSubview(onGroundLabel)

        
        // Haritada konumu göster
        if let lat = flight.latitude, let lon = flight.longitude {
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = flight.callSign ?? "Bilinmeyen Uçuş"
            mapView.addAnnotation(annotation)
            
            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 50000, longitudinalMeters: 50000)
            mapView.setRegion(region, animated: true)
        }
    }
    
    private func setupLabel(_ label: UILabel, fontSize: CGFloat, weight: UIFont.Weight) {
        label.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        label.textColor = .label
    }
    
    private func configureUI() {
        callSignLabel.text = "Çağrı Kodu: \(flight.callSign ?? "Bilinmiyor")"
        countryLabel.text = "Menşei Ülke: \(flight.originCountry ?? "Bilinmiyor")"
        altitudeLabel.text = "İrtifa: \(flight.baroAltitude != nil ? "\(Int(flight.baroAltitude!)) m" : "Bilinmiyor")"
        velocityLabel.text = "Hız: \(flight.velocity != nil ? "\(Int(flight.velocity!)) km/h" : "Bilinmiyor")"
        trackLabel.text = "Yön: \(flight.trueTrack != nil ? "\(Int(flight.trueTrack!))°" : "Bilinmiyor")"
        icao24Label.text = "Uluslararası Sivil Havacılık Kodu: \(flight.icao24 ?? "Bilinmiyor")"
        onGroundLabel.text = "Karada mı? \(flight.onGround ?? false)"

        
        // LOGO AYARLAMASI
        if let callSign = flight.callSign {
            airlineLogoImageView.image = getAirlineLogo(for: callSign)
        } else {
            airlineLogoImageView.image = nil
        }
    }
    
    // UÇUŞUN İLK 3 HARFİNE GÖRE LOGO SEÇME FONKSİYONU
    private func getAirlineLogo(for callSign: String) -> UIImage? {
        let airlineCode = String(callSign.prefix(3)).uppercased()
        
        switch airlineCode {
        case "THY": return UIImage(named: "thy_logo")
        case "PGT": return UIImage(named: "pegasus_logo")
        case "SIA": return UIImage(named: "singapore_logo")
        case "BRU": return UIImage(named: "belavia_logo")
        case "ABY": return UIImage(named: "arabia_logo")
        case "TKJ": return UIImage(named: "ajet_logo")
        default: return UIImage(named: "loading_logo")
        }
    }
}
