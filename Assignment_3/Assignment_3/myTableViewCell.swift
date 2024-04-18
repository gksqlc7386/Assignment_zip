

import UIKit

class myTableViewCell: UITableViewCell {

    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var mySwitch: UISwitch!
    
    var switchOnDelegate: SwitchOnDelegate?
    var orderCellIndex:Int = 0
    
    //스위치 Action 시 취소선
    @IBAction func completeTodo(_ sender: UISwitch) {
        changeStrikeThrough()
    }
    
    func changeStrikeThrough() {
        if mySwitch.isOn {
            myLabel.attributedText = myLabel.text?.strikeThrough()
            switchOnDelegate?.switchChange(index: orderCellIndex, switchIs: true)
        } else {
            switchOnDelegate?.switchChange(index: orderCellIndex, switchIs: false)
            myLabel.attributedText = myLabel.text?.removestrikeThrough()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mySwitch.isOn = false
        myLabel.attributedText = nil
    }
}

//스위치값 저장을 위한 protocol
protocol SwitchOnDelegate {
    func switchChange(index:Int, switchIs: Bool)
}

//취소선
extension String {
    //취소선 생성
    func strikeThrough() -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
    //취소선 지우기
    func removestrikeThrough() -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
}
