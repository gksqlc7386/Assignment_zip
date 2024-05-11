import UIKit
import CoreData
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

extension ViewController: UITableViewDelegate, UITableViewDataSource, CellConnectDelegate {
    
    //테이블 뷰 설정
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RecentTableViewCell.identifier, for: indexPath) as? RecentTableViewCell else { return .init() }
            cell.recentData = CoreDataManager.shared.fetchRecentItems()
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

    // 검색 완료 시 documents 배열을 업데이트하고 테이블 뷰를 갱신
    func updateDocuments(with documents: [Document]) {
        self.documents = documents
        tableView.reloadData()
    }
    
    //셀 선택 시 세부 화면
    func cellDidSelectItem(with document: Document) {
        let detailVC = DetailViewController()
        detailVC.modalPresentationStyle = .fullScreen
        detailVC.selectedDocument = document
        
        // 선택 시 RecentData에 저장
        CoreDataManager.shared.saveRecentBook(title: document.title, author: document.authors[0], thumbnail: document.thumbnail)
        if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? RecentTableViewCell {
            cell.RecentCollectionView.reloadData()
        }
        self.tableView.reloadData()
        
        self.present(detailVC, animated: true)
    }
    
    //RecentTableViewCell에서 휴지통 클릭 시 실행될 메소드
    func trashButtonTapped() {
        let alert = UIAlertController(title: "최근 본 책 삭제", message: "최근 본 책 내역을 모두 삭제하시겠습니까?", preferredStyle: .alert)
        // 확인 버튼
        let confirmAction = UIAlertAction(title: "확인", style: .destructive) { _ in
            CoreDataManager.shared.deleteAllRecentBooks()
            if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? RecentTableViewCell {
                cell.RecentCollectionView.reloadData()
            }
            self.tableView.reloadData()
        }
        alert.addAction(confirmAction)
        
        // 취소 버튼
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        // 알림창 표시
        present(alert, animated: true, completion: nil)
    }
}

protocol CellConnectDelegate: AnyObject {
    //셀 선택 시 세부화면으로 가기 위한 함수
    func cellDidSelectItem(with document: Document)
    
    //RecentTableView에서 삭제 버튼 클릭 시 alert창을 띄우기 위한 메서드
    func trashButtonTapped()
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
        searchBar.resignFirstResponder() //서치바 키보드 닫기
    }
}
