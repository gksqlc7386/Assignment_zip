import UIKit
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
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(WishTableViewCell.self, forCellReuseIdentifier: WishTableViewCell.identifier)
    }

}

extension WishViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WishTableViewCell.identifier, for: indexPath) as! WishTableViewCell
        return cell
    }
    
    //셀 삭제
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }
}
