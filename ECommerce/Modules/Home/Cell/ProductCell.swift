import UIKit
import Kingfisher

protocol ProductCellDelegate: AnyObject {
    func didTapFavoriteButton(in cell: ProductCell)
    func didTapAddToCartButton(in cell: ProductCell)
}

class ProductCell: UICollectionViewCell {
    let appFont = UIFont(name: "Montserrat", size: 14)
    
    // MARK: - UI Components
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray // Placeholder renk
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "star"), for: .normal) // Varsayılan boş yıldız
        button.tintColor = .white
        return button
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.regularNormal
        label.textColor = AppColors.primaryColor
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.regularNormal
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()
    
    private let addToCartButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add to Cart", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = AppColors.primaryColor
        button.layer.cornerRadius = 8
        button.titleLabel?.font = AppFonts.regularLarge
        return button
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .fill
        return stackView
    }()
    
    // MARK: - Properties
    weak var delegate: ProductCellDelegate?
    private var isFavorite: Bool = false
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        // Shadow
        contentView.backgroundColor = .white
        contentView.applyShadow()
        
        // Add StackView
        contentView.addSubview(stackView)
        stackView.pinToSuperviewEdges(insets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        
        // Image Container
        let imageContainerView = UIView()
        imageContainerView.addSubview(productImageView)
        imageContainerView.addSubview(favoriteButton)
        
        productImageView.pinToSuperviewEdges()
        productImageView.setSize(height: 150)
        favoriteButton.pinToTop(of: imageContainerView, offset: 8)
        favoriteButton.pinToTrailing(of: imageContainerView, offset: -8)
        favoriteButton.setSize(width: 24, height: 24)
        
        // Add views to StackView
        stackView.addArrangedSubview(imageContainerView)
        stackView.addArrangedSubview(priceLabel)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(addToCartButton)
        
        // Button Constraints
        addToCartButton.setSize(height: 40)
    }
    
    private func setupActions() {
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        addToCartButton.addTarget(self, action: #selector(addToCartTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func favoriteButtonTapped() {
        isFavorite.toggle() // Favori durumu tersine çevrilir
        let imageName = isFavorite ? "star.fill" : "star"
        let tintColor = isFavorite ? UIColor.systemYellow : UIColor.lightGray
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
        favoriteButton.tintColor = tintColor
        
        // Delegate'e bildirim gönder
        delegate?.didTapFavoriteButton(in: self)
    }
    
    @objc private func addToCartTapped() {
        delegate?.didTapAddToCartButton(in: self)
    }
    
    // MARK: - Configure Cell
    func configure(with product: Product) {
        productImageView.kf.setImage(with: URL(string: product.image ?? ""), placeholder: UIImage(named: "placeholder"))
        productImageView.contentMode = .scaleToFill
        priceLabel.text = product.price
        nameLabel.text = product.name
        isFavorite = product.isFavorite ?? false // Varsayılan favori durumu
        let imageName = isFavorite ? "star.fill" : "star"
        let tintColor = isFavorite ? UIColor.systemYellow : UIColor.lightGray
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
        favoriteButton.tintColor = tintColor
    }
}
