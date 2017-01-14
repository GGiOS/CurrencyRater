 //
//  ViewController.swift
//  CurrencyRate
//
//  Created by GG on 13.01.17.
//  Copyright © 2017 GG. All rights reserved.
//

import UIKit
import AlamofireNetworkActivityIndicator
class MainViewController: UIViewController {
    
    
    @IBOutlet weak var sunButton: UIBarButtonItem!
    @IBOutlet weak var eurUsd: UILabel?
    @IBOutlet weak var usdEur: UILabel?
    
    @IBOutlet weak var eurUsdLabel: UILabel!
    @IBOutlet weak var usdEurLabel: UILabel!
   
    @IBOutlet weak var usdEurTrandLabel: UILabel!
    @IBOutlet weak var eurUsdTrandLabel: UILabel!
    
        enum Theme:Int {
        case Sun = 100, Moon = 101
    }
    
    var timer:Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateData()
        timer = Timer.scheduledTimer(timeInterval: 30,
                                     target: self,
                                     selector: #selector(self.updateData),
                                     userInfo: nil,
                                     repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateData() {
        
        apiManager.getUSDRates {[unowned self] completion  in
            print (completion ?? "novalue")
            if let model = completion {
                self.usdEur?.text = "\(model.latestRate)"
                self.usdEurTrandLabel.text = model.trend ? "+ \(model.trendValue)" : "- \(model.trendValue)"            }
            
        }
        
        apiManager.getEURRates {[unowned self] completion in
         print (completion ?? "novalue")
            if let model = completion {
            self.eurUsd?.text = "\(model.latestRate)"
            self.eurUsdTrandLabel.text = model.trend ? "+ \(model.trendValue)" : "- \(model.trendValue)"
            }
        }
    
    }
    
    @IBAction func moonLight(_ sender: UIBarButtonItem) {
        changeTheme(theme: sender.tag)
    }
    
    @IBAction func sunLight(_ sender: UIBarButtonItem) { changeTheme(theme: sender.tag)
    }
    
    func changeTheme (theme:Int) {
        switch theme {
        case Theme.Sun.rawValue:
            UIView.animate(withDuration: 0.5, animations: {
                  self.view.backgroundColor = UIColor.white
                  self.eurUsd?.textColor = .black
                  self.usdEur?.textColor = .black
                  self.usdEurLabel?.textColor = .black
                  self.eurUsdLabel?.textColor = .black
                  self.eurUsdTrandLabel.textColor = .black
                  self.usdEurTrandLabel.textColor = .black
            })
          
        case Theme.Moon.rawValue:
            UIView.animate(withDuration: 0.5, animations: {
            self.view.backgroundColor = UIColor.black
                self.eurUsd?.textColor = .white
                self.usdEur?.textColor = .white
                self.usdEurLabel?.textColor = .white
                self.eurUsdLabel?.textColor = .white
                self.eurUsdTrandLabel.textColor = .white
                self.usdEurTrandLabel.textColor = .white
                
                     })
        default:
            break
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
     super.viewDidDisappear(animated)
        timer?.invalidate()
    }
}

