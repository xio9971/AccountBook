//
//  addViewController.swift
//  AccountBook
//
//  Created by 정창규 on 2020/11/12.
//  Copyright © 2020 FastCampus. All rights reserved.
//

import UIKit
import FSCalendar

class addViewController: UIViewController, UITextFieldDelegate, FSCalendarDelegate {

    @IBOutlet weak var filed_Contents: UITextField! { didSet { filed_Contents.delegate = self}}
    
    @IBOutlet weak var filed_Price: UITextField! { didSet {filed_Price.delegate = self}}

    @IBOutlet weak var filed_Date: UITextField!

    @IBOutlet weak var category1: UIButton!
    @IBOutlet weak var category2: UIButton!
    @IBOutlet weak var category3: UIButton!
    @IBOutlet weak var category4: UIButton!
    @IBOutlet weak var category5: UIButton!
    @IBOutlet weak var category6: UIButton!
    @IBOutlet weak var category7: UIButton!
    
    @IBOutlet weak var save: UIButton!
    @IBOutlet weak var saveContinue: UIButton!
    
    var preSelectedCategory: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFiledDate()
        setInit()

        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textFiled: UITextField) ->Bool {
        textFiled.resignFirstResponder()
        return true
    }

    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // 분류 선택시 이벤트
    @IBAction func button_category(_ sender: UIButton) {
        
        //print(preSelectedCategory.title(for: .normal))
        preSelectedCategory.backgroundColor = UIColor.lightGray
        preSelectedCategory = sender
        sender.backgroundColor = UIColor.systemBlue
    }
    
    
    func setFiledDate() {
        
        // FSCalendar를 input view 로 셋팅
        let calendarView: FSCalendar = FSCalendar.init(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 400))

        calendarView.delegate = self
        self.filed_Date.inputView = calendarView
    }

    // 날짜선택시 이벤트
    func calendar(_ calendarView: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        //print(dateFormatter.string(from: date))
        filed_Date.text = dateFormatter.string(from: date)
        
        // 편집 해제
        self.view.endEditing(true)
    }
    
    @IBAction func save(_ sender: UIButton) {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let strDate = filed_Date.text, let date = dateFormatter.date(from: strDate) else {
            return
        }
        
        guard let val = filed_Price.text?.replacingOccurrences(of: ",", with: ""), let amount = Int(val) else {
            return
        }
        
        guard (preSelectedCategory.title(for: .normal) != nil) else {
            return
        }
        let category = preSelectedCategory.title(for: .normal)!

        let contents = filed_Contents.text
        
        DataManager.shared.addData(date, amount, category, contents)
        //DataManager.shared.fetchData()
        
        
        switch sender {
        case save:
            dismiss(animated: true, completion: nil)
            break;
        case saveContinue:
            setInit()
            break
        default:
            break
            
        }
    }
    

    func setInit() {
    
        if((preSelectedCategory) != nil) {
            preSelectedCategory.backgroundColor = UIColor.lightGray
        }
        preSelectedCategory = category1
        preSelectedCategory.backgroundColor = UIColor.systemBlue
        
        filed_Price.text = ""
        filed_Contents.text = ""
        filed_Date.text = ""

    }
    
    // 금액에 , 붙이기
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // 금액 텍스트필드 일경우에만 타도록 함
        // delegate = self 일경우에 타게되는데 내용(텍스트필드)도 return키 처리를 하기위해서 delegate = self를 함
        if(textField != filed_Price) {
            return true
        }
        
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
    
    

}
