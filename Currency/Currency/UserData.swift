//
//  UserData.swift
//  Currency
//
//  Created by iOS123 on 2020/2/28.
//  Copyright © 2020 CQL. All rights reserved.
//

import SwiftUI
import Combine
import Foundation

private let defaultCurrencies: [Currency] = [
    Currency(name: "US dollar", rate: 1.0, symbol: "US", code: "USD"),
    Currency(name: "Canadian dollar", rate: 1.0, symbol: "CA", code: "CAD")
]

@propertyWrapper
struct UserDefaultValue<Value: Codable> {
    
    let key: String
    let defaultValue: Value
    
    var wrappedValue: Value {
        get {
            let data = UserDefaults.standard.data(forKey: key)
            let value = data.flatMap { try? JSONDecoder().decode(Value.self, from: $0) }
            return value ?? defaultValue
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}

final class UserData: ObservableObject {
    let objectWillChange = PassthroughSubject<UserData, Never>()
    
    @UserDefaultValue(key: "allCurrencies", defaultValue: defaultCurrencies)
    var allCurrencies: [Currency] {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    @UserDefaultValue(key: "baseCurrency", defaultValue: defaultCurrencies[0])
    var baseCurrency: Currency {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    @UserDefaultValue(key: "userCurrency", defaultValue: defaultCurrencies)
    var userCurrency: [Currency] {
        didSet {
            objectWillChange.send(self)
        }
    }
}
