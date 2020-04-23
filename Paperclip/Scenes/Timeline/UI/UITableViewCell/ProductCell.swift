
import UIKit

class ProductCell: UITableViewCell {
    
    // MARK: UI Properties
    
    private let productTitleLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .left
        lbl.numberOfLines = 2
        lbl.lineBreakMode = .byTruncatingTail
        return lbl
    }()
    
    private let productPriceLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let productImage : WebImageView = {
        let imgView = WebImageView(image: #imageLiteral(resourceName: "default_thumb"))
        imgView.backgroundColor = .lightGray
        imgView.backgroundColor?.withAlphaComponent(0.2)
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        return imgView
    }()
    
    private let productIndicatorStatus : UIImageView = {
        let imgView = UIImageView(image: #imageLiteral(resourceName: "indicator"))
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        return imgView
    }()
    
    // MARK: Object lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func configureContents() {
        
        addSubview(productImage)
        
        addSubview(productTitleLabel)
        addSubview(productPriceLabel)
        addSubview(productIndicatorStatus)
        
        productImage.anchor(top: layoutMarginsGuide.topAnchor, left: layoutMarginsGuide.leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 10, paddingLeft: 0, paddingBottom: 10, paddingRight: 0, width: 90, height: 90, enableInsets: false)
        
        
        productTitleLabel.anchor(top: layoutMarginsGuide.topAnchor, left: productImage.layoutMarginsGuide.rightAnchor, bottom: nil, right: layoutMarginsGuide.rightAnchor, paddingTop: 25, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        
        productPriceLabel.anchor(top: productTitleLabel.layoutMarginsGuide.bottomAnchor, left:
            productImage.layoutMarginsGuide.rightAnchor, bottom: nil, right: layoutMarginsGuide.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0 , height: 0, enableInsets: false)
        
        productIndicatorStatus.anchor(top: topAnchor, left: nil, bottom: nil, right: layoutMarginsGuide.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
    }
    
    func bind(_ listing: TimelineModels.FetchFromListProducts.ViewModel.Listing?) {
        
        if let listingTitle = listing?.listingTitle {
            productTitleLabel.text = listingTitle
        } else {
            productTitleLabel.text = ""
        }
        
        if let listingPrice = listing?.listingPrice {
            productPriceLabel.text = listingPrice + " €"
        } else {
            productPriceLabel.text = ""
        }
        
        productIndicatorStatus.isHidden = !(listing?.isUrgent ?? false)
        
        if let tumbUrl = listing?.thumbUrl {
            productImage.loadImage(url: tumbUrl)
        } else if let smallUrl = listing?.smallUrl {
            productImage.loadImage(url: smallUrl)
        } else {
            productImage.image = UIImage(named: "default_thumb")
        }
    }
}
