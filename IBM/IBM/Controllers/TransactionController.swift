//
//  TransactionController.swift
//  IBM
//
//  Created by Sergi Rojas on 27/02/2020.
//  Copyright © 2020 Sergi Rojas. All rights reserved.
//

import Foundation

class TransactionController {
    
    static func getConversions(completion: @escaping (_ success: [Conversion]) -> Void) {
        NetworkController.getConversions { (conversionList) in
            completion(conversionList)
        }
    }
    static func getTransactions(completion: @escaping (_ success: [Transaction]) -> Void) {
        NetworkController.getTransactions { (transactionList) in
            completion(transactionList)
        }
    }
    
    
    
    //    case EUR, USD, CAD, AUD
    // We're assuming there are only this four currencies.
    static func toEur(currency: Currency, amount: Float) -> Float? {
        var usdValue: Float?
        var cadValue: Float?
        var audValue: Float?
        
        if currency == .EUR {
            return amount
        }
        if let conversion = Conversion.find(from: currency, to: .EUR) {
            return (amount * conversion.rate).rounded(.toNearestOrEven)
        }

        for conversion in Conversion.list {
            if conversion.from == currency { // not .EUR on switch because if it's solved on the if statement above
                if conversion.to == Currency.USD {
                    usdValue = (amount * conversion.rate).rounded(.toNearestOrEven)
                }
                if conversion.to == Currency.CAD {
                    cadValue = (amount * conversion.rate).rounded(.toNearestOrEven)
                }
                if conversion.to == Currency.AUD {
                    audValue = (amount * conversion.rate).rounded(.toNearestOrEven)
                }
            }
            if let conversions = Conversion.findAll(from: .USD), (usdValue != nil) {
                for conversion in conversions {
                    if conversion.to == Currency.CAD && cadValue == nil {
                        cadValue = (usdValue! * conversion.rate).rounded(.toNearestOrEven)
                    }
                    if conversion.to == Currency.AUD && audValue == nil {
                        audValue = (usdValue! * conversion.rate).rounded(.toNearestOrEven)
                    }
                }
            }
            if let conversions = Conversion.findAll(from: .CAD), (cadValue != nil) {
                    for conversion in conversions {
                        if conversion.to == Currency.USD && usdValue == nil {
                            usdValue = (cadValue! * conversion.rate).rounded(.toNearestOrEven)
                        }
                        if conversion.to == Currency.AUD && audValue == nil {
                            audValue = (cadValue! * conversion.rate).rounded(.toNearestOrEven)
                        }
                    }
                }
            if let conversions = Conversion.findAll(from: .AUD), (audValue != nil) {
                    for conversion in conversions {
                        if conversion.to == Currency.USD && usdValue == nil {
                            usdValue = (audValue! * conversion.rate).rounded(.toNearestOrEven)
                        }
                        if conversion.to == Currency.CAD && cadValue == nil {
                            cadValue = (audValue! * conversion.rate).rounded(.toNearestOrEven)
                        }
                    }
                }

        }
        
        
        if let value = usdValue, let conversion = Conversion.find(from: .USD, to: .EUR) {
            return (value * conversion.rate).rounded(.toNearestOrEven)
        }
        if let value = cadValue, let conversion = Conversion.find(from: .CAD, to: .EUR) {
            return (value * conversion.rate).rounded(.toNearestOrEven)
        }

        if let value = audValue, let conversion = Conversion.find(from: .AUD, to: .EUR) {
            return (value * conversion.rate).rounded(.toNearestOrEven)
        }
        
        let list = Conversion.list
        print("never should execute this line. Should return something before")
        return nil
    }
    
    static func totalAmount(forSku: String, inTransactions: [Transaction]) -> Float {
        var amount: Float = 0
        for transaction in inTransactions {
            if transaction.sku.elementsEqual(forSku) {
                if let eur = TransactionController.toEur(currency: transaction.currency, amount: transaction.amount) {
                    amount += eur
                }
            }
        }
        return amount
    }
}
