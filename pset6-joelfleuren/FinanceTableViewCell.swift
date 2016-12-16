//
//  Financetableviewcell.swift
//  pset6-joelfleuren
//
//  Created by joel fleuren on 12-12-16.
//  Copyright © 2016 joel fleuren. All rights reserved.
//

import UIKit

class FinanceTableViewCell: UITableViewCell {
    @IBOutlet weak var StockName: UILabel!
    @IBOutlet weak var StockSymbol: UILabel!
    @IBOutlet weak var StockPrice: UILabel!
    
    func updateFinanceUI(stock: Stock) {
        StockName.text = stock.Name
        StockSymbol.text = stock.Symbol
        StockPrice.text = stock.Price        
    }
    
}
