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
}
