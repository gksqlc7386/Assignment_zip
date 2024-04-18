
import UIKit
import CoreData

class WishListViewController: UITableViewController {
    //Core Data, AppDelegate에 설정한 저장소에 접근
    var persistentContainer: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        setProductList()
    }
    
    //위시 리스트에 Core Data 상품정보 데이터 저장하기
    var productList:[Product] = []
    
    func setProductList() {
        guard let context = self.persistentContainer?.viewContext else { return }
        
        let request = Product.fetchRequest()
        
        if let productList = try? context.fetch(request) {
            self.productList = productList
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.productList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let product = self.productList[indexPath.row]
        let id = product.id
        let title = product.title ?? ""
        let price = product.price
        
        cell.textLabel?.text = "[\(id)] \(title)     \(price)$"
        return cell
    }
    
    // 테이블뷰 편집 모드에서 셀 삭제 가능 여부 설정
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
        
    // 테이블뷰 편집 모드에서 셀 삭제 기능 구현
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let productToDelete = self.productList[indexPath.row]
            
            // Core Data에서 해당 상품 정보 삭제
            if let context = self.persistentContainer?.viewContext {
                context.delete(productToDelete)
                
                do {
                    try context.save() // 변경 내용 저장
                    self.productList.remove(at: indexPath.row) // 배열에서도 삭제
                    tableView.deleteRows(at: [indexPath], with: .fade) // 테이블뷰에서 삭제
                } catch {
                    print("Error deleting product: \(error)")
                }
            }
        }
    }
    
}
