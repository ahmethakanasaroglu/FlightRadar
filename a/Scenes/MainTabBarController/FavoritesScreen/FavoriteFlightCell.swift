import UIKit

class FavoriteFlightCell: UITableViewCell {
    
    private let cardView = UIView()
    private let flightLabel = UILabel()
    private let flightIcon = UIImageView()
    private let icao24Label = UILabel()
    private let latitudeLabel = UILabel()
    private let longitudeLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        
        // CardView
        cardView.backgroundColor = .systemBlue
        cardView.layer.cornerRadius = 12
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.2
        cardView.layer.shadowOffset = CGSize(width: 2, height: 4)
        cardView.layer.shadowRadius = 4
        contentView.addSubview(cardView)
        
        cardView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            cardView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        // Flight Label (Uçuş No)
        flightLabel.font = UIFont.boldSystemFont(ofSize: 18)
        flightLabel.textColor = .white
        cardView.addSubview(flightLabel)
        
        // Uçak İkonu
        flightIcon.image = UIImage(systemName: "airplane")
        flightIcon.tintColor = .white
        cardView.addSubview(flightIcon)
        
        // Origin Country (Kalkış Ülkesi)
        icao24Label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        icao24Label.textColor = .white
        cardView.addSubview(icao24Label)
        
        
        // Latitude (Enlem Bilgisi)
        latitudeLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        latitudeLabel.textColor = .white
        cardView.addSubview(latitudeLabel)
        
        // Longitude (Boylam Bilgisi)
        longitudeLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        longitudeLabel.textColor = .white
        cardView.addSubview(longitudeLabel)
        
        // Auto Layout
        flightLabel.translatesAutoresizingMaskIntoConstraints = false
        flightIcon.translatesAutoresizingMaskIntoConstraints = false
        icao24Label.translatesAutoresizingMaskIntoConstraints = false
        latitudeLabel.translatesAutoresizingMaskIntoConstraints = false
        longitudeLabel.translatesAutoresizingMaskIntoConstraints = false


        NSLayoutConstraint.activate([
            flightLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 8),
            flightLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            
            flightIcon.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            flightIcon.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            
            icao24Label.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            icao24Label.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            
            latitudeLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            latitudeLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            
            longitudeLabel.topAnchor.constraint(equalTo: latitudeLabel.bottomAnchor ),
            longitudeLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16)
        ])
    }
    
    func configure(with flight: State) {
        flightLabel.text = "Çağrı Kodu: \(flight.callSign ?? "Bilinmeyen Uçuş")"
        icao24Label.text = "Adres: \(flight.icao24 ?? "Bilinmiyor")"
        if let latitude = flight.latitude {
            latitudeLabel.text = "Enlem: \(latitude) m"
        } else {
            latitudeLabel.text = "Enlem Bilgisi Yok"
        }
        if let longitude = flight.longitude {
            longitudeLabel.text = "Boylam: \(longitude) m"
        } else {
            longitudeLabel.text = "Boylam Bilgisi Yok"
        }
    }
}
