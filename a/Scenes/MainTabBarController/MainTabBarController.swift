import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeVC = HomeScreenViewController()
        let favoritesVC = FavoritesViewController()
        
        // Sembol ve renk ayarları
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        favoritesVC.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "heart.fill"), tag: 1)
        
        let homeNav = UINavigationController(rootViewController: homeVC)
        let favoritesNav = UINavigationController(rootViewController: favoritesVC)
        
        viewControllers = [homeNav, favoritesNav]
 
        // Seçili tab'ı belirginleştirmek için ikonları değiştiriyoruz
        let selectedHomeIcon = UIImage(systemName: "house.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.blue.withAlphaComponent(0.6))
        let unselectedHomeIcon = UIImage(systemName: "house")?.withRenderingMode(.alwaysOriginal).withTintColor(.blue.withAlphaComponent(0.6))
                
        let selectedFavoritesIcon = UIImage(systemName: "heart.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.blue.withAlphaComponent(0.6))
        let unselectedFavoritesIcon = UIImage(systemName: "heart")?.withRenderingMode(.alwaysOriginal).withTintColor(.blue.withAlphaComponent(0.6))
                
                homeVC.tabBarItem.selectedImage = selectedHomeIcon
                homeVC.tabBarItem.image = unselectedHomeIcon
                
                favoritesVC.tabBarItem.selectedImage = selectedFavoritesIcon
                favoritesVC.tabBarItem.image = unselectedFavoritesIcon
    }
}

