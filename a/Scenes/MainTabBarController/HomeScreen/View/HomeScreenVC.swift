import UIKit
import MapKit

class HomeScreenViewController: UIViewController, MKMapViewDelegate {
    
    private let viewModel = HomeScreenViewModel()
    private let mapView = MKMapView()
    private let locationManager = CLLocationManager()
    private let noInternetLabel: UILabel = {
        let label = UILabel()
        label.text = "İnternet bağlantınız yok!"
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .red
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.alpha = 0 // Başlangıçta gizli
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let locateMeButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "location.fill")
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .blue
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(didTapLocateMe), for: .touchUpInside)
        return button
    }()
    
    private let zoomInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.tintColor = .white
        button.backgroundColor = .gray
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(didTapZoomIn), for: .touchUpInside)
        return button
    }()
    
    private let zoomOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("-", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.tintColor = .white
        button.backgroundColor = .gray
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(didTapZoomOut), for: .touchUpInside)
        return button
    }()
    
    private let callSignTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Call Sign:"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let mapTypeSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Standart", "Uydu", "Hibrit"])
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(didChangeMapType), for: .valueChanged)
        return control
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        setupUI()
        bindViewModel()
        viewModel.fetchFlightData()
        viewModel.checkInternetConnection()  // Uygulama açıldığında interneti kontrol et
        
    }
    
    private func setupMapView() {
        view.addSubview(mapView)
        mapView.delegate = MapKitManager.shared
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupUI() {
        [locateMeButton, zoomInButton, zoomOutButton, noInternetLabel].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            noInternetLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70),
            noInternetLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            noInternetLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            noInternetLabel.heightAnchor.constraint(equalToConstant: 40),
            
            locateMeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            locateMeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            locateMeButton.widthAnchor.constraint(equalToConstant: 50),
            locateMeButton.heightAnchor.constraint(equalToConstant: 50),
            
            zoomInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            zoomInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            zoomInButton.widthAnchor.constraint(equalToConstant: 40),
            zoomInButton.heightAnchor.constraint(equalToConstant: 40),
            
            zoomOutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            zoomOutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 40),
            zoomOutButton.widthAnchor.constraint(equalToConstant: 40),
            zoomOutButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // StackView içinde textField ve segmentedControl'u yerleştir
        let stackView = UIStackView(arrangedSubviews: [callSignTextField, mapTypeSegmentedControl])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
    }
    
    private func bindViewModel() {
        viewModel.userLocation = { [weak self] location in
            self?.mapView.setRegion(MKCoordinateRegion(
                center: location.coordinate,
                latitudinalMeters: 1000,
                longitudinalMeters: 1000
            ), animated: true)
        }
        
        viewModel.mapType = { [weak self] mapType in
            self?.mapView.mapType = mapType
        }
        
        viewModel.flightData = { [weak self] flightModel in
            guard let self = self, let flights = flightModel?.states else { return }
            DispatchQueue.main.async {
                MapKitManager.shared.addAnnotations(to: self.mapView, with: flights)
            }
        }
        
        viewModel.onInternetStatusChanged = { [weak self] isConnected, message in
            DispatchQueue.main.async {
                self?.showInternetMessage(message, isConnected: isConnected)
            }
        }
    }
    
    private func showInternetMessage(_ message: String, isConnected: Bool) {
        guard !isConnected else { return } // Eğer internet varsa mesaj gösterme
        
        noInternetLabel.text = message
        noInternetLabel.alpha = 1 // Önce direkt görünür yap
        
        // "Tamam" butonunu oluştur
        let okButton = UIButton(type: .system)
        okButton.setTitle("Tamam", for: .normal)
        okButton.frame = CGRect(x: 280, y: noInternetLabel.frame.maxY + 5, width: 80, height: 33) // Buton konumu
        okButton.addTarget(self, action: #selector(dismissApp), for: .touchUpInside)
        
        // Buton stilini ayarla
        okButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17) // Kalın yazı tipi
        okButton.backgroundColor = .red // Kırmızı arka plan
        okButton.setTitleColor(.white, for: .normal) // Beyaz metin rengi
        okButton.layer.cornerRadius = 10 // Köşeleri yuvarlak yap
        okButton.layer.borderWidth = 2 // Çerçeve
        okButton.layer.borderColor = UIColor.white.cgColor // Çerçeve rengi
        
        // Butonu ekle
        view.addSubview(okButton)
        
        // Butonun görünmesini sağla
        okButton.alpha = 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1000000) { [weak self] in
            UIView.animate(withDuration: 1.0) {
                self?.noInternetLabel.alpha = 0
            }
        }
    }
    
    // Uygulamayı kapatma işlemi
    @objc private func dismissApp() {
        exit(0) // Uygulama kapanacak
    }
    
    @objc private func didTapLocateMe() {
        guard let userLocation = locationManager.location?.coordinate else { return }
        
        let region = MKCoordinateRegion(
            center: userLocation,
            latitudinalMeters: 50000,
            longitudinalMeters: 50000
        )
        mapView.setRegion(region, animated: true)
    }
    
    @objc private func didTapZoomIn() {
        var region = mapView.region
        region.span.latitudeDelta /= 2
        region.span.longitudeDelta /= 2
        mapView.setRegion(region, animated: true)
    }
    
    @objc private func didTapZoomOut() {
        var region = mapView.region
        region.span.latitudeDelta *= 2
        region.span.longitudeDelta *= 2
        mapView.setRegion(region, animated: true)
    }
    
    @objc private func didChangeMapType(_ sender: UISegmentedControl) {
        let selectedType: MKMapType = [
            .standard,
            .satellite,
            .hybrid
        ][sender.selectedSegmentIndex]
        viewModel.updateMapType(to: selectedType)
    }
    
}
