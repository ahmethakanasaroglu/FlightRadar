import UIKit

class SettingsViewModel {
    
    private let themeKey = "selectedTheme"
    
    var isDarkMode: Bool {
        return UserDefaults.standard.bool(forKey: themeKey)
    }
    
    func toggleTheme(isOn: Bool) {
        UserDefaults.standard.set(isOn, forKey: themeKey)
        applyTheme(isDarkMode: isOn)
    }
    
    func applyTheme(isDarkMode: Bool) {
        DispatchQueue.main.async {
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let window = windowScene?.windows.first
            window?.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
        }
    }
    
    // Genel ayarların verilerini döndür
    func getSettingsOptions() -> [(title: String, icon: UIImage)] {
        return [
            ("Genel Ayarlar", UIImage(systemName: "gearshape")!),
            ("Tema Ayarları", UIImage(systemName: "paintbrush")!),
            ("Destek", UIImage(systemName: "questionmark.circle")!),
            ("Uygulama Hakkında", UIImage(systemName: "info.circle")!)
        ]
    }
    
    // Safari'de URL açma fonksiyonu
    func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    // Dil değişikliği
    func changeLanguage(to language: String) {
        UserDefaults.standard.set(language, forKey: "appLanguage")
        NotificationCenter.default.post(name: NSNotification.Name("LanguageChanged"), object: nil)
    }
}
