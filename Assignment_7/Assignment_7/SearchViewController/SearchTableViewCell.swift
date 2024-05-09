
import UIKit
import SnapKit

class SearchTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: SearchTableViewCell.self)
    
    weak var delegate: SelectedCellDelegate?
    
    var documents: [Document] = []
    
    let searchLabel = UILabel()
    
    lazy var searchCollectionView = UICollectionView(frame: .zero, collectionViewLayout: searchCollectionViewLayout)
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
        
        [searchLabel, searchCollectionView].forEach {
            contentView.addSubview($0)
        }
        
        //SearchLabel
        searchLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().inset(30)
        }
        
        //SearchCollectionViewController
        searchCollectionView.snp.makeConstraints {
            $0.top.equalTo(searchLabel.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    func configureUI() {
        //searchLabel
        searchLabel.text = "Search"
        searchLabel.font = UIFont.boldSystemFont(ofSize: 23)
        
        //searchCollectionView
        searchCollectionView.dataSource = self
        searchCollectionView.delegate = self
        
        searchCollectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
        
        searchCollectionView.isScrollEnabled = false
        
        // 데이터 변경 후 컬렉션 뷰 리로드
        searchCollectionView.reloadData()
    }

}

extension SearchTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return documents.count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifier, for: indexPath) as! SearchCollectionViewCell
        let document = documents[indexPath.item]
        cell.configureUI(with: document)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.cellDidSelectItem(with: documents[indexPath.item])
    }
}
