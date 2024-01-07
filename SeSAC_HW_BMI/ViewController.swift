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
    //Mark: - BMI 결과
    var statement = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 맞아? 이렇게 지저분해도 되는것이야????
        //Mark: - 상단
        BMICalculator.text = "BMI Calculator"
        BMICalculator.font = .boldSystemFont(ofSize: 30)
        info.text = "______님의 BMI 지수를\n알려드릴게요"
        info.numberOfLines = 2
        // trailing safe area -> 이미지 높이를 억지로 늘리니까 trailing에 맞춰지긴 했는데 사이즈를 고정값으로 하지 않고 어떻게 하는지 다시 확인해보기
        BMIImage.image = .image
        //Mark: - 닉네임
        nickNameLabel.text = "닉네임을 입력하세요"
        textFieldDesign(nickNameTextField)
        //Mark: - 키
        heightLabel.text = "키가 어떻게 되시나요?"
        // textfield의 원래 bordercolor가 희미하게 남아있음
        textFieldDesign(heightTextField)
        cm.text = "cm"
        heightTextField.delegate = self
        //Mark: - 몸무게
        weightLabel.text = "몸무게는 어떻게 되시나요?"
        textFieldDesign(weightTextField)
        kg.text = "kg"
        weightTextField.delegate = self
        hideWeightButton.setImage(UIImage(systemName: "eye"), for: .normal)
        hideWeightButton.tintColor = .gray
        //Mark: - 결과
        resultButton(resultButton)
        //Mark: - 랜덤 & 리셋
        randomResetButton(randomBMI, text: "랜덤으로 BMI 계산하기")
        randomResetButton(resetButton, text: "RESET")
        //Mark: - 값 저장된 화면
        saveValue()
    }
    
    //Mark: - 닉네임 TextField
    @IBAction func nickNameTextFieldTapped(_ sender: UITextField, label: UILabel) {
        if sender.text!.count < 14 {
            info.text = "\(sender.text!)님의 BMI 지수를\n알려드릴게요"
            label.text = "닉네임을 입력하세요"
            label.textColor = .black
        } else {
            label.text = "14자 이하로 입력하세요"
            label.textColor = .red
            sender.text = ""
        }
        UserDefaults.standard.set(sender.text, forKey: "nickName")
    }
    
    //Mark: - 키 입력 텍스트필드
    // 복붙 막기 기능
    @IBAction func inputHeight(_ sender: UITextField, label: UILabel) {
        
        validText(label, text: "키가 어떻게 되시나요?")
        
        guard let height = Double(sender.text!) else {
            invalidText(label, textField: sender)
            return
        }
        sender.text = "\(height)"
        
        if height < 65 || height > 290 {
            invalidText(heightLabel, textField: sender)
        }
        
        UserDefaults.standard.set(sender.text, forKey: "height")
    }
    
    //Mark: - 몸무게 입력 텍스트필드
    @IBAction func inputWeight(_ sender: UITextField, label: UILabel) {
        
        validText(label, text: "몸무게는 어떻게 되시나요?")
        
        guard let weight = Double(sender.text!) else {
            invalidText(label, textField: sender)
            return
        }
        sender.text = "\(weight)"

        if weight < 7 || weight > 200 {
            invalidText(label, textField: sender)
        }
        
        UserDefaults.standard.set(sender.text, forKey: "weight")
        
    }
    
    //Mark: - TextField 숫자만 입력되게
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allow = CharacterSet(charactersIn: "0123456789")
        let stringSet = CharacterSet(charactersIn: string)
        return allow.isSuperset(of: stringSet)
    }

    //Mark: - 몸무게 안보이게 하는 버튼
    // 다시 클릭했을 때 아이콘 돌아가기 기능 구현
    @IBAction func hideWeightButtonClicked(_ sender: UIButton) {
        weightTextField.isSecureTextEntry.toggle()
        sender.setImage(UIImage(systemName: "eye.slash"), for: .normal)
    }
    
    //Mark: - 랜덤 BMI
    @IBAction func randomBMIbuttonClicked(_ sender: UIButton) {
        
        let randomHeight = Int.random(in: 65...290)
        let randomWeight = Int.random(in: 7...200)
        
        heightTextField.text = "\(randomHeight)"
        weightTextField.text = "\(randomWeight)"
    }
    
    // 눌린 상태에서는 왜 파란색으로 변할까
    func randomResetButton(_ button: UIButton, text: String) {
        button.setTitle(text, for: .normal)
        button.setTitleColor(.red, for: .normal)
    }
    
    //Mark: - BMI 결과 버튼
    @IBAction func resultButtonClicked(_ sender: UIButton) {
        
        guard let height = heightTextField.text else {
            print("오류")
            return
        }
        
        guard let weight = weightTextField.text else {
            print("오류")
            return
        }
        
        let doubleHeight = (Double(height) ?? 0) / 100
        let twoTimesHeight = doubleHeight * doubleHeight
        let doubleWeight = (Double(weight) ?? 0)
        let bmiNum = doubleWeight / twoTimesHeight
        let bmiResult = String(format: "%.2f", bmiNum)
        
        switch bmiNum {
        case 0..<18.5: statement = "저체중"
        case 18.5..<23: statement = "정상"
        case 23..<25: statement = "위험체중"
        case 25..<30: statement = "1단계 비만"
        case 30...: statement = "2단계 비만"
        default: statement = "다이어트 하자,,"
        }
        
        let alert = UIAlertController(title: "\(statement)", message: "BMI 지수: \(bmiResult)", preferredStyle: .alert)
        let exitButton = UIAlertAction(title: "닫기", style: .default)
        alert.addAction(exitButton)
        
        if heightTextField.text?.isEmpty == true || weightTextField.text?.isEmpty == true  {
            
        } else {
            present(alert, animated: true)
        }
    }
    
    //Mark: - 리셋 버튼
    @IBAction func resetButtonClicked(_ sender: UIButton, textField: UITextField) {
        reset()
    }
    
    func reset() {
        nickNameTextField.text = ""
        heightTextField.text = ""
        weightTextField.text = ""
        
        if heightLabel.text == "다시 입력해주세요" || weightLabel.text == "다시 입력해주세요" {
            validText(heightLabel, text: "키가 어떻게 되시나요?")
            validText(weightLabel, text: "몸무게는 어떻게 되시나요?")
        }
        
        UserDefaults.standard.setValue("", forKey: "nickName")
        UserDefaults.standard.setValue("", forKey: "height")
        UserDefaults.standard.setValue("", forKey: "weight")
    }
    
    
    //Mark: - 빈 화면 눌렀을 때 키보드 내리게 하기
    @IBAction func keyboardDismiss(_ sender: Any) {
        view.endEditing(true)
    }

    //Mark: - TextField 공통 디자인 요소
    func textFieldDesign(_ sender: UITextField) {
        sender.layer.borderColor = UIColor.black.cgColor
        sender.layer.borderWidth = 1
        sender.layer.cornerRadius = 15
    }
    
    //Mark: - 결과 버튼 디자인 요소
    func resultButton(_ button: UIButton) {
        button.setTitle("결과 확인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .purple
        button.layer.cornerRadius = 10
    }
    
    //Mark: - 결과 값 저장
    func saveValue() {
        nickNameTextField.text = UserDefaults.standard.string(forKey: "nickName")
        heightTextField.text = UserDefaults.standard.string(forKey: "height")
        weightTextField.text = UserDefaults.standard.string(forKey: "weight")
    }
    
    //Mark: - 입력 값이 유효할 때
    func validText(_ label: UILabel, text: String) {
        label.text = text
        label.textColor = .black
    }
    
    //Mark: - 입력 값이 유효하지 않을 때
    func invalidText(_ sender: UILabel, textField: UITextField) {
        sender.text = "다시 입력해주세요"
        sender.textColor = .red
        textField.text = ""
    }
}
