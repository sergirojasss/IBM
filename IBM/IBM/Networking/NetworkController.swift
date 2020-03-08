//
//  NetworkController.swift
//  IBM
//
//  Created by Sergi Rojas on 27/02/2020.
//  Copyright © 2020 Sergi Rojas. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworkController {
    
    // http://quiet-stone-2094.herokuapp.com/rates.json
    static func getConversions(completion: @escaping (_ success: [Conversion]) -> Void) {
        
        AF.request("http://quiet-stone-2094.herokuapp.com/rates", method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
            case .success:
                if let responseData = response.data {
                    let responseJson: JSON = JSON(responseData)
                    //                    print(responseJson)
                    var conversionList: [Conversion] = []
                    for json in responseJson {
                        guard let from = Currency.initalizer(currencyString: json.1["from"].stringValue), let to = Currency.initalizer(currencyString: json.1["to"].stringValue)
                            else {print("Should do something. Let's see if I have time enought")
                                return}
                        let rate = json.1["rate"].floatValue
                        conversionList.append(Conversion(from: from, to: to, rate: rate))
                    }
                    completion(conversionList)
                }
                break
            case .failure(let error):
                
                print(error)
            }
        }
    }
    
    //    http://quiet-stone-2094.herokuapp.com/transactions.json
    static func getTransactions(completion: @escaping (_ success: [Transaction]) -> Void) {
        
        AF.request("http://quiet-stone-2094.herokuapp.com/transactions", method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
            case .success:
                if let responseData = response.data {
                    let responseJson: JSON = JSON(responseData)
//                    print(responseJson)
                    var transactionList: [Transaction] = []
                    for json in responseJson {
                        guard let currency = Currency.initalizer(currencyString: json.1["currency"].stringValue) else{print("Should do something. Let's see if I have time enought")
                            return}
                        let sku = json.1["sku"].stringValue
                        let amount = json.1["amount"].floatValue
                        transactionList.append(Transaction(sku: sku, amount: amount, currency: currency))
                    }
                    completion(transactionList)
                }
                break
            case .failure(let error):
                
                print(error)
            }
        }
    }
    
}
