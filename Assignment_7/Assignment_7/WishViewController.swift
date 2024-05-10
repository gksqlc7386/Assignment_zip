import UIKit
import CoreData
import SnapKit

class WishViewController: UIViewController {
    
    let pageTitleLabel = UILabel()
    let deleteButton = UIButton()
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConstraints()
        configureUI()
    }
    
    func setupConstraints() {
        [pageTitleLabel, deleteButton, tableView].forEach {
            view.addSubview($0)
        }
        
        pageTitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(15)
            $0.centerX.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(15)
            $0.trailing.equalToSuperview().inset(30)
        }
        
        tableView.snp.makeConstraints{
            $0.top.equalTo(pageTitleLabel.snp.bottom).offset(30)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        pageTitleLabel.text = "Wish List"
        pageTitleLabel.font = UIFont.boldSystemFont(ofSize: 23)
        
        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        deleteButton.tintColor = .systemRed
        deleteButton.addTarget(self, action: #selector(trashButtonTapped), for: .touchUpInside)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(WishTableViewCell.self, forCellReuseIdentifier: WishTableViewCell.identifier)
    }
    
    //전체 삭제
    @objc func trashButtonTapped(_ sender : UIButton) {
        let alert = UIAlertController(title: "도서 전체 삭제", message: "정말 모든 도서를 삭제하시겠습니까?", preferredStyle: .alert)
        // 확인 버튼
        let confirmAction = UIAlertAction(title: "확인", style: .destructive) { _ in
            CoreDataManager.shared.deleteAllWishes()
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

extension WishViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CoreDataManager.shared.fetchWishItems().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WishTableViewCell.identifier, for: indexPath) as! WishTableViewCell
        
        let wishes = CoreDataManager.shared.fetchWishItems()
        let wish = wishes[indexPath.row]
        cell.configureUI(with: wish)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let wishes = CoreDataManager.shared.fetchWishItems()
            let wish = wishes[indexPath.row]
            CoreDataManager.shared.deleteWish(wish: wish)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
