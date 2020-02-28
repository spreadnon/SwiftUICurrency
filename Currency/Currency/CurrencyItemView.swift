//
//  CurrencyItemView.swift
//  Currency
//
//  Created by iOS123 on 2020/2/28.
//  Copyright © 2020 CQL. All rights reserved.
//

import SwiftUI

struct CurrencyItemView: View {
    @EnvironmentObject var userData: UserData
    let currency: Currency
    let baseAmount: Double
    @Binding var isEditing: Bool
    
    var body: some View {
        let currency = self.currency
        let converstionRate = String(format: "%.4f", currency.rate / userData.baseCurrency.rate)
        let totalAmount = String(format: "%.3f", baseAmount * ( userData.baseCurrency.rate / currency.rate))

        return HStack {
            if self.isEditing {
                // This is for delete mode
                HStack(alignment: .center){
                    Image(systemName: "minus.circle")
                        .foregroundColor(.red)
                        .onTapGesture(count: 1) {
                            self.delete()
                    }
                    
                    Text(currency.flag).font(.title)
                    VStack(alignment: .leading){
                        Text(currency.code)
                        Text(currency.name).foregroundColor(.gray)
                    }
                }
            }
            else {
                // This is normal mode
                HStack{
                    // Flag
                    Text(currency.flag).font(.largeTitle)
                    // Code and name
                    VStack(alignment: .leading){
                        Text(currency.code).font(.headline)
                        Text(currency.name).font(.footnote).foregroundColor(.gray)
                    }
                    Spacer()
                    // Amount and conversion
                    VStack(alignment: .trailing){
                        Text("\(totalAmount)")
                        // Would be 1 this currency = xxx base currency
                        Text("1 \(currency.code) = \(converstionRate) \(userData.baseCurrency.code)")
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
    
    // TODO: need to implement
    private func delete() {
    }
}
