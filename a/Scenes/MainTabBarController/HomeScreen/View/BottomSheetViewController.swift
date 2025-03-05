import UIKit
import PanModal

class BottomSheetViewController: UIViewController, PanModalPresentable {
    
    var flight: State?
    
    private let flightInfoContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.systemTeal
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let flightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let flightInfoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Favorilere Ekle", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = UIColor.systemYellow
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addToFavorites), for: .touchUpInside)
        return button
    }()
    
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        displayFlightDetails()
    }
    
    private func setupUI() {
        view.addSubview(flightInfoContainer)
        flightInfoContainer.addSubview(flightImageView)
        flightInfoContainer.addSubview(flightInfoLabel)
        view.addSubview(separator)
        view.addSubview(favoriteButton)
        
        NSLayoutConstraint.activate([
            flightInfoContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            flightInfoContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            flightInfoContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            flightImageView.topAnchor.constraint(equalTo: flightInfoContainer.topAnchor),
            flightImageView.leadingAnchor.constraint(equalTo: flightInfoContainer.leadingAnchor),
            flightImageView.trailingAnchor.constraint(equalTo: flightInfoContainer.trailingAnchor),
            flightImageView.heightAnchor.constraint(equalToConstant: 120),
            
            flightInfoLabel.topAnchor.constraint(equalTo: flightImageView.bottomAnchor, constant: 10),
            flightInfoLabel.leadingAnchor.constraint(equalTo: flightInfoContainer.leadingAnchor, constant: 20),
            flightInfoLabel.trailingAnchor.constraint(equalTo: flightInfoContainer.trailingAnchor, constant: -20),
            flightInfoLabel.bottomAnchor.constraint(equalTo: flightInfoContainer.bottomAnchor, constant: -20),
            
            separator.topAnchor.constraint(equalTo: flightInfoContainer.bottomAnchor, constant: 20),
            separator.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            separator.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            separator.heightAnchor.constraint(equalToConstant: 1),
            
            favoriteButton.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 20),
            favoriteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            favoriteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            favoriteButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func displayFlightDetails() {
        guard let flight = flight else { return }
        
        // Flight details display
        flightInfoLabel.text = """
        Çağrı Kodu: \(flight.callSign ?? "N/A")
        Menşei Ülke: \(flight.originCountry ?? "N/A")
        Enlem: \(flight.latitude ?? 0)
        Boylam: \(flight.longitude ?? 0)
        Gerçek Hareket Yönü: \(flight.trueTrack ?? 0.0)
        Uluslararası Sivil Havacılık Örgütü Adresi: \(flight.icao24 ?? "")
        """
        
        // Check the first three letters of the callsign and set image accordingly
        if let callSign = flight.callSign {
            switch callSign.prefix(3) {
            case "THY":
                flightImageView.image = UIImage(named: "thy_logo") // Turkish Airlines logo
            case "PGT":
                flightImageView.image = UIImage(named: "pegasus_logo") // Pegasus Airlines logo
            case "SIA":
                flightImageView.image = UIImage(named: "singapore_logo") // Singapore Airlines logo
            case "BRU":
                flightImageView.image = UIImage(named: "belavia_logo") // Belavia logo
            case "ABY":
                flightImageView.image = UIImage(named: "arabia_logo") // Arabia logo
            case "TKJ":
                flightImageView.image = UIImage(named: "ajet_logo") // Arabia logo
            default:
                flightImageView.image = UIImage(named: "loading_logo") // Default loading image
            }
        }
    }
    
    @objc private func addToFavorites() {
        guard let flight = flight else { return }
        
        // Check if the flight is already in favorites
        if FavoritesViewModel.shared.isFlightInFavorites(flight) {
            // Eğer uçuş zaten favorilerdeyse, kullanıcıya bilgi ver
            let alert = UIAlertController(title: "Favori Uçuşlar",
                                          message: "Bu uçuş zaten favorilerinizde.",
                                          preferredStyle: .alert)
            
            // Add a checkmark icon next to the message
            let checkmarkImage = UIImage(systemName: "exclamationmark.triangle.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal)
            let checkmarkImageView = UIImageView(image: checkmarkImage)
            checkmarkImageView.frame = CGRect(x: 10, y: 10, width: 25, height: 25)
            alert.view.addSubview(checkmarkImageView)
            
            // "Tamam" butonunu ekleyelim
            alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: { _ in
                // Dismiss the bottom sheet after alert is dismissed
                self.dismiss(animated: true, completion: nil)
            }))
            
            present(alert, animated: true, completion: nil)
        } else {
            // Eğer uçuş favorilerde değilse, ekle
            FavoritesViewModel.shared.addFlightToFavorites(flight)
            
            // Favorilere eklendiğine dair bir alert göster
            let alert = UIAlertController(title: "Favori Uçuşlar",
                                          message: "Favori uçuşlara eklenmiştir.",
                                          preferredStyle: .alert)
            // Add a checkmark icon next to the message
            let checkmarkImage = UIImage(systemName: "checkmark.circle.fill")?.withTintColor(.green, renderingMode: .alwaysOriginal)
            let checkmarkImageView = UIImageView(image: checkmarkImage)
            checkmarkImageView.frame = CGRect(x: 10, y: 10, width: 25, height: 25)
            alert.view.addSubview(checkmarkImageView)
            
            // "Tamam" butonunu ekleyelim
            alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: { _ in
                // Dismiss the bottom sheet after alert is dismissed
                self.dismiss(animated: true, completion: nil)
            }))
            
            present(alert, animated: true, completion: nil)
        }
    }

    
    // PanModal settings
    var panScrollable: UIScrollView? {
        return nil
    }
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(420)
    }
    
    var longFormHeight: PanModalHeight {
        return .contentHeight(550)
    }
    
    var anchorModalToLongForm: Bool {
        return false
    }
}
