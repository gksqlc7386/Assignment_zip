import UIKit
import SnapKit

class ViewController: UIViewController {
    
    var documents : [Document] = []
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        return searchBar
    }()

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
        
        //tableView
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(RecentTableViewCell.self, forCellReuseIdentifier: RecentTableViewCell.identifier)
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        
        tableView.separatorStyle = .none

    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource, SelectedCellDelegate {
    //테이블 뷰 설정
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
            return calculateSearchCollectionViewHeight()
        default:
            return 0
        }
    }
    
    func calculateSearchCollectionViewHeight() -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let inset: CGFloat = 20
        let spacing: CGFloat = 10
        let numberOfItemsPerRow: CGFloat = 3
        let itemCount = CGFloat(documents.count)
            
        let itemWidth = (screenWidth - 2 * inset - (numberOfItemsPerRow - 1) * spacing) / numberOfItemsPerRow
        let itemHeight = itemWidth * 200 / 120 // 아이템의 가로:세로 비율을 120:200으로 가정
        
        let numberOfItems = itemCount / 3 + 2 // 셀의 개수 / 행 + 나누어 떨어지지 않을 경우를 대비해서 +1 , Search글씨 부분 + 1 -> 나중에 바뀌면 수정
        let collectionViewHeight = itemHeight * CGFloat(numberOfItems)
        return collectionViewHeight
    }
    
    // documents 배열이 업데이트될 때마다 호출되는 메서드
    func updateTableView() {
        tableView.reloadData()
    }

    // 검색 완료 시 documents 배열을 업데이트하고 테이블 뷰를 갱신하는 메서드
    func updateDocuments(with documents: [Document]) {
        self.documents = documents
        updateTableView()
    }
    
    //셀 선택 시 세부 화면
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

extension ViewController: UISearchBarDelegate {
    //검색 완료 시(Enter 눌렀을 때) 데이터 가져오기
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            NetworkingManager.shared.fetchBookAPI(query: searchText) { result in
                switch result {
                case .success(let book):
                    DispatchQueue.main.async {
                        if let cell = self.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? SearchTableViewCell {
                            cell.documents = book.documents
                            cell.searchCollectionView.reloadData()
                            self.updateDocuments(with: book.documents)
                        }
                    }
                case .failure(let error):
                    print("Error fetching book: \(error)")
                }
            }
        }
        searchBar.resignFirstResponder()
    }
}


