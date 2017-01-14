//
//  APIManager.swift
//  CurrencyRate
//
//  Created by GG on 13.01.17.
//  Copyright © 2017 GG. All rights reserved.
//

import Foundation
import Alamofire

class APIManager {
    
    var apiEndPoint:String = "http://api.fixer.io/"
    
    var eurModel = EuroRateModel()
    var usdModel = UsdRateModel()
    
    enum Base:String {
        case USD,EUR
    }
    
    enum apiRequest:String {
        case Latest, Previous
        func request() -> String {
            switch self {
            case .Latest:
                return "latest?base="
            case .Previous:
                return Date().dateForCompare
            }
        }
    }
    
    init (endPoint:String) {
        self.apiEndPoint = endPoint
    }
    
    func getEURRates(completion:@escaping (EuroRateModel?)->()) {
        
        let currentDateRequest = apiEndPoint + apiRequest.Latest.request() + Base.EUR.rawValue
        let yesterdayRate = apiEndPoint + apiRequest.Previous.request()
        
        Alamofire.request(currentDateRequest).responseJSON { [unowned self] response in
            switch response.result {
            case .success:
                if let result = response.result.value {
                    let JSON = result as! NSDictionary
                    if let rates = JSON.value(forKey: "rates") as? NSDictionary {
                        
                        if let value = rates.value(forKey: "USD") as? Double{
                            self.eurModel.latestRate = value
                                completion ( self.eurModel )
                        }
                    }
                }
                break
            case .failure:
                print(response.debugDescription)
                break
            }
        }
        
        Alamofire.request(yesterdayRate).responseJSON { [unowned self] response in
            switch response.result {
            case .success:
                if let result = response.result.value {
                    let JSON = result as! NSDictionary
                    if let rates = JSON.value(forKey: "rates") as? NSDictionary {
                        if let value = rates.value(forKey: "USD") as? Double{
                            self.eurModel.oldRate = value
                                completion ( self.eurModel )
                        }
                    }
                }
                break
            case .failure:
                print(response.debugDescription)
                break
            }
        }
        
    }
    
    func getUSDRates(completion:@escaping (UsdRateModel?)->()) {
        
        let currentDateRequest = apiEndPoint + apiRequest.Latest.request() + Base.USD.rawValue
        let yesterdayRate = apiEndPoint + apiRequest.Previous.request()
        Alamofire.request(currentDateRequest).responseJSON { [unowned self] response in
            switch response.result {
            case .success:
                if let result = response.result.value {
                    let JSON = result as! NSDictionary
                      print ("currentDateRequestUSD")
                     print (JSON)
                    if let rates = JSON.value(forKey: "rates") as? NSDictionary {
                        if let value = rates.value(forKey: "EUR") as? Double{
                            self.usdModel.latestRate = value
                             completion ( self.usdModel )
                        }
                    }
                }
                break
            case .failure:
                print(response.debugDescription)
                break
            }
        }
        
        Alamofire.request(yesterdayRate).responseJSON {[unowned self] response in
            switch response.result {
            case .success:
                if let result = response.result.value {
                    let JSON = result as! NSDictionary
                     print ("yesterdayRateUSD")
                    print (JSON)
                    if let rates = JSON.value(forKey: "rates") as? NSDictionary {
                        if let value = rates.value(forKey: "EUR") as? Double{
                            self.usdModel.oldRate = value
                            completion ( self.usdModel )
                        }
                    }
                }
                break
            case .failure:
                print(response.debugDescription)
                break
                    
            }
        }
        
    }
}


extension Date {
    
    var yesterday:Date {
        let calendar = Calendar.current
        let components = DateComponents(calendar:calendar,timeZone:TimeZone(identifier:"UTC"),day:-3)
        return calendar.date(byAdding:components , to: Date(), wrappingComponents: false)!
    }
    
    var dateForCompare: String {
        let dateFormatter = DateFormatter()
        let date = Date().yesterday
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier:"UTC")
        let timeStamp = dateFormatter.string(from: date)
        return timeStamp
    }
}





