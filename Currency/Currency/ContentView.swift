//
//  ContentView.swift
//  Currency
//
//  Created by iOS123 on 2020/2/28.
//  Copyright © 2020 CQL. All rights reserved.
//

import SwiftUI
import Foundation

struct ContentView : View {
    @EnvironmentObject var userData: UserData
    @State var baseAmount: String = "1.0"
    @State var isEditing: Bool = false
    @State var lastUpdated: String = ""
    
    var body: some View {
        let inset = EdgeInsets(top: -8, leading: -20, bottom: -7, trailing: -15)
        let doubleValue: Double = Double(self.$baseAmount.wrappedValue) ?? 1.0
        
        return ZStack(alignment: Alignment.bottomTrailing) {
            NavigationView {
            VStack(alignment: .leading){
                Text("From:").bold().foregroundColor(.gray)
                HStack{
                    // Flag
                    Text("\(userData.baseCurrency.flag)").padding(5)
                    // Code and name
                    VStack(alignment: .leading){
                        Text(userData.baseCurrency.code).foregroundColor(.white)
                        //Text(userData.baseCurrency.name).foregroundColor(.white)
                    }
                    Spacer()
                    // Amount and conversion
                    TextField("1.0", text: $baseAmount, onCommit: {
                        // TODO: update all currencies on the following list
                    }).foregroundColor(.white)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.clear)
                                .background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color(red: 0.7, green: 0.7, blue: 0.7), lineWidth: 1 / UIScreen.main.scale))
                                .padding(inset)
                        )
                        .multilineTextAlignment(.trailing)
                }.background(Color.blue).cornerRadius(5)
                Text("To:").bold().foregroundColor(.gray)
                List {
                    // TODO: should filter out BaseCurrency from list
                    ForEach(userData.userCurrency) { currency in
                        CurrencyItemView(currency: currency, baseAmount: doubleValue, isEditing: self.$isEditing).onTapGesture {
                                // Swap this and base
                                self.userData.baseCurrency = currency
                            }
                        }
                    }.onAppear(perform: loadCurrencies)
                    .navigationBarTitle(Text("Currencies 💱"))
                    .navigationBarItems(trailing: Button(action: { self.isEditing.toggle() }) {
                        if !self.isEditing {
                            Text("Edit")
                        } else {
                            Text("Done").bold()
                        }
                    })
                HStack {
                    Text("Last updated: \(self.lastUpdated)")
                        .foregroundColor(.gray).italic()
                Spacer()

            NavigationLink(destination: AddCurrencyView().environmentObject(self.userData)) {
                    Text("💰")
                }.frame(width: 46, height: 46, alignment: .center)
                .background(
                    RoundedRectangle(cornerRadius: 23)
                        .fill(Color.clear)
                        .background(RoundedRectangle(cornerRadius: 23).strokeBorder(Color(red: 0.7, green: 0.7, blue: 0.7), lineWidth: 1 / UIScreen.main.scale)))
                .foregroundColor(.white).font(.largeTitle)
        }.padding()
                }
        }
        }
    }
    
    private func loadCurrencies() {
        // Check if last updated is the same date
        // if not the same pull from remote with base currency
        let url = URL(string: "https://api.exchangeratesapi.io/latest?base=USD")!

        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, _, _ in
            if let data = data {
                if let decoded: CurrencyList = self.decodeData(CurrencyList.self, data){
                    //
                    self.lastUpdated = decoded.date
                    
                    // generate currency data
                    var newCurrencies = [Currency]()
                    for key in decoded.rates.keys {
                        let newCurrency = Currency(name: supportedCurrencies[key]?[0] ?? "Unknown", rate: 1.0 / (decoded.rates[key] ?? 1.0), symbol: supportedCurrencies[key]?[1] ?? "", code: key)
                        newCurrencies.append(newCurrency)
                    }
                    
                    DispatchQueue.main.async {
                        self.userData.allCurrencies = newCurrencies
                        
                        if let base = self.userData.allCurrencies.filter({ $0.symbol == self.userData.baseCurrency.symbol }).first {
                            self.userData.baseCurrency = base
                        }
                        
                        var tempNewUserCurrency = [Currency]()
                        let userCurrencies = self.userData.userCurrency.map{ $0.code }
                        for c in self.userData.allCurrencies {
                            if userCurrencies.contains(c.code){
                                tempNewUserCurrency.append(c)
                            }
                        }
                        
                        self.userData.userCurrency = tempNewUserCurrency
                    }
                }
            }
        })
        task.resume()
    }
}

extension ContentView
{
    private func decodeData<T>(_ decodeObject: T.Type, _ data: Data) -> T? where T: Codable
    {
        let decoder = JSONDecoder()
        do
        {
            return try decoder.decode(decodeObject.self, from: data)
        }
        catch let jsonErr
        {
            print("Error decoding Json ", jsonErr)
            return nil
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(UserData())
    }
}
#endif
