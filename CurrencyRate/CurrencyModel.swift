//
//  CurrencyModel.swift
//  CurrencyRate
//
//  Created by GG on 13.01.17.
//  Copyright © 2017 GG. All rights reserved.
//

import Foundation

struct EuroRateModel {
    var latestRate:Double = 0
    var oldRate:Double = 0
    var trend :  Bool {
        var result = false
        result = self.latestRate < self.oldRate
        return result
    }
    var trendValue:Double {
        return self.latestRate - self.oldRate
    }
}

struct UsdRateModel {
    var latestRate:Double = 0
    var oldRate:Double = 0
    var trend: Bool {
        var result = false
        result = self.latestRate < self.oldRate
        return result
    }
    var trendValue:Double {
        return self.latestRate - self.oldRate
    }
}
