import UIKit

class AboutAppDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let sections = [
        ("Sürüm", "5.2.0"),
        ("Gizlilik Politikası", "https://example.com/privacy"),
        ("Üçüncü Taraf Lisanslar", "https://example.com/licenses"),
        ("Kullanım Şartları", "https://example.com/terms"),
        ("Platform Kuralları", "https://example.com/rules")
    ]
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20) // Daha düzgün dividerlar
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Uygulama Hakkında"
        
        tableView.dataSource = self
        tableView.delegate = self
        
        setupUI()
    }
    
    func setupUI() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - TableView DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let section = sections[indexPath.row]
        
        if section.0 == "Sürüm" {
            // Sürüm için özel bir düzenleme
            cell.textLabel?.text = "Sürüm"
            cell.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
            cell.textLabel?.textColor = .black
            
            let versionLabel = UILabel()
            versionLabel.translatesAutoresizingMaskIntoConstraints = false
            versionLabel.text = section.1
            versionLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
            versionLabel.textColor = .gray
            versionLabel.textAlignment = .right
            
            cell.contentView.addSubview(versionLabel)
            
            // Sürüm label'ının sağa yaslanması için constraint ekliyoruz
            NSLayoutConstraint.activate([
                versionLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                versionLabel.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -20)
            ])
            
            cell.accessoryType = .none
        } else {
            cell.textLabel?.text = section.0
            cell.accessoryType = .disclosureIndicator  // Diğer hücrelerde ok simgesi göster
        }
        
        updateTextColor(for: cell)  // Yazı rengini güncelle
        
        return cell
    }
    
    // MARK: - TableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = sections[indexPath.row]
        
        if section.0 != "Sürüm", let url = URL(string: section.1) {
            UIApplication.shared.open(url)
        }
        
        tableView.deselectRow(at: indexPath, animated: true) // Seçili satırı tekrar eski haline getir
    }
    
    // MARK: - TableView Divider
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60  // Satır yüksekliği
    }
    
    // Bölücü (divider) ekleme
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let divider = UIView()
        divider.backgroundColor = .lightGray
        divider.frame = CGRect(x: 0, y: cell.frame.size.height - 1, width: cell.frame.size.width , height: 1)
        cell.addSubview(divider)
    }
    
    // MARK: - Dark Mode and Light Mode Support
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            tableView.reloadData() // Tema değiştikçe yazı rengini güncellemek için
        }
    }
    
    func updateTextColor(for cell: UITableViewCell) {
        if traitCollection.userInterfaceStyle == .dark {
            cell.textLabel?.textColor = .white  // Dark Mode'da beyaz yazı
        } else {
            cell.textLabel?.textColor = .black  // Light Mode'da siyah yazı
        }
    }
}
