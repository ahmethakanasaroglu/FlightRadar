import Foundation

class GeneralSettingsViewModel {
    
    // Ayarların veri modelini tanımlıyoruz
    private(set) var settings: [(title: String, icon: String, detail: String?)] = [
        ("Konum Servisleri", "location", "Açık"),
        ("Bildirimler", "bell", "Uçuş alarmları etkin"),
        ("Veri Kullanımı", "wifi", "Otomatik"),
        ("Ses Efektleri", "speaker.wave.3", "Açık"),
        ("Favori Havaalanları", "star", "5 havaalanı"),
        ("Hakkında", "info.circle", "Sürüm: 1.2.0")
    ]
    
    // Ayar değişikliklerini yapmak için bir fonksiyon
    func updateSetting(at index: Int, newDetail: String) {
        guard index >= 0 && index < settings.count else { return }
        settings[index].detail = newDetail
    }
    
    // Ayarları almak için bir fonksiyon
    func setting(at index: Int) -> (title: String, icon: String, detail: String?) {
        return settings[index]
    }
}
