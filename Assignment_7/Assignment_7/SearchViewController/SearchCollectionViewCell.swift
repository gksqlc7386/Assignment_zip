
import UIKit
import SnapKit

class SearchCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: SearchCollectionViewCell.self)
    
    let bookImgView = UIImageView()
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupConstraints()
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
            $0.trailing.equalToSuperview().inset(10)
        }
        
    }
    
    func configureUI(with document: Document) {

        if let imageURL = URL(string: document.thumbnail) {
            DispatchQueue.global().async { [weak self] in
                if let imageData = try? Data(contentsOf: imageURL) {
                    DispatchQueue.main.async {
                        self?.bookImgView.image = UIImage(data: imageData)
                    }
                }
            }
        }
        bookImgView.layer.cornerRadius = 10 // 이거 왜 안먹음 ...
        
        titleLabel.text = document.title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 12)
    }
}
