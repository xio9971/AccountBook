//
//  ViewController.swift
//  AccountBook
//
//  Created by James Kim on 8/5/20.
//  Copyright © 2020 FastCampus. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var lastMonth: UIButton!
    @IBOutlet weak var nextMonth: UIButton!
    @IBOutlet weak var selectedDate: UIButton!
    @IBOutlet weak var listTableview: UITableView!
    @IBOutlet weak var filed_budget: UITextField! { didSet {filed_budget.delegate = self}}
    @IBOutlet weak var amountInfo: UILabel!
    @IBOutlet weak var warning: UILabel!
    @IBOutlet weak var inputViewBottom: NSLayoutConstraint!
    
    var year : Int = 0
    var month : Int = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        let df = DateFormatter()
//        df.dateFormat = "yyyy-MM-dd"
//        let date = df.date(from: "\(year)-\(month)-01")!
        DataManager.shared.fetchData(year: String(year), month: String(month))
        listTableview.reloadData()
        
        setAmountInfo()
    }
    
    /**
     1. 예산 / 지출금액 셋팅
     2. 예산의 80% 이상 지출시 제일 많이 지츨한 분류를 찾아 경고메세지 출력
     */
    func setAmountInfo() {
    
        // 예산
        var budget: Int = 0;
        // 지출
        var totalOutlay: Int = 0;
        // str : 예산/ 지출
        var str: String = ""
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        // 예산 설정이 되있을 경우 예산 셋팅
        if(DataManager.shared.budgetInfo.count > 0) {
            budget = Int(DataManager.shared.budgetInfo[0].boudget)
            str += numberFormatter.string(from: NSNumber(value: budget))!
            //str += String(DataManager.shared.budgetInfo[0].boudget)
        }else {
            str += "0"
        }
    
        
        var categoryAmountArray = [(name: "대중교통", amount: 0), (name: "식사", amount: 0), (name: "보험", amount: 0), (name: "술자리", amount: 0), (name: "물건구입", amount: 0), (name: "커피", amount: 0), (name: "기타", amount: 0)]
        
        for idx in 0..<DataManager.shared.dataList.count {
            totalOutlay += Int(DataManager.shared.dataList[idx].amount)
            
            switch DataManager.shared.dataList[idx].category{
            case "대중교통":
                categoryAmountArray[0].amount += Int(DataManager.shared.dataList[idx].amount)
                break
            case "식사":
                categoryAmountArray[1].amount += Int(DataManager.shared.dataList[idx].amount)
                break
            case "보험":
                categoryAmountArray[2].amount += Int(DataManager.shared.dataList[idx].amount)
                break
            case "술자리":
                categoryAmountArray[3].amount += Int(DataManager.shared.dataList[idx].amount)
                break
            case "물건구입":
                categoryAmountArray[4].amount += Int(DataManager.shared.dataList[idx].amount)
                break
            case "커피":
                categoryAmountArray[5].amount += Int(DataManager.shared.dataList[idx].amount)
                break
            case "기타":
                categoryAmountArray[6].amount += Int(DataManager.shared.dataList[idx].amount)
                break
            default:
                break
            }
        }
        
        // 경고금액 = 예산금액 80%
        let warningAmount = Int( Double(budget) * 0.8)
        var warningYn: Bool = false
        
        // 경고메세지 여부 셋팅
        if budget != 0 && totalOutlay >= warningAmount {
            warningYn = true
        }
        
        // 경고메세지 출력여부가 true 일 경우
        // 제일 많이 지출된 분류를 찾는다
        if warningYn {
            var maxAmount = (name: categoryAmountArray[0].name, amount: categoryAmountArray[0].amount)
            
            for idx in 0..<categoryAmountArray.count {
                if(maxAmount.amount < categoryAmountArray[idx].amount) {
                    maxAmount.amount = categoryAmountArray[idx].amount
                    maxAmount.name = categoryAmountArray[idx].name
                }
            }
            
            warning.text = "분류 : \(maxAmount.name) 과다지출 !!!!"
        }else {
            warning.text = ""
        }
        
        
        str += " / \(numberFormatter.string(from: NSNumber(value: totalOutlay))!)"
        amountInfo.text = str
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        currentDateSet()
        // Do any additional setup after loading the view.
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.shared.dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ListCell  else {
            return UITableViewCell()
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        cell.date.text = dateFormatter.string(from: DataManager.shared.dataList[indexPath.row].date!)
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        cell.amount.text = "\(numberFormatter.string(from: NSNumber(value: DataManager.shared.dataList[indexPath.row].amount))!) 원"
        
            
//        cell.amount.text = String(DataManager.shared.dataList[indexPath.row].amount)
        cell.category.text = DataManager.shared.dataList[indexPath.row].category
        cell.contents.text = DataManager.shared.dataList[indexPath.row].contents
        return cell
    }
    
    // true return 시 편집기능 활성화
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
 
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // 테이블뷰에있는 셀 숫자와 데이터 배열에 있는 숫자가 같아야함
            let target = DataManager.shared.dataList[indexPath.row]
            DataManager.shared.deleteData(target)
            DataManager.shared.dataList.remove(at: indexPath.row)
            
            // 테이블뷰에서 셀 삭제
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    /**
     현재 날짜 셋팅
     */
    func currentDateSet() {
//        let dateFomatter = DateFormatter()
//        dateFomatter.dateFormat = "yyyy년 MM월"
//        selectedDate.setTitle(dateFomatter.string(from: Date()), for: .normal)
        
        let calendar = Calendar.current
        year = Int(calendar.component(.year, from: Date()))
        month = Int(calendar.component(.month, from: Date()))
        selectedDate.setTitle("\(year)년 \(month)월", for: .normal)
    }
    
    /**
     왼쪽 화살표 클릭, 지난달 선택
     */
    @IBAction func click_LastMonth(_ sender: UIButton) {
        
        if month == 1 {
            year -= 1
            month = 12
        }else {
            month -= 1
        }
        
        selectedDate.setTitle("\(year)년 \(month)월", for: .normal)
        viewWillAppear(true)
    }

    /**
     오른쪽 화살표 클릭, 다음달 선택
     */
    @IBAction func click_NextMonth(_ sender: UIButton) {
        
        if month == 12 {
            year += 1
            month = 1
        }else {
            month += 1
        }
        
        selectedDate.setTitle("\(year)년 \(month)월", for: .normal)
        viewWillAppear(true)
    }
    
    // TODO: - 상단 날짜 클릭시 년도, 1월 ~ 12월 선택 가능하도록
    @IBAction func click_SelectedDate(_ sender: UIButton) {
    }
    
    /**
     예산설정, 예산을 입력하지 않았을경우 경고메세지  출력
     */
    @IBAction func setBudget(_ sender: UIButton) {
        
        guard let val = filed_budget.text?.replacingOccurrences(of: ",", with: ""), let amount = Int(val)
        else {
            let alert = UIAlertController(title: "경고", message: "예산을 입력해 주세요.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            
            return
        }
        
        DataManager.shared.setBudget("\(year)\(month)", amount)
        viewWillAppear(true)
        filed_budget.text = ""
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // 금액에 , 붙이기
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // replacementString : 방금 입력된 문자 하나, 붙여넣기 시에는 붙여넣어진 문자열 전체
        // return -> 텍스트가 바뀌어야 한다면 true, 아니라면 false
        // 이 메소드 내에서 textField.text는 현재 입력된 string이 붙기 전의 string
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal // 1,000,000
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = 0 // 허용하는 소숫점 자리수
        
        // formatter.groupingSeparator // .decimal -> ,
        
        if let removeAllSeprator = textField.text?.replacingOccurrences(of: formatter.groupingSeparator, with: ""){
            var beforeForemattedString = removeAllSeprator + string
            if formatter.number(from: string) != nil {
                if let formattedNumber = formatter.number(from: beforeForemattedString), let formattedString = formatter.string(from: formattedNumber){
                    textField.text = formattedString
                    return false
                }
            }else{ // 숫자가 아닐 때먽
                if string == "" { // 백스페이스일때
                    let lastIndex = beforeForemattedString.index(beforeForemattedString.endIndex, offsetBy: -1)
                    beforeForemattedString = String(beforeForemattedString[..<lastIndex])
                    if let formattedNumber = formatter.number(from: beforeForemattedString), let formattedString = formatter.string(from: formattedNumber){
                        textField.text = formattedString
                        return false
                    }
                }else{ // 문자일 때
                    return false
                }
            }

        }
        
        return true
    }
    
    // view 아무곳이나 선택시 키보드 내려 가도록함
    @IBAction func tapBG(_ sender: Any) {
        filed_budget.resignFirstResponder()
    }
    
    
}

extension ViewController {
    @objc private func adjustInputView(noti: Notification) {
        guard let userInfo = noti.userInfo else { return }
        // [x] TODO: 키보드 높이에 따른 인풋뷰 위치 변경
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }

        if noti.name == UIResponder.keyboardWillShowNotification {
            let adjustmentHeight = keyboardFrame.height - view.safeAreaInsets.bottom
            inputViewBottom.constant = adjustmentHeight
            print(adjustmentHeight)
        } else {
            inputViewBottom.constant = 0
        }
        
        print("---> Keyboard End Frame: \(keyboardFrame)")
    }
}

class ListCell: UITableViewCell {
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var contents: UILabel!
}


