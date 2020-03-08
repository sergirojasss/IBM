//
//  Currency.swift
//  IBM
//
//  Created by Sergi Rojas on 27/02/2020.
//  Copyright © 2020 Sergi Rojas. All rights reserved.
//

import Foundation

enum Currency {
    case EUR, USD, CAD, AUD
        
    static func initalizer(currencyString: String) -> Currency? {
        switch currencyString {
        case "EUR":
            return EUR
        case "USD":
            return USD
        case "CAD":
            return CAD
        case "AUD":
            return AUD
        default:
            return nil
        }
    }
}
