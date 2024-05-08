import UIKit
import SnapKit

class ViewController: UIViewController {
    
    let searchBar = UISearchBar()
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConstraints()
        configureUI()
    }
    
    func setupConstraints() {
        
        [searchBar, tableView].forEach {
            view.addSubview($0)
        }
        
        //searchBar
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        //tableView
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        //searchBar
        searchBar.searchBarStyle = .minimal // 배경 투명하게
        searchBar.backgroundImage = UIImage() // 선 제거
        
        //tableView
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(RecentTableViewCell.self, forCellReuseIdentifier: RecentTableViewCell.identifier)
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        
        tableView.separatorStyle = .none

    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource ,SelectedCellDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RecentTableViewCell.identifier, for: indexPath) as? RecentTableViewCell else { return .init() }
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as? SearchTableViewCell else { return .init() }
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 350
        case 1:
            let searchCollectionViewHeight = calculateSearchCollectionViewHeight()
            return searchCollectionViewHeight
        default:
            return 0
        }
    }
    
    func calculateSearchCollectionViewHeight() -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let inset: CGFloat = 20
        let spacing: CGFloat = 10
        let numberOfItemsPerRow: CGFloat = 3
            
        let itemWidth = (screenWidth - 2 * inset - (numberOfItemsPerRow - 1) * spacing) / numberOfItemsPerRow
        let itemHeight = itemWidth * 200 / 120 // 아이템의 가로:세로 비율을 120:200으로 가정
        
        let numberOfItems = 20 / 3 + 2 // 셀의 개수 / 행 + 나누어 떨어지지 않을 경우를 대비해서 +1 , Search글씨 부분 + 1 -> 나중에 바뀌면 수정
        let collectionViewHeight = itemHeight * CGFloat(numberOfItems)
        return collectionViewHeight
    }
    
    func cellDidSelectItem() {
        let detailVC = DetailViewController()
        detailVC.modalPresentationStyle = .fullScreen
        self.present(detailVC, animated: true)
    }
}

//셀 선택 시
protocol SelectedCellDelegate: AnyObject {
    func cellDidSelectItem()
}


