import UIKit
import SDWebImage

class PhotosCell: UICollectionViewCell {
    
    static let reuseId = "PhotosCell"
    
    private let checjmark: UIImageView = {
       let image = UIImage(named: "bird1")
       let imageView = UIImageView(image: image)
       imageView.translatesAutoresizingMaskIntoConstraints = false
       imageView.alpha = 0
       return imageView
    }()
    
       let photoImageView: UIImageView = {
       let imageView = UIImageView()
       imageView.translatesAutoresizingMaskIntoConstraints = false
       imageView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
       imageView.contentMode = .scaleAspectFill
       return imageView
    }()
    
    var unsplashPhoto: UnsplashPhoto! {
        didSet {
            let photo = unsplashPhoto.urls["regular"]
            guard let imageURL = photo , let url = URL(string: imageURL) else {return}
            photoImageView.sd_setImage(with: url, completed: nil)
        }
    }
    
    override var isSelected: Bool {
        didSet{
            updateSelectedState()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateSelectedState()
        setupPhotoImageView()
        setupCheackmarView()
    }
    
    private func updateSelectedState() {
        photoImageView.alpha = isSelected ? 0.7 : 1
        checjmark.alpha = isSelected ? 1 : 0
    }
    
    private func setupPhotoImageView() {
        
        addSubview(photoImageView)
        
        photoImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        photoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        photoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        photoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    }
    
    private func setupCheackmarView() {
        
        addSubview(checjmark)
        
        checjmark.trailingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: -8).isActive = true
        checjmark.bottomAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: -8).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
