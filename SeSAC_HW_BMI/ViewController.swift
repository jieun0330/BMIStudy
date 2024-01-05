//
//  ViewController.swift
//  SeSAC_HW_BMI
//
//  Created by 박지은 on 1/3/24.
//

import UIKit

class ViewController: UIViewController {
    
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
    
//    var nickName = "지은"
//    var nickName = UserDefaults.standard.string(forKey: "nickName")
    
    // BMI 결과
    var statement = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        BMICalculator.text = "BMI Calculator"
        BMICalculator.font = .boldSystemFont(ofSize: 30)
        
//        guard let myNickName = UserDefaults.standard.string(forKey: "nickName") else {
//            print("닉네임 입력 오류")
//            return
//        }
        
        
        info.text = "님의 BMI 지수를\n알려드릴게요"
        info.numberOfLines = 2
        
        // trailing safe area -> 이미지 높이를 억지로 늘리니까 trailing에 맞춰지긴 했는데 사이즈를 고정값으로 하지 않고 어떻게 하는지 다시 확인해보기
        BMIImage.image = .image
        
        nickNameLabel.text = "닉네임"
        textFieldDesign(nickNameTextField)
        
        heightLabel.text = "키가 어떻게 되시나요?"
        // textfield의 원래 bordercolor가 희미하게 남아있음
        textFieldDesign(heightTextField)
//        textField(heightTextField, shouldChangeCharactesIn: , replacementString: <#T##String#>)
        cm.text = "cm"
        
        weightLabel.text = "몸무게는 어떻게 되시나요?"
        textFieldDesign(weightTextField)
        
        hideWeightButton.setImage(UIImage(systemName: "eye"), for: .normal)
        hideWeightButton.tintColor = .gray
        
        kg.text = "kg"
        
        randomBMI.setTitle("랜덤으로 BMI 계산하기", for: .normal)
        randomBMI.setTitleColor(.red, for: .normal)
        
        resultButtonDesign(resultButton)
    
    }
    
    // 문자 입력 안받게 하고싶다고 나도
    // 키도 몸무게도 3자리까지만 받게 하고싶다고 나도
    // return 누르면 키보드 내리게 하는거 하기
    // ⭐️inputHeight랑 inputWeight 하나로 합치기
    @IBAction func inputHeight(_ sender: UITextField) {
        // 텍스트 입력하면 -> "숫자가 아닙니다" 바로 반응하게 하고싶다고 나도
        // 숫자 입력하면 다시 원래 text로 돌아가게 하고싶다고 나도
        guard let height = Double(heightTextField.text!) else {
            heightLabel.text = "숫자가 아닙니다"
            return
        }
        heightTextField.text = "\(height)"
    }

    @IBAction func inputWeight(_ sender: UITextField) {
        guard let weight = Double(weightTextField.text!) else {
            weightLabel.text = "숫자가 아닙니다"
            return
        }
        weightTextField.text = "\(weight)"
    }
    
    
    
    @IBAction func hideWeightButtonClicked(_ sender: UIButton) {

        // 토글했을 때 왜 아이콘에 배경색이 들어가지? 위에 tintColor 문제는 아닌것같고
        weightTextField.isSecureTextEntry.toggle()
        hideWeightButton.isSelected.toggle()
        
        let eyeImage = hideWeightButton.isSelected ? UIImage(systemName: "eye") : UIImage(systemName: "eye.slash")
        
    }
    
    @IBAction func randomBMIbuttonClicked(_ sender: UIButton) {
        
        // 이것도 하나로 합치기
        let randomHeight = Int.random(in: 65...290)
        let randomWeight = Int.random(in: 7...200)
        
        heightTextField.text = "\(randomHeight)"
        weightTextField.text = "\(randomWeight)"
    }
    
    // inputHeight, inputWeight에서 옵셔널 벗기고, 형변환 변수 만든거 가져다가 쓰고싶은데
    @IBAction func resultButtonClicked(_ sender: UIButton) {
        
        let doubleHeight = Double(heightTextField.text!)! / 100
        let twoTimesHeight = doubleHeight * doubleHeight
        let doubleWeight = Double(weightTextField.text!)!
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
        
        if heightTextField.text?.isEmpty == true {
            alert.title = "신장을 입력해주세요"
            alert.message = nil
        }
        // 몸무게 입력 안했을 시
        
        present(alert, animated: true)
        
    }
    
    @IBAction func keyboardDismiss(_ sender: Any) {
        view.endEditing(true)
    }
    
    func textFieldDesign(_ sender: UITextField) {
        sender.layer.borderColor = UIColor.black.cgColor
        sender.layer.borderWidth = 1
        sender.layer.cornerRadius = 15
    }
    
    func resultButtonDesign(_ button: UIButton) {
        button.setTitle("결과 확인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .purple
        button.layer.cornerRadius = 10
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactesIn range: NSRange, replacementString string: String) -> Bool {
//        if textField == heightTextField {
//            let allowedCharacters = CharacterSet.decimalDigits
//            let characterSet = CharacterSet(charactersIn: string)
//            return allowedCharacters.isSuperset(of: characterSet)
//        }
//        return true
//    }
    
    
    
}
