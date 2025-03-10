import UIKit

class GeneralSettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var viewModel = GeneralSettingsViewModel()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(GeneralSettingsCell.self, forCellReuseIdentifier: "GeneralSettingsCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Genel Ayarlar"
        view.backgroundColor = .systemBackground
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GeneralSettingsCell", for: indexPath) as! GeneralSettingsCell
        let setting = viewModel.setting(at: indexPath.row)
        cell.configure(with: setting)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Kullanıcı tıklanınca seçenek menüsünü göster
        let setting = viewModel.setting(at: indexPath.row)
        let options: [String]
        
        // Burada her satıra özel seçenekler tanımlıyoruz
        switch setting.title {
        case "Konum Servisleri":
            options = ["Açık", "Kapalı", "Sadece Wi-Fi"]
        case "Bildirimler":
            options = ["Uçuş alarmları etkin", "Uçuş alarmları kapalı"]
        case "Veri Kullanımı":
            options = ["Otomatik", "Manuel"]
        case "Ses Efektleri":
            options = ["Açık", "Kapalı"]
        case "Favori Havaalanları":
            options = ["5 havaalanı", "10 havaalanı", "Yok"]
        case "Hakkında":
            options = ["Sürüm: 1.2.0", "Sürüm: 1.3.0"]
        default:
            options = []
        }
        
        // Seçenekler için bir alert controller oluştur
        let alertController = UIAlertController(title: setting.title, message: "Bir seçenek seçin", preferredStyle: .actionSheet)
        
        for option in options {
            alertController.addAction(UIAlertAction(title: option, style: .default, handler: { _ in
                // Seçilen değeri ViewModel'e kaydet
                self.viewModel.updateSetting(at: indexPath.row, newDetail: option)
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }))
        }
        
        alertController.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
}
