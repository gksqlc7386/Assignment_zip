
import UIKit
import SnapKit
import CoreData

class WishTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: WishTableViewCell.self)
    
    let titleLabel = UILabel()
    let authorLabel = UILabel()
    let priceLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        
        [titleLabel, authorLabel, priceLabel].forEach {
            contentView.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(80)
        }
        
        authorLabel.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(20)
        }
        
        priceLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.leading.equalTo(authorLabel.snp.trailing).offset(50)
        }
    }
    
    func configureUI(with wish: NSManagedObject) {
        titleLabel.text = wish.value(forKey: "title") as? String ?? ""
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.numberOfLines = 2
        
        authorLabel.text = wish.value(forKey: "author") as? String ?? ""
        authorLabel.font = UIFont.systemFont(ofSize: 16)
        
        priceLabel.text = "\(wish.value(forKey: "price") as? Int64 ?? 0)원"
        priceLabel.font = UIFont.boldSystemFont(ofSize: 18)
    }

}
