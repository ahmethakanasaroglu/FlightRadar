import UIKit

class FavoriteFlightCell: UITableViewCell {
    
    private let flightLabel = UILabel()
    private let countryLabel = UILabel()
    private let cardView = UIView()

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
            cardView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        // Flight Label
        flightLabel.font = UIFont.boldSystemFont(ofSize: 18)
        flightLabel.textColor = .white
        cardView.addSubview(flightLabel)
        
        flightLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            flightLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            flightLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16)
        ])
        
        // Country Label
        countryLabel.font = UIFont.systemFont(ofSize: 14)
        countryLabel.textColor = .white
        countryLabel.alpha = 0.8
        cardView.addSubview(countryLabel)
        
        countryLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            countryLabel.topAnchor.constraint(equalTo: flightLabel.bottomAnchor, constant: 8),
            countryLabel.leadingAnchor.constraint(equalTo: flightLabel.leadingAnchor)
        ])
    }
    
    func configure(with flight: State) {
        flightLabel.text = flight.callSign
        countryLabel.text = (flight.originCountry ?? "")
    }
}
