import UIKit
import Lottie

class SplashScreenViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    private let viewModel = SplashScreenViewModel()
    private var pageViewController: UIPageViewController!
    private var lottieViews: [LottieAnimationView] = []
    private var infoLabels: [UILabel] = [] // Yeni eklenen array, her animasyon için bilgi metinlerini tutacak
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Uygulamaya Hoşgeldiniz"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .black
        return label
    }()
    
    private let continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Devam Et", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(didTapContinue), for: .touchUpInside)
        return button
    }()
    
    private let pageControl: UIPageControl = {
        let control = UIPageControl()
        control.currentPageIndicatorTintColor = .red
        control.pageIndicatorTintColor = .lightGray
        return control
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        if viewModel.shouldShowSplashScreen() {
            showSplashScreen()
        } else {
            navigateToHomeScreen()
        }
        MapKitManager.shared.requestLocationPermission()
        setupLottieAnimations()
        setupPageViewController()
        setupUI()
    }
    
    func showSplashScreen() {
        // Splash ekranını göster ve belirli bir süre sonra HomeScreen'e yönlendir
        DispatchQueue.main.asyncAfter(deadline: .now() + 100000) {
            self.viewModel.saveSplashSeen()
            self.navigateToHomeScreen()
        }
    }
    
    
    private func setupLottieAnimations() {
        for animationName in viewModel.animations {
            let animationView = LottieAnimationView(name: animationName)
            animationView.loopMode = .loop
            animationView.contentMode = .scaleAspectFit
            lottieViews.append(animationView)
            
            let infoLabel = UILabel()
            infoLabel.text = viewModel.getInfoText(for: animationName) // Her animasyon için metni alır
            infoLabel.textAlignment = .center
            infoLabel.font = UIFont.systemFont(ofSize: 16)
            infoLabel.textColor = .black
            infoLabels.append(infoLabel)
        }
        pageControl.numberOfPages = lottieViews.count
    }
    
    private func setupPageViewController() {
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        if let firstVC = getLottieVC(for: 0) {
            pageViewController.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        // view'a subview olarak eklediğimiz zamanlarda pageViewController için alttaki 3 kod hep lazım
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
    }
    
    private func setupUI() {
        view.addSubview(welcomeLabel)
        view.addSubview(continueButton)
        view.addSubview(pageControl)
        
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            pageViewController.view.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageViewController.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            
            pageControl.topAnchor.constraint(equalTo: pageViewController.view.bottomAnchor, constant: 20),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            continueButton.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 20),
            continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            continueButton.widthAnchor.constraint(equalToConstant: 150),
            continueButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    @objc private func didTapContinue() {
        let currentIndex = pageControl.currentPage
        
        // Eğer şu anda son sayfada değilsek
        if currentIndex < lottieViews.count - 1 {
            let nextIndex = currentIndex + 1
            let nextVC = getLottieVC(for: nextIndex)
            
            // Sayfayı ileriye doğru kaydır
            pageViewController.setViewControllers([nextVC!], direction: .forward, animated: true) { _ in
                // Sayfa geçişi tamamlandığında index'i güncelle
                self.pageControl.currentPage = nextIndex
                // Buton başlığını güncelle
                if nextIndex == self.lottieViews.count - 1 {
                    DispatchQueue.main.async {
                        self.continueButton.setTitle("Bitir", for: .normal)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.continueButton.setTitle("Devam Et", for: .normal)
                    }
                }
            }
        } else {
            // Son sayfadaysak, uygulamayı başlat
            continueButton.setTitle("Bitir", for: .normal)
            navigateToHomeScreen()
            viewModel.saveSplashSeen()
        }
    }
    
    
    private func navigateToHomeScreen() {
        let homeVC = MainTabBarController()
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = UINavigationController(rootViewController: homeVC)
            window.makeKeyAndVisible()
        }
    }
    
    private func getLottieVC(for index: Int) -> UIViewController? {
        guard index >= 0, index < lottieViews.count else { return nil }
        
        let vc = UIViewController()
        vc.view.backgroundColor = .white
        let animationView = lottieViews[index]
        let infoLabel = infoLabels[index]
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        vc.view.addSubview(animationView)
        vc.view.addSubview(infoLabel)
        
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor),
            animationView.widthAnchor.constraint(equalTo: vc.view.widthAnchor, multiplier: 0.8),
            animationView.heightAnchor.constraint(equalTo: vc.view.heightAnchor, multiplier: 0.6),
            
            infoLabel.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: 20),
            infoLabel.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
            infoLabel.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor, constant: 20),
            infoLabel.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor, constant: -20)
        ])
        
        animationView.play()
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = lottieViews.firstIndex(where: { viewController.view.subviews.contains($0) }), index > 0 else { return nil }
        return getLottieVC(for: index - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = lottieViews.firstIndex(where: { viewController.view.subviews.contains($0) }), index < lottieViews.count - 1 else { return nil }
        return getLottieVC(for: index + 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let currentVC = pageViewController.viewControllers?.first,
              let index = lottieViews.firstIndex(where: { currentVC.view.subviews.contains($0) }) else { return }
        
        print("Current index: \(index)")  // Burada index'i kontrol et
        pageControl.currentPage = index
        
        // Son sayfada mı olduğumuzu kontrol et
        if index == lottieViews.count - 1 {
            DispatchQueue.main.async {
                self.continueButton.setTitle("Bitir", for: .normal)
            }
        } else {
            DispatchQueue.main.async {
                self.continueButton.setTitle("Devam Et", for: .normal)
            }
        }
    }
    
    
    
    
}
