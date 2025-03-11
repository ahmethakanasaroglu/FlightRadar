import UIKit

class KVKKBottomSheetViewController: UIViewController {
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.textColor = .label
        let text = """
        **Kişisel Verilerin Korunması Kanunu (KVKK)**
        
        FlightRadar uygulaması olarak, kişisel verilerinizin gizliliğine önem veriyoruz. İşbu aydınlatma metni, 6698 sayılı Kişisel Verilerin Korunması Kanunu ("KVKK") ve ilgili mevzuat kapsamında bilgilendirme amacıyla hazırlanmıştır.

        1. İşlenen Kişisel Verileriniz  
        Uygulamamızı kullanırken konum bilgileriniz, cihaz bilgileriniz ve uygulama içi etkileşim verileriniz işlenebilir.

        2. Kişisel Verilerin İşlenme Amaçları  
        - Uçuş takibi yapabilmeniz için gerekli harita ve uçuş bilgilerini sunmak  
        - Uygulama içi özelleştirilmiş bildirimler göndermek  
        - Kullanıcı deneyimini geliştirmek ve hata raporlarını değerlendirmek  

        3. Kişisel Verilerin Paylaşımı  
        Verileriniz üçüncü şahıslarla paylaşılmamaktadır. Ancak yasal gereklilikler doğrultusunda ilgili mercilere aktarılabilir.

        4. Haklarınız  
        - Kişisel verilerinizin işlenip işlenmediğini öğrenme  
        - Hatalı veya eksik işlenen verilerin düzeltilmesini isteme  
        - Verilerinizin silinmesini veya anonim hale getirilmesini talep etme  
        - Verilerinizin yalnızca belirli amaçlarla kullanılmasını talep etme  

        5. İletişim  
        KVKK ile ilgili sorularınız için [support@flightradar.com](mailto:support@flightradar.com) adresinden bize ulaşabilirsiniz.

        FlightRadar ekibi olarak gizliliğinize saygı duyuyoruz ve kişisel verilerinizi koruma konusunda gerekli tüm önlemleri alıyoruz.

        Son Güncelleme: Mart 2025
        """
        textView.text = text
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        applyBoldToHeadings()
    }
    
    private func setupUI() {
        view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }
    
    private func applyBoldToHeadings() {
        let text = textView.text ?? ""
        let attributedString = NSMutableAttributedString(string: text)
        
        let boldFont = UIFont.boldSystemFont(ofSize: 15)
        
        // Apply bold to the headings
        let headings = [
            "1. İşlenen Kişisel Verileriniz",
            "2. Kişisel Verilerin İşlenme Amaçları",
            "3. Kişisel Verilerin Paylaşımı",
            "4. Haklarınız",
            "5. İletişim"
        ]
        
        for heading in headings {
            if let range = text.range(of: heading) {
                let nsRange = NSRange(range, in: text)
                attributedString.addAttribute(.font, value: boldFont, range: nsRange)
            }
        }
        
        // Apply the attributed string to the textView
        textView.attributedText = attributedString
    }
}
