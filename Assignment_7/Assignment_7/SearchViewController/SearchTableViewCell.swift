
import UIKit
import SnapKit

class SearchTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: SearchTableViewCell.self)
    
    weak var delegate: SelectedCellDelegate?
    
    let SearchLabel = UILabel()
    
    lazy var SearchCollectionView = UICollectionView(frame: .zero, collectionViewLayout: searchCollectionViewLayout)
    let searchCollectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.sectionInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        
        let screenWidth = UIScreen.main.bounds.width
        let inset: CGFloat = 20
        let spacing: CGFloat = 10
        let numberOfItemsPerRow: CGFloat = 3
            
        let itemWidth = (screenWidth - 2 * inset - (numberOfItemsPerRow - 1) * spacing) / numberOfItemsPerRow
        let itemHeight = itemWidth * 200 / 120 // 아이템의 가로:세로 비율을 120:200으로 가정
            
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
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
    
    func setupConstraints() {
        
        [SearchLabel, SearchCollectionView].forEach {
            contentView.addSubview($0)
        }
        
        //SearchLabel
        SearchLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().inset(30)
        }
        
        //SearchCollectionViewController
        SearchCollectionView.snp.makeConstraints {
            $0.top.equalTo(SearchLabel.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func configureUI() {
        //SearchLabel
        SearchLabel.text = "Search"
        SearchLabel.font = UIFont.boldSystemFont(ofSize: 23)
        
        //SearchCollectionView
        SearchCollectionView.dataSource = self
        SearchCollectionView.delegate = self
        
        SearchCollectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
        
        SearchCollectionView.isScrollEnabled = false
    }

}

extension SearchTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifier, for: indexPath) as! SearchCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.cellDidSelectItem()
    }
}
