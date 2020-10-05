import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray
        
        let photosVC = PhotoCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        
        viewControllers = [
        generateNavigationVC(rootViewController: photosVC, title: "Photos", image: #imageLiteral(resourceName: "photos")),
        generateNavigationVC(rootViewController: ViewController(), title: "Favourites", image: #imageLiteral(resourceName: "heart"))
    ]
}
    
    private func generateNavigationVC(rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        
        let navVC = UINavigationController(rootViewController: rootViewController)
        navVC.tabBarItem.title = title
        navVC.tabBarItem.image = image

        return navVC
    }
    
}
