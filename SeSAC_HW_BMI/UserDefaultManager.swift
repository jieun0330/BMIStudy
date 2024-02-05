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
            userDefault.string(forKey: UDKey.nickname.rawValue) ?? "___"
        }
        set {
            userDefault.set(newValue, forKey: UDKey.nickname.rawValue)
        }
    }
    
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
