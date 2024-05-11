
import UIKit
import SnapKit
import CoreData

class RecentTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: RecentTableViewCell.self)
    
    weak var delegate: CellConnectDelegate?
    
    var documents:[Document] = []
    
    var recentData: [NSManagedObject] = []
    
    let recentView = UIView()
    let recentLabel = UILabel()
    let recentDeleteButton = UIButton()
    lazy var RecentCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
    let collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.itemSize = .init(width: 120, height: 200)
        return layout
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupConstraints()
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints(){
        
        contentView.addSubview(recentView)
        
        [recentLabel,recentDeleteButton,RecentCollectionView].forEach {
            recentView.addSubview($0)
        }
        
        // 최근 본 책 (recentView)
        recentView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().inset(30)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(300)
        }
        
        recentLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(20)
        }
        
        recentDeleteButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        RecentCollectionView.snp.makeConstraints {
            $0.top.equalTo(recentLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(200)
        }
        
    }
    
    func configureUI() {
        //recentView
        recentView.backgroundColor = .white
    
        recentView.layer.shadowOffset = CGSize(width: 10, height: 10) // 그림자의 위치
        recentView.layer.shadowOpacity = 0.5 // 그림자의 투명도
        recentView.layer.shadowRadius = 10
        recentView.layer.shadowColor = UIColor.black.cgColor // 그림자의 색상
        recentView.layer.masksToBounds = false
  
        recentView.layer.cornerRadius = 20
        recentView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMinXMaxYCorner)
        
        //recentLabel
        recentLabel.text = "Recent"
        recentLabel.font = UIFont.boldSystemFont(ofSize: 23)
        
        //recentDeleteButton
        recentDeleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        recentDeleteButton.tintColor = .lightGray
        recentDeleteButton.addTarget(self, action: #selector(trashButtonTapped), for: .touchUpInside)
        
        //RecentCollectionView
        RecentCollectionView.dataSource = self
        RecentCollectionView.delegate = self
                
        RecentCollectionView.register(RecentCollectionViewCell.self, forCellWithReuseIdentifier: RecentCollectionViewCell.identifier)
    }
    
    //전체 삭제
    @objc func trashButtonTapped(_ sender : UIButton) {
        delegate?.trashButtonTapped()
    }
}

extension RecentTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recentData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentCollectionViewCell.identifier, for: indexPath) as! RecentCollectionViewCell
        let data = recentData[indexPath.item]
        cell.configureUI(with: data)
        return cell
    }
    
    //선택 시 세부화면으로 이동
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.cellDidSelectItem(with: documents[indexPath.item])
    }
}
