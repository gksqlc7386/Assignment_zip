
import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SwitchOnDelegate {
    
    //데이터 구조체 생성
    struct Todo {
        var id:Int
        var title:String
        var isCompleted:Bool
    }
    
    var titles:[Todo] = [
        Todo(id: 1, title: "title1", isCompleted: false),
        Todo(id: 1, title: "title2", isCompleted: false),
        Todo(id: 1, title: "title3", isCompleted: false)
    ]

    //tableView 구성
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addButton: UIButton!
    
    // 스위치 상태 저장
    func switchChange(index: Int, switchIs: Bool) {
        titles[index].isCompleted = switchIs
    }
    
    //추가하기 버튼 alert 기능
    @IBAction func alertTodo(_ sender: Any) {
        let title = "할 일 추가"
        let message = ""
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let add = UIAlertAction(title: "추가", style: .default) {_ in 
            //추가를 눌렀을 때 일어나는 내용
            if let TodoTitle = alert.textFields?[0] {
                if TodoTitle.text?.isEmpty != true {
                    self.titles.append(Todo(id: 1, title: TodoTitle.text!, isCompleted: false))
                    self.tableView.insertRows(at: [IndexPath(row: self.titles.count-1, section: 0)], with: .bottom )
                } else {
                    print("입력된 값이 없습니다.")
                }
            }
        }
        alert.addAction(cancel)
        alert.addAction(add)
        
        self.present(alert, animated: true)
        
        //텍스트 필드 추가
        alert.addTextField() { (textfd) in
            textfd.placeholder = "할 일을 입력하세요"
        }
    }
    
    //테이블뷰 관련 함수들
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! myTableViewCell
            let target = titles[indexPath.row]
        
            cell.mySwitch.isOn = target.isCompleted
            cell.myLabel.text = target.title
            
            cell.orderCellIndex = indexPath.row
            cell.switchOnDelegate = self
        
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //삭제 기능
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            titles.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        //추가하기 버튼
        addButton.setTitle("추가하기", for: .normal)
    }
}
