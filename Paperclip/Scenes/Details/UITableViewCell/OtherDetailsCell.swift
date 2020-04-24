
import UIKit
import Foundation

class OtherDetailsCell: UITableViewCell {
    
    // MARK: UI Properties
    static let cellId = "DetailsProductCell"

    let productDescriptionLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()
    
    let productSiretLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .left
        return lbl
    }()
    
    let productCeationDateLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .left
        return lbl
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

        addSubview(productDescriptionLabel)
        addSubview(productSiretLabel)
        addSubview(productCeationDateLabel)

        productDescriptionLabel.anchor(top: layoutMarginsGuide.topAnchor, left: layoutMarginsGuide.leftAnchor, bottom: productCeationDateLabel.topAnchor, right:  layoutMarginsGuide.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 10, paddingRight: 0, width: 0, height: 0, enableInsets: false)


        productCeationDateLabel.anchor(top: productDescriptionLabel.layoutMarginsGuide.bottomAnchor, left: layoutMarginsGuide.leftAnchor, bottom: productSiretLabel.topAnchor, right: layoutMarginsGuide.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 10, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        
         productSiretLabel.anchor(top: productCeationDateLabel.layoutMarginsGuide.bottomAnchor, left: layoutMarginsGuide.leftAnchor, bottom: bottomAnchor, right: layoutMarginsGuide.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
    }

    
    func bind(_ listing: listingDetailsProtocol?) {
        
        if let listingDescription = listing?.listingDescription {
            productDescriptionLabel.text = listingDescription
        } else {
            productDescriptionLabel.text = ""
        }
        
        if let listingSiret  = listing?.listingSiret {
            productSiretLabel.text = "Siret: " + listingSiret
        } else {
            productSiretLabel.text = ""
        }
        
        if let listingCreationDate  = listing?.listingCreationDate {
            productCeationDateLabel.text = "Crée le: " + listingCreationDate
        } else {
            productCeationDateLabel.text = ""
        }
    }
}

