//
//  Conversion.swift
//  IBM
//
//  Created by Sergi Rojas on 27/02/2020.
//  Copyright © 2020 Sergi Rojas. All rights reserved.
//

import Foundation


class Conversion {
    
    static var list: [Conversion] = []
    
    let from: Currency!
    let to: Currency!
    let rate: Float!
    
    init(from: Currency, to: Currency, rate: Float) {
        self.from = from
        self.to = to
        self.rate = rate
    }
    
    static func find(from: Currency, to: Currency) -> Conversion? {
        for conversion in Conversion.list {
            if conversion.from == from && conversion.to == to {
                return conversion
            }
        }
        return nil
    }
    
    static func findAll(from: Currency) -> [Conversion]? {
        var conversions: [Conversion] = []
        for conversion in self.list {
            if conversion.from == from {
                conversions.append(conversion)
            }
        }
        if conversions.isEmpty {
            return nil
        }
        return conversions
    }

}
