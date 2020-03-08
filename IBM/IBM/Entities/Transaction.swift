//
//  Transaction.swift
//  IBM
//
//  Created by Sergi Rojas on 27/02/2020.
//  Copyright © 2020 Sergi Rojas. All rights reserved.
//

import Foundation

class Transaction {
    
    var sku: String!
    var amount: Float!
    var currency: Currency!
    
    init(sku: String, amount: Float, currency: Currency) {
        self.sku = sku
        self.amount = amount
        self.currency = currency
    }
    
}
