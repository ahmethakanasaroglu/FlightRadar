import Foundation

final class SplashScreenViewModel {
    
    let animations = ["Animation - 1739971059873", "Animation - 1739971095243", "Animation - 1739967059887"]
    
    enum SplashSeen: Int {
        case seen = 1
        case unSeen = 0
    }
    
    var splashSeen: SplashSeen {
        didSet {
            UserDefaults.standard.set(splashSeen.rawValue, forKey: "seen")
        }
    }
    
    init() {
        let seenValue = UserDefaults.standard.integer(forKey: "seen")
        splashSeen = SplashSeen(rawValue: seenValue) ?? .unSeen
    }
    
    func saveSplashSeen() {
        splashSeen = .seen
    }
    
    func shouldShowSplashScreen() -> Bool {
        return splashSeen == .unSeen
    }
    
    
    func getInfoText(for animation: String) -> String {
        switch animation {
        case "Animation - 1739971059873":
            return "Uçuş Bilgilerinize Anında Erişin!"
        case "Animation - 1739971095243":
            return "Bu Uygulama Uçuş Radar Takibini Kolaylaştırır!"
        case "Animation - 1739967059887":
            return "Uygulama İçin Konum İzniniz Gerekmektedir!"
        default:
            return ""
        }
    }
}


