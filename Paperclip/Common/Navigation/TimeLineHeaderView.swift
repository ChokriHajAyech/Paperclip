
import UIKit

class TimeLineHeaderView: UITableViewHeaderFooterView {
    
     let title : UILabel = {
         let lbl = UILabel()
         lbl.textColor = .black
         lbl.font = UIFont.boldSystemFont(ofSize: 16)
         lbl.textAlignment = .left
         lbl.numberOfLines = 2
         lbl.lineBreakMode = .byTruncatingTail
         return lbl
     }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureContents() {
        title.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(title)
        
        // Center the image vertically and place it near the leading
        // edge of the view. Constrain its width and height to 50 points.
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            title.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor)
        ])
    }
}

