import UIKit

class PhotoCollectionViewController: UICollectionViewController {
    
    private lazy var addBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonTapped))
    }()
    
    private lazy var actionBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionBarButtonTapped))
    }()
    
    var networkDataFetcher = NetworkDataFetching()
    private var timer: Timer?
    private var photos = [UnsplashPhoto]()
    private let itemsPerRow: CGFloat = 2
    private let sectionInserts = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    private var selectedImages = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        setupSearchBar()
        setupCollectionView()
        setupNavBar()
        
    }
    
    // MARK: - Setup UI Elements
    
    private func setupCollectionView() {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CellId")
        collectionView.register(PhotosCell.self, forCellWithReuseIdentifier: PhotosCell.reuseId)
        
        collectionView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.contentInsetAdjustmentBehavior = .automatic
        
        collectionView.allowsMultipleSelection = true
    }
    
    private func setupNavBar() {
        let titleLabel = UILabel()
        titleLabel.text = "PHOTOS"
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        titleLabel.textColor = #colorLiteral(red: 0.5019607843, green: 0.4980392157, blue: 0.4980392157, alpha: 1)
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)
        
        navigationItem.rightBarButtonItems = [actionBarButtonItem, addBarButtonItem]
        
    }
    
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        definesPresentationContext = true
    }
    
    // MARK: - Navigation items action
    
    @objc private func addBarButtonTapped() { }
    
    @objc private func actionBarButtonTapped(sender: UIBarButtonItem) {
        
        let shareController = UIActivityViewController(activityItems: selectedImages, applicationActivities: nil)
        
        shareController.completionWithItemsHandler = {_,bool,_,_  in
            if bool {
                
            }
        }
        
        shareController.popoverPresentationController?.barButtonItem = sender
        shareController.popoverPresentationController?.permittedArrowDirections = .any
        
        present(shareController,animated: true,completion: nil)
    }
    
    // MARK: - UICollectionViewDataSource, UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCell.reuseId, for: indexPath) as! PhotosCell
       
       let unsplashPhoto = photos[indexPath.row]
      
       cell.unsplashPhoto = unsplashPhoto
        
       return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! PhotosCell
        
        guard let image = cell.photoImageView.image else {return}
        
        selectedImages.append(image)
    
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    
        let cell = collectionView.cellForItem(at: indexPath) as! PhotosCell
        
        guard let image = cell.photoImageView.image else {return}
        
        if let index = selectedImages.firstIndex(of: image){
            selectedImages.remove(at: index)
        }

    }
}


// MARK: - UISearchBarDelegate

extension PhotoCollectionViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] (_) in
            
           guard let self = self else { return }
           self.networkDataFetcher.fetchImages(searchTerms: searchText) { (searchResults) in
        
            guard let fetchPhotos = searchResults else {return}
            
            self.photos = fetchPhotos.results
            
            self.collectionView.reloadData()
            }
        })
        
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PhotoCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let photo = photos[indexPath.item]
        let paddingSpace = sectionInserts.left * (itemsPerRow + 1)
        let aviableWidth = view.frame.width - paddingSpace
        let widthPerItem = aviableWidth / itemsPerRow
        let height = CGFloat(photo.height) * widthPerItem / CGFloat(photo.width)
        return CGSize(width: widthPerItem, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInserts
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left
    }
}
