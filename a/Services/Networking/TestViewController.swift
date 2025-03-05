//import UIKit
//
//class TestViewController: UIViewController {
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        fetchFlightData()
//    }
//    
//    private func fetchFlightData() {
//        FlightService.shared.flightRequest { flightModel in
//            guard let flightModel = flightModel else { return }
//            
//            // Latitude ve Longitude değerlerini kontrol et
//            for flight in flightModel.data! {
//                if let lat = flight.live?.latitude, let lon = flight.live?.longitude {
//                    print("Canlı Uçuş Konumu: \(lat), \(lon)")
//                }
//            }
//        }
//        
//    }
//}
