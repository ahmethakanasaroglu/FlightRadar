import UIKit

class SettingsViewController: UIViewController {
    
    let viewModel = SettingsViewModel()
    var tableView = UITableView()
    
    private let themeSwitch: UISwitch = {
        let switchControl = UISwitch()
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        return switchControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRightBarButton()
        
        themeSwitch.isOn = viewModel.isDarkMode
    }
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Ayarlar"
        
        // TableView kurulumu
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
    }
    
    private func setupRightBarButton() {
        themeSwitch.addTarget(self, action: #selector(didToggleThemeSwitch), for: .valueChanged)
        let rightBarButton = UIBarButtonItem(customView: themeSwitch)
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc private func didToggleThemeSwitch() {
        viewModel.toggleTheme(isOn: themeSwitch.isOn)
    }
    
    // Dil Seçimi Alert
    func showThemeSelection() {
        let alert = UIAlertController(title: "Tema Seç", message: "Lütfen bir tema seçin", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Dark", style: .default, handler: { _ in
            // Koyu tema seçildiğinde tema değiştir
            self.setAppTheme(to: .dark)
        }))
        
        alert.addAction(UIAlertAction(title: "Light", style: .default, handler: { _ in
            // Açık tema seçildiğinde tema değiştir
            self.setAppTheme(to: .light)
        }))
        
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
        
        present(alert, animated: true)
    }

    func setAppTheme(to style: UIUserInterfaceStyle) {
        // Kullanıcı tercihini UserDefaults'a kaydet
        UserDefaults.standard.set(style.rawValue, forKey: "selectedTheme")
        
        // Uygulamanın temasını ayarla
        if #available(iOS 13.0, *) {
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = style
        }
    }

    
    // Alert ile Uygulama Bilgisi Gösterme
    func showAppInfoAlert() {
        let alert = UIAlertController(title: "Uygulama Hakkında", message: "Bu bir test uygulamasıdır.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 // Genel Ayarlar ve Yardım
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return viewModel.getSettingsOptions().count // Genel ayarlar
        case 1:
            return 1 // Yardım
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Genel Ayarlar"
        case 1:
            return "Yardım ve Destek"
        default:
            return nil
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if indexPath.section == 0 {
            let settingOption = viewModel.getSettingsOptions()[indexPath.row]
            cell.textLabel?.text = settingOption.title
            cell.imageView?.image = settingOption.icon
        } else {
            cell.textLabel?.text = "Uygulama Hakkında"
            cell.imageView?.image = UIImage(systemName: "info.circle")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            let settingOption = viewModel.getSettingsOptions()[indexPath.row].title
            
            switch settingOption {
            case "Genel Ayarlar":
                navigationController?.pushViewController(GeneralSettingsViewController(), animated: true)
            case "Tema Ayarları":
                showThemeSelection()
            case "Destek":
                viewModel.openURL("https://example.com/support")
            case "Uygulama Hakkında":
                viewModel.openURL("https://example.com/about")
            default:
                break
            }
        }
    }
}
