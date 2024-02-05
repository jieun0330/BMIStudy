//
//  UserDefaultManager.swift
//  SeSAC_HW_BMI
//
//  Created by 박지은 on 2/4/24.
//

import Foundation

class UserDefaultManager {
    private init() { }
    static let shared = UserDefaultManager()
    
    let userDefault = UserDefaults.standard
    
    enum UDKey: String {
        case nickname
        case height
        case weight
    }
    
    var nickname: String {
        get {
            userDefault.string(forKey: UDKey.nickname.rawValue) ?? ""
        }
        set {
            userDefault.set(newValue, forKey: UDKey.nickname.rawValue)
        }
    }
    
    // ❓ String은 nil값이 있을 수 있어서 ??을 붙이고 Int, Double은 안붙인다 ? -> 덴님한테 다시 여쭤보기 
    
    var height: Double {
        get {
            userDefault.double(forKey: UDKey.height.rawValue)
        }
        set {
            userDefault.set(newValue, forKey: UDKey.height.rawValue)
        }
    }
    
    var weight: Double {
        get {
            userDefault.double(forKey: UDKey.weight.rawValue)
        }
        set {
            userDefault.set(newValue, forKey: UDKey.weight.rawValue)
        }
    }
    
}
