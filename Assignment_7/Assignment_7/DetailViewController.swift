
import UIKit
import SnapKit
import CoreData

class DetailViewController: UIViewController {
    
    var selectedDocument: Document?
    
    let backButton = UIButton()
    let detailView = UIView()
    let bookImgView = UIImageView()
    let authorLabel = UILabel()
    let titleLabel = UILabel()
    let summaryLabel = UILabel()
    let wishButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConstraints()
        configureUI()
    }
    
    func setupConstraints(){
        
        [detailView, backButton, bookImgView].forEach {
            view.addSubview($0)
        }
        
        [authorLabel, titleLabel, summaryLabel, wishButton].forEach {
            detailView.addSubview($0)
        }
        
        backButton.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.equalToSuperview().inset(20)
        }
        
        detailView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(300)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        bookImgView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(150)
            $0.horizontalEdges.equalToSuperview().inset(100)
            $0.height.equalTo(300)
        }
        
        authorLabel.snp.makeConstraints{
            $0.top.equalTo(bookImgView.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(authorLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        summaryLabel.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        wishButton.snp.makeConstraints{
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(50)
            $0.height.equalTo(50)
        }
        
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        //backButton
        backButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        backButton.tintColor = .gray
        
        backButton.addTarget(self, action: #selector(xButtonTapped), for: .touchUpInside)
        
        //detailView
        detailView.backgroundColor = .white
        
        detailView.layer.shadowOffset = CGSize(width: -5, height: 0) // 그림자의 위치
        detailView.layer.shadowOpacity = 0.3 // 그림자의 투명도
        detailView.layer.shadowRadius = 10
        detailView.layer.shadowColor = UIColor.black.cgColor // 그림자의 색상
        detailView.layer.masksToBounds = false
        detailView.layer.cornerRadius = 35
        
        //bookImgView
        bookImgView.layer.cornerRadius = 20
        if let imageURL = URL(string: selectedDocument!.thumbnail) {
            DispatchQueue.global().async { [weak self] in
                if let imageData = try? Data(contentsOf: imageURL) {
                    DispatchQueue.main.async {
                        self?.bookImgView.image = UIImage(data: imageData)
                    }
                }
            }
        }
        
        //authorLabel
        authorLabel.text = selectedDocument?.authors[0]
        authorLabel.textColor = .lightGray
        
        //titleLabel
        titleLabel.text = selectedDocument?.title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 23)
        titleLabel.textAlignment = .center
        
        //summaryLabel
        summaryLabel.text = selectedDocument?.contents
        summaryLabel.numberOfLines = 6
        
        //wishButton
        wishButton.setTitle("\(selectedDocument!.price)원 / 담기", for: .normal)
        wishButton.backgroundColor = .black
        wishButton.setTitleColor(UIColor.white, for: .normal)
        wishButton.layer.cornerRadius = 10
        
        wishButton.addTarget(self, action: #selector(wishButtonTapped), for: .touchUpInside)
    }
    
    @objc func xButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func wishButtonTapped(_ sender: UIButton) {
        CoreDataManager.shared.saveBook(title: titleLabel.text!, author:authorLabel.text!, price: Int64(selectedDocument!.price))
    }
}
