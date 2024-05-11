
import UIKit
import SnapKit
import CoreData

class RecentCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: RecentCollectionViewCell.self)
    
    let bookImgView = UIImageView()
    let authorLabel = UILabel()
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupConstraints()
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
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(authorLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        
    }
    
    func configureUI(with recentData: NSManagedObject) {
        if let thumbnail = recentData.value(forKeyPath: "thumbnail") as? String {
            if let imageURL = URL(string: thumbnail) {
                DispatchQueue.global().async { [weak self] in
                    if let imageData = try? Data(contentsOf: imageURL) {
                        DispatchQueue.main.async {
                            self?.bookImgView.image = UIImage(data: imageData)
                        }
                    }
                }
            }
        }
        bookImgView.layer.cornerRadius = 10
        bookImgView.tintColor = .lightGray
        bookImgView.backgroundColor = .white
        bookImgView.layer.cornerRadius = 10
        
        authorLabel.text = recentData.value(forKeyPath: "author") as? String
        authorLabel.font = UIFont.systemFont(ofSize: 12)
        authorLabel.textColor = .lightGray
        
        titleLabel.text = recentData.value(forKeyPath: "title") as? String
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
    }
}
