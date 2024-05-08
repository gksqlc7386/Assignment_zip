
import UIKit
import SnapKit

class WishTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: WishTableViewCell.self)
    
    let titleLabel = UILabel()
    let authorLabel = UILabel()
    let priceLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
        configureUI()
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
        }
        
        authorLabel.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalTo(priceLabel.snp.leading).inset(20)
            $0.bottom.equalToSuperview().inset(20)
        }
        
        priceLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(20)
            
        }
    }
    
    func configureUI() {
        titleLabel.text = "책 이름"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 23)
        
        authorLabel.text = "작가 이름"
        authorLabel.font = UIFont.systemFont(ofSize: 16)
        
        priceLabel.text = "14000원"
        priceLabel.font = UIFont.boldSystemFont(ofSize: 20)
    }

}
