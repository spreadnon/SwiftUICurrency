//
//  CurrencyData.swift
//  Currency
//
//  Created by iOS123 on 2020/2/28.
//  Copyright © 2020 CQL. All rights reserved.
//

import SwiftUI

struct Currency: Equatable, Hashable, Codable, Identifiable{
    let id: UUID
    let name: String
    
    // This is a rate to USD
    let rate: Double
    let symbol: String
    let code: String
    
    init(name: String, rate: Double, symbol: String = "", code: String) {
        self.id = UUID()
        self.name = name
        self.rate = rate
        self.symbol = symbol
        self.code = code
    }
    
    // Get unicode flag by currency symbol
    var flag: String {
        // Hard-code EU for now
        if self.symbol == "EU" { return "🇪🇺" }
        let base : UInt32 = 127397
        var s = ""
        for v in self.symbol.uppercased().unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        
        return s
    }
}
