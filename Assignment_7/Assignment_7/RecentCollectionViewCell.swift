
import UIKit
import SnapKit

class RecentCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: RecentCollectionViewCell.self)
    
    let bookImgView = UIImageView()
    let authorLabel = UILabel()
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
        [bookImgView,authorLabel,titleLabel].forEach {
            contentView.addSubview($0)
        }
        
        bookImgView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(5)
            $0.height.equalTo(150)
        }
        
        authorLabel.snp.makeConstraints {
            $0.top.equalTo(bookImgView.snp.bottom).offset(5)
            $0.leading.equalToSuperview().inset(10)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(authorLabel.snp.bottom).offset(5)
            $0.leading.equalToSuperview().inset(10)
        }
        
    }
    
    func configureUI() {
        bookImgView.image = UIImage(systemName: "photo")
        bookImgView.tintColor = .lightGray
        bookImgView.backgroundColor = .white
        bookImgView.layer.cornerRadius = 10
        
        authorLabel.text = "authorLabel"
        authorLabel.font = UIFont.systemFont(ofSize: 12)
        authorLabel.textColor = .lightGray
        titleLabel.text = "titleLabel"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
    }
}
