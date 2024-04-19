

import UIKit
import CoreData

class ViewController: UIViewController {
    //Core Data, AppDelegate에 설정한 저장소에 접근
    var persistentContainer: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchProduct()
        
        //당겨서 새로고침
        setupRefreshControl()
    }
    
    //당겨서 새로고침 기능
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        return refreshControl
    }()

    @objc private func refreshData(_ sender: Any) {
        fetchProduct()
    }
    
    private func setupRefreshControl() {
        // 현재 ViewController의 view에 있는 scrollView 가져오기
        if let scrollView = self.view as? UIScrollView {
            scrollView.refreshControl = refreshControl
        }
    }
    
    //다른 상품 보기
    @IBAction func tappedNextButton(_ sender: Any) {
        self.fetchProduct()
    }
    
    //위시 담기
    @IBAction func tappedAddWishButton(_ sender: Any) {
        self.addWishList()
    }
    
    //버튼 클릭 시 WishListViewController로 화면 전환
    @IBAction func tappedWishListButton(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "WishListViewController") as? WishListViewController else { return }
        self.present(nextVC, animated: true)
    }
    
    //currentProduct가 set되면 각각에 적절한 값 지정
    var currentProduct : RemoteProduct? = nil {
        didSet {
            guard let currentProduct = self.currentProduct else { return }
            
            DispatchQueue.main.async {
                self.imageView.image = nil
                self.nameLabel.text = currentProduct.title
                self.priceLabel.text = "\(currentProduct.price)$"
                self.descriptionLabel.text = currentProduct.description
                self.refreshControl.endRefreshing() // 새로고침 종료
            }
            
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: currentProduct.thumbnail), let image = UIImage(data: data) {
                    DispatchQueue.main.async {self?.imageView.image = image}
                }
            }
        }
    }
    
    //URLSession을 통해 데이터 가져와서 저장하기
    func fetchProduct() {
        //가져올 데이터 랜덤으로
        let productID = Int.random(in: 1...100)
        
        //데이터 가져오기
        if let url = URL(string: "https://dummyjson.com/product/\(productID)") {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error ) in
                if let error = error {
                    print("Error: \(error)")
                } else if let data = data {
                    do {
                        //product 디코드
                        let product = try JSONDecoder().decode(RemoteProduct.self, from: data)
                        self.currentProduct = product
                    } catch {
                        print("Decode Error : \(error)")
                    }
                }
            }
            task.resume()
        }
    }
    
    //(currentProduct 내용) 위시리스트 담기 함수
    func addWishList() {
        guard let context = self.persistentContainer?.viewContext else { return }
        
        guard let currentProduct = self.currentProduct else { return }
        //Core Data
        let wishProduct = Product(context: context)
        
        wishProduct.id = Int64(currentProduct.id)
        wishProduct.title = currentProduct.title
        wishProduct.price = currentProduct.price
        
        try? context.save()
    }
}

