import UIKit

class FavoriteFlightCell: UITableViewCell {
    
    private let cardView = UIView()
    private let flightLabel = UILabel()
    private let flightIcon = UIImageView()
    private let originCountryLabel = UILabel()
    private let velocityLabel = UILabel()
    
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
        originCountryLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        originCountryLabel.textColor = .white
        cardView.addSubview(originCountryLabel)
        
        // Velocity (Hız Bilgisi)
        velocityLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        velocityLabel.textColor = .white
        cardView.addSubview(velocityLabel)
        
        // Auto Layout
        flightLabel.translatesAutoresizingMaskIntoConstraints = false
        flightIcon.translatesAutoresizingMaskIntoConstraints = false
        originCountryLabel.translatesAutoresizingMaskIntoConstraints = false
        velocityLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            flightLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 8),
            flightLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            
            flightIcon.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            flightIcon.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            
            originCountryLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            originCountryLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            
            velocityLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            velocityLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16)
        ])
    }
    
    func configure(with flight: State) {
        flightLabel.text = flight.callSign ?? "Bilinmeyen Uçuş"
        originCountryLabel.text = flight.originCountry ?? "Bilinmiyor"
        if let velocity = flight.velocity {
            velocityLabel.text = "\(velocity) km/h"
        } else {
            velocityLabel.text = "Hız Bilgisi Yok"
        }
    }
}
