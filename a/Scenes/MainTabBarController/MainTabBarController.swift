import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        updateAppearance()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateAppearance()
        }
    }
    
    private func setupTabBar() {
        tabBar.isTranslucent = false
        
        let homeVC = HomeScreenViewController()
        let favoritesVC = FavoritesViewController()
        let settingsVC = SettingsViewController()
        // Sembol ve renk ayarları
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        favoritesVC.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "heart.fill"), tag: 1)
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear.fill"), tag: 2)
        
        let homeNav = UINavigationController(rootViewController: homeVC)
        let favoritesNav = UINavigationController(rootViewController: favoritesVC)
        let settingsNav = UINavigationController(rootViewController: settingsVC)
        
        
        // Seçili tab'ı belirginleştirmek için ikonları değiştiriyoruz
        let selectedHomeIcon = UIImage(systemName: "house.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.blue.withAlphaComponent(0.6))
        let unselectedHomeIcon = UIImage(systemName: "house")?.withRenderingMode(.alwaysOriginal).withTintColor(.blue.withAlphaComponent(0.6))
        
        let selectedFavoritesIcon = UIImage(systemName: "heart.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.blue.withAlphaComponent(0.6))
        let unselectedFavoritesIcon = UIImage(systemName: "heart")?.withRenderingMode(.alwaysOriginal).withTintColor(.blue.withAlphaComponent(0.6))
        
        let selectedSettingsIcon = UIImage(systemName: "gear.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.blue.withAlphaComponent(0.6))
        let unselectedSettingsIcon = UIImage(systemName: "gear")?.withRenderingMode(.alwaysOriginal).withTintColor(.blue.withAlphaComponent(0.6))
        
        homeVC.tabBarItem.selectedImage = selectedHomeIcon
        homeVC.tabBarItem.image = unselectedHomeIcon
        
        favoritesVC.tabBarItem.selectedImage = selectedFavoritesIcon
        favoritesVC.tabBarItem.image = unselectedFavoritesIcon
        
        settingsVC.tabBarItem.selectedImage = selectedSettingsIcon
        settingsVC.tabBarItem.image = unselectedSettingsIcon
        
        viewControllers = [homeNav, favoritesNav, settingsNav]
    }
    
    private func updateAppearance() {
        if traitCollection.userInterfaceStyle == .dark {
            tabBar.backgroundColor = .black
            tabBar.tintColor = .white
            tabBar.unselectedItemTintColor = .lightGray
        } else {
            tabBar.backgroundColor = .white
            tabBar.tintColor = .blue
            tabBar.unselectedItemTintColor = .gray
        }
    }
}

