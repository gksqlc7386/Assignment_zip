import UIKit
import SnapKit

class ViewController: UIViewController {
    
    let searchBar = UISearchBar()
    
    let recentView = UIView()
    let recentLabel = UILabel()
    lazy var RecentCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
    let collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.itemSize = .init(width: 120, height: 200)
        return layout
    }()
    
    let SearchLabel = UILabel()
    
    lazy var SearchCollectionView = UICollectionView(frame: .zero, collectionViewLayout: searchCollectionViewLayout)
    let searchCollectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.itemSize = .init(width: 120, height: 200)
        return layout
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConstraints()
        configureUI()
    }
    
    func setupConstraints() {
        
        [searchBar, recentView, SearchLabel, SearchCollectionView].forEach {
            view.addSubview($0)
        }
        
        [recentLabel,RecentCollectionView].forEach {
            recentView.addSubview($0)
        }
        
        //searchBar
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            $0.horizontalEdges.equalToSuperview().inset(10)
        }
        
        // 최근 본 책 (recentView)
        recentView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(30)
            $0.leading.equalToSuperview().inset(30)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(300)
        }
        
        recentLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(20)
        }
        
        RecentCollectionView.snp.makeConstraints {
            $0.top.equalTo(recentLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(200)
        }
        
        //SearchLabel
        SearchLabel.snp.makeConstraints {
            $0.top.equalTo(recentView.snp.bottom).offset(50)
            $0.leading.equalToSuperview().inset(30)
        }
        
        //SearchCollectionViewController
        SearchCollectionView.snp.makeConstraints {
            $0.top.equalTo(SearchLabel.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        //searchBar
        searchBar.searchBarStyle = .minimal // 배경 투명하게
        searchBar.backgroundImage = UIImage() // 선 제거
        
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
        
        //RecentCollectionView
        RecentCollectionView.dataSource = self
        RecentCollectionView.delegate = self
                
        RecentCollectionView.register(RecentCollectionViewCell.self, forCellWithReuseIdentifier: RecentCollectionViewCell.identifier)
        RecentCollectionView.backgroundColor = .yellow
        
        //SearchLabel
        SearchLabel.text = "Search"
        SearchLabel.font = UIFont.boldSystemFont(ofSize: 23)
        
        //SearchCollectionView
        SearchCollectionView.dataSource = self
        SearchCollectionView.delegate = self
        
        SearchCollectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
        SearchCollectionView.backgroundColor = .green
    }
}

extension ViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == RecentCollectionView {
            return 10
        } else if collectionView == SearchCollectionView {
            return 20
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == RecentCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentCollectionViewCell.identifier, for: indexPath) as! RecentCollectionViewCell
            cell.backgroundColor = UIColor.blue
            return cell
        } else if collectionView == SearchCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifier, for: indexPath) as! SearchCollectionViewCell
            cell.backgroundColor = UIColor.red
            return cell
        }
        return UICollectionViewCell()
    }
    
}
