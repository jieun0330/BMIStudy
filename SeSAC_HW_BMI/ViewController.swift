//
//  ViewController.swift
//  SeSAC_HW_BMI
//
//  Created by 박지은 on 1/3/24.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var BMICalculator: UILabel!
    @IBOutlet var info: UILabel!
    @IBOutlet var BMIImage: UIImageView!
    @IBOutlet var nickNameLabel: UILabel!
    @IBOutlet var nickNameTextField: UITextField!
    @IBOutlet var heightLabel: UILabel!
    @IBOutlet var cm: UILabel!
    @IBOutlet var heightTextField: UITextField!
    @IBOutlet var weightLabel: UILabel!
    @IBOutlet var weightTextField: UITextField!
    @IBOutlet var kg: UILabel!
    @IBOutlet var hideWeightButton: UIButton!
    @IBOutlet var randomBMI: UIButton!
    @IBOutlet var resultButton: UIButton!
    @IBOutlet var resetButton: UIButton!
    
    // BMI 결과 case
    var statement = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleView()
        nicknameView()
        heightView()
        weightView()
        hideWeightButton.addTarget(self, action: #selector(hideWeightButtonClicked), for: .touchUpInside)
        randomButtonDesign(randomBMI, text: "랜덤으로 BMI 계산하기")
        randomButtonDesign(resetButton, text: "RESET")
        resultButtonDesign(resultButton)
    }
    
    // 상단 타이틀 영역
    func titleView() {
        BMICalculator.text = "BMI Calculator"
        BMICalculator.font = .boldSystemFont(ofSize: 30)
        info.text = "\(UserDefaultManager.shared.nickname)님의 BMI 지수를\n알려드릴게요"
        info.numberOfLines = 2
        BMIImage.image = .image
    }
    
    // 닉네임 영역
    func nicknameView() {
        nickNameLabel.text = "닉네임을 입력하세요"
        textFieldDesign(nickNameTextField)
        nickNameTextField.text = UserDefaultManager.shared.nickname
    }
    
    // 키 영역
    func heightView() {
        heightLabel.text = "키가 어떻게 되시나요?"
        textFieldDesign(heightTextField)
        cm.text = "cm"
        heightTextField.text = "\(UserDefaultManager.shared.height)"
    }
    
    // 몸무게 영역
    func weightView() {
        weightLabel.text = "몸무게는 어떻게 되시나요?"
        textFieldDesign(weightTextField)
        kg.text = "kg"
        hideWeightButton.setImage(UIImage(systemName: "eye"), for: .normal)
        hideWeightButton.tintColor = .gray
        weightTextField.text = "\(UserDefaultManager.shared.weight)"
    }
    
    // 몸무게 가리기 버튼
    @objc func hideWeightButtonClicked(_ sender: UIButton) {
        
        weightTextField.isSecureTextEntry.toggle()
        sender.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        
        if weightTextField.isSecureTextEntry == false {
            sender.setImage(UIImage(systemName: "eye"), for: .normal)
        }
    }
    
    func textFieldDesign(_ sender: UITextField) {
        sender.layer.borderColor = UIColor.black.cgColor
        sender.layer.borderWidth = 1
        sender.layer.cornerRadius = 15
        sender.clipsToBounds = true // 이걸 줘야 남아있는 희미한 borderColor가 없어짐
    }
    
    // 닉네임 입력
    @IBAction func inputNickname(_ sender: UITextField) {
        
        let whiteSpace = sender.text
        guard let trimString = whiteSpace?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        
        UserDefaultManager.shared.nickname = trimString
        
        if trimString.count < 14 {
            info.text = "\(UserDefaultManager.shared.nickname)님의 BMI 지수를\n알려드릴게요"
            nickNameLabel.text = "닉네임을 입력하세요"
            nickNameLabel.textColor = .black
            sender.text = trimString
        } else {
            nickNameLabel.text = "14자 이하로 입력하세요"
            nickNameLabel.textColor = .red
            sender.text = trimString
        }
    }
    
    // 키 입력
    @IBAction func inputHeight(_ sender: UITextField) {
        
        // 숫자가 아닐 경우
        guard let height = Double(sender.text!) else {
            invalidText(heightLabel, textField: sender)
            return
        }
        
        // 유효한 숫자가 아닐 경우
        if height < 65 || height > 290 {
            invalidText(heightLabel, textField: sender)
        }
        
        // 정상 입력했을 경우
        validText(heightLabel, text: "키가 어떻게 되시나요?")
        UserDefaultManager.shared.height = height
    }
    
    // 몸무게 입력
    @IBAction func inputWeight(_ sender: UITextField) {
        
        // 숫자가 아닐 경우
        guard let weight = Double(sender.text!) else {
            invalidText(weightLabel, textField: sender)
            return
        }
        
        // 유효한 숫자가 아닐 경우
        if weight < 7 || weight > 200 {
            invalidText(weightLabel, textField: sender)
        }
        
        // 정상 입력했을 경우
        validText(weightLabel, text: "몸무게는 어떻게 되시나요?")
        UserDefaultManager.shared.weight = weight
    }
    
    // 랜덤 BMI
    @IBAction func randomButtonClicked(_ sender: UIButton) {
        
        let randomHeight = Int.random(in: 65...290)
        let randomWeight = Int.random(in: 7...200)
        
        heightTextField.text = "\(randomHeight)"
        weightTextField.text = "\(randomWeight)"
    }
    
    func randomButtonDesign(_ button: UIButton, text: String) {
        button.setTitle(text, for: .normal)
        button.tintColor = .red
    }
    
    //    func example(_ bmi: Double) -> String {
    //        
    //    }
    
    func bmiStatement(_ bmi: Double) -> String {
        switch bmi {
        case 0..<18.5: statement = "저체중"
        case 18.5..<23: statement = "정상"
        case 23..<25: statement = "위험체중"
        case 25..<30: statement = "1단계 비만"
        case 30...: statement = "2단계 비만"
        default: statement = "다이어트 하자,,"
        }
        
        return statement
    }
    
    func calculateBMI(weight: String, height: String) -> Double {
        
        let doubleHeight = (Double(height) ?? 0) / 100
        let twoTimesHeight = doubleHeight * doubleHeight
        let doubleWeight = (Double(weight) ?? 0)
        
        return doubleWeight / twoTimesHeight
    }
    
    // BMI 결과
    @IBAction func resultButtonClicked(_ sender: UIButton) {
        
        guard let weight = weightTextField.text else { return }
        guard let height = heightTextField.text else { return }
        //        guard let weight = weightTextField.text, let height = heightTextField.text else { return }
        // 이렇게 쓰는것도 가능하네 ?
        
        let bmiNum = calculateBMI(weight: weight, height: height)
        // %.2f 소수점 둘째까지 출력
        let bmiResult = String(format: "%.2f", bmiNum)
        
        // Alert
        let resultAlert = UIAlertController(title: "\(bmiStatement(bmiNum))", message: "BMI 지수: \(bmiResult)", preferredStyle: .alert)
        let exitButton = UIAlertAction(title: "닫기", style: .default)
        resultAlert.addAction(exitButton)
        
        let emptyAlert = UIAlertController(title: "정보를 입력해주세요", message: "", preferredStyle: .alert)
        let closeButton = UIAlertAction(title: "닫기", style: .default)
        emptyAlert.addAction(closeButton)
        
        if heightTextField.text?.isEmpty == true || weightTextField.text?.isEmpty == true || heightTextField.text == "0.0" || weightTextField.text == "0.0" || nickNameTextField.text?.isEmpty == true {
            present(emptyAlert, animated: true)
        } else {
            present(resultAlert, animated: true)
        }
    }
    
    // 리셋 버튼
    @IBAction func resetButtonClicked(_ sender: UIButton) {
        reset()
    }
    
    // Bool, Int, Float, Double 타입의 값들은 해당 키가 없으면 기본값을 반환해준다
    // Bool -> false
    // Int, Float, Doulbe -> 0
    func reset() {
        nickNameTextField.text?.removeAll()
        heightTextField.text?.removeAll()
        weightTextField.text?.removeAll()
        
        if heightLabel.text == "다시 입력해주세요" || weightLabel.text == "다시 입력해주세요" {
            validText(heightLabel, text: "키가 어떻게 되시나요?")
            validText(weightLabel, text: "몸무게는 어떻게 되시나요?")
        }
        
        // ❓ 리셋 누른 후 앱 껐다 켰을 때는 0.0으로 세팅됨
        UserDefaultManager.shared.nickname.removeAll()
        UserDefaults.standard.removeObject(forKey: "height")
        UserDefaults.standard.removeObject(forKey: "weight")
    }
    
    @IBAction func keyboardDismiss(_ sender: Any) {
        view.endEditing(true)
    }
    
    // 결과 버튼 디자인 요소
    func resultButtonDesign(_ button: UIButton) {
        button.setTitle("결과 확인", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .purple
        button.layer.cornerRadius = 10
    }
    
    // 입력 값이 유효할 때
    func validText(_ label: UILabel, text: String) {
        label.text = text
        label.textColor = .black
    }
    
    // 입력 값이 유효하지 않을 때
    func invalidText(_ sender: UILabel, textField: UITextField) {
        sender.text = "다시 입력해주세요"
        sender.textColor = .red
        textField.text = ""
    }
}
