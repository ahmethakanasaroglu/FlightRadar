import UIKit

class SettingsViewController: UIViewController {

    private let viewModel = SettingsViewModel()

    private let themeSwitch: UISwitch = {
        let switchControl = UISwitch()
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        return switchControl
    }()

    private let versionLabel: UILabel = {
        let label = UILabel()
        label.text = "Version 1.0.0"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let appInfoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("App Info", for: .normal)
        button.addTarget(self, action: #selector(didTapAppInfo), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let rateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Rate and Review", for: .normal)
        button.addTarget(self, action: #selector(didTapRateApp), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let supportButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Support", for: .normal)
        button.addTarget(self, action: #selector(didTapSupport), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Settings"

        setupUI()
        setupRightBarButton()

        themeSwitch.isOn = viewModel.isDarkMode

        
    }

    private func setupUI() {
        let mainStackView = UIStackView(arrangedSubviews: [versionLabel, appInfoButton, rateButton, supportButton])
        mainStackView.axis = .vertical
        mainStackView.spacing = 20
        mainStackView.alignment = .center
        mainStackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(mainStackView)

        // Center the main stack view
        NSLayoutConstraint.activate([
            mainStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
    }


    private func setupRightBarButton() {
        themeSwitch.addTarget(self, action: #selector(didToggleThemeSwitch), for: .valueChanged)
        let rightBarButton = UIBarButtonItem(customView: themeSwitch)
        navigationItem.rightBarButtonItem = rightBarButton
    }

    @objc private func didToggleThemeSwitch() {
        viewModel.toggleTheme(isOn: themeSwitch.isOn)
    }

    @objc private func didTapAppInfo() {
        let alert = UIAlertController(title: "App Info", message: "App Version: 1.0.0\nDeveloper: Your Name\nEmail: support@yourapp.com", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    @objc private func didTapRateApp() {
        if let url = URL(string: "https://www.apple.com/tr/app-store/") {
            UIApplication.shared.open(url)
        }
    }

    @objc private func didTapSupport() {
        if let url = URL(string: "https://yourapp.com/support") {
            UIApplication.shared.open(url)
        }
    }

}
