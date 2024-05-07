
import UIKit
import SnapKit

class SearchCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: SearchCollectionViewCell.self)
    
    let bookImgView = UIImageView()
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupConstraints()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        [bookImgView,titleLabel].forEach {
            contentView.addSubview($0)
        }
        
        bookImgView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(5)
            $0.height.equalTo(150)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(bookImgView.snp.bottom).offset(5)
            $0.leading.equalToSuperview().inset(10)
        }
        
    }
    
    func configureUI() {
        bookImgView.image = UIImage(systemName: "photo")
        bookImgView.tintColor = .lightGray
        bookImgView.backgroundColor = .white
        bookImgView.layer.cornerRadius = 10
        
        titleLabel.text = "titleLabel"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
    }
}
