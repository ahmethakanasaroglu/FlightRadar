import UIKit

class SettingsViewController: UIViewController {
    
    let viewModel = SettingsViewModel()
    var tableView = UITableView()
    
    private let themeSwitchButton = ThemeSwitchButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRightBarButton()
    }
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Ayarlar"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
    }
    
    private func setupRightBarButton() {
        let rightBarButton = UIBarButtonItem(customView: themeSwitchButton)
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3  // 3. section eklendi
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel.getSettingsOptions().count
        } else if section == 1 {
            return 3 // Sosyal medya hesapları sayısı
        } else {
            return 1 // Çıkış yap
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Uygulama Tercihleri"
        case 1:
            return "Bizi Takip Edin"
        default:
            return nil // Çıkış bölümüne başlık istemiyoruz
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if indexPath.section == 0 {
            let settingOption = viewModel.getSettingsOptions()[indexPath.row]
            cell.textLabel?.text = settingOption.title
            cell.imageView?.image = settingOption.icon
            cell.textLabel?.textColor = .label
            
        } else if indexPath.section == 1 {
            let socialMediaAccounts = [
                ("Youtube", "play.rectangle"),
                ("Instagram", "camera"),
                ("LinkedIn", "link")
            ]
            
            let account = socialMediaAccounts[indexPath.row]
            cell.textLabel?.text = account.0
            cell.imageView?.image = UIImage(systemName: account.1)
            cell.textLabel?.textColor = .label
            
        } else {
            // Çıkış Yap Hücresi
            cell.textLabel?.text = "Uygulamayı Kapat"
            cell.textLabel?.textColor = .systemRed
            cell.textLabel?.textAlignment = .center
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            let settingOption = viewModel.getSettingsOptions()[indexPath.row].title
            
            switch settingOption {
            case "Kişisel Verilerin Korunması":
                let kvkkVC = KVKKBottomSheetViewController()
                    if let sheet = kvkkVC.sheetPresentationController {
                        sheet.detents = [.medium(), .large()] // Orta ve büyük açılma modları
                        sheet.prefersGrabberVisible = true // Kullanıcının yukarı çekerek büyütmesini sağlar
                    }
                    present(kvkkVC, animated: true)
            case "Görüş & Yorumlar":
                viewModel.openURL("https://www.apple.com/tr/app-store/")
            case "Destek":
                viewModel.openURL("https://example.com/support")
            case "Uygulama Hakkında":
                let aboutAppDetailVC = AboutAppDetailViewController()
                navigationController?.pushViewController(aboutAppDetailVC, animated: true)
            default:
                break
            }
        } else if indexPath.section == 1 {
            let socialMediaLinks = [
                "https://youtube.com/example",
                "https://instagram.com/example",
                "https://www.linkedin.com/in/ahmet-hakan-asaroğlu-05b60b220/"
            ]
            viewModel.openURL(socialMediaLinks[indexPath.row])
        } else {
            // Uygulamayı kapatma işlemi
            exit(0)
        }
    }
}
