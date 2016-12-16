//
//  ViewController.swift
//  pset6-joelfleuren
//
//  Created by joel fleuren on 12-12-16.
//  Copyright © 2016 joel fleuren. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var search: UISearchBar!
    
    var stocks = [Stock]()
    var demo = CSVDemo()
    
    let ref = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        search.delegate = self
        table.delegate = self
        table.dataSource = self
        table.contentInset = UIEdgeInsetsMake(-60, 0, 0, 0)
        
        ref.child("keepTrack\(FIRAuth.auth()!.currentUser!.uid)").observe(.value, with: { (snapshot) in
            if snapshot != nil {
                for rest in snapshot.children.allObjects as! [FIRDataSnapshot] {
                    let dict = rest.value as! NSDictionary
                    
                    self.getData(text: dict["symbol"] as! String)
                    
                    DispatchQueue.main.async {
                        self.table.reloadData()
                    }
                }
                
            } else {
                let alertVC = UIAlertController(title: "Error!", message: "No saved search results found yet... :D", preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "oke", style: .default, handler: nil))
                self.present(alertVC, animated: true, completion: nil)
            }

        })
    }
    
    private func getData(text: String) {
        
        let stock = Stock()
        // set the url of the api in a variabel
        let stringURL = "http://finance.yahoo.com/d/quotes.csv?f=snl1&s=\(text)"
        
        // get the data from the api
        var stringData = demo.readStringFromURL(stringURL: stringURL)
        // remove the \" from the string
        stringData = stringData?.replacingOccurrences(of: "\"", with: "")
        // covert the string into an array where the comma seperates the data
        let stringDataArr = stringData?.components(separatedBy: ",")
        
        if stringDataArr?[1] != "N/A" {
            // name of the stock
            let name = stringDataArr?[1]
            // symbol of the stock
            let symbol = stringDataArr?[0]
            // price of the stock
            let price = stringDataArr?[2]
            
            // set the name, symbol and price  of the stock in stock.swift
            stock.Name = name!
            stock.Symbol = symbol!
            stock.Price = price!
            
            self.stocks.append(stock)
            
            // reload the table
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        } else {
            
            let alertVC = UIAlertController(title: "Error!", message: "Does not exist", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "oke", style: .default, handler: nil))
            present(alertVC, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // get the information over the table view cells from FinancetableViewCell.swift
        let cell = tableView.dequeueReusableCell(withIdentifier: "FinanceCellID", for: indexPath) as! FinanceTableViewCell
        cell.updateFinanceUI(stock: stocks[indexPath.row])
        
        return cell
    }
    // check if the can be editted
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    // function to swipe the table cells
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // make a keeptrack button with the colour blue
        let keeptrack = UITableViewRowAction(style: .normal, title: "Keep Track") { action, index in
            print("keep track tapped")
            
            let stock = self.stocks[index.row]
            
            var dict = Dictionary<String, Any>()
            dict["symbol"] = stock.Symbol
            dict["price"] = stock.Price
            dict["name"] = stock.Name
            
            self.ref.child("keepTrack\(FIRAuth.auth()!.currentUser!.uid)").child(stock.Symbol).setValue(dict)
            
            tableView.setEditing(false, animated: true)
            
        }
        
        keeptrack.backgroundColor = UIColor.blue
        // make a delete button
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") {
            (action, index) in
            
            //
            self.ref.child("keepTrack\(FIRAuth.auth()!.currentUser!.uid)").child(self.stocks[index.row].Symbol).removeValue()
            
            // delete the array
            self.stocks.remove(at: index.row)
            
            // delete the tablerow
            tableView.deleteRows(at: [index], with: .automatic)
            
        }
        
        return [delete,keeptrack]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        
        UserDefaults.standard.removeObject(forKey: "userUID")
        dismiss(animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // the text filled in by the user
        let searchbarText = searchBar.text!
        // make shore it works for all characters
        let queryString = searchbarText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        // use the symbol that is entered by the user to get the relevant information of the stock from getdata
        getData(text: queryString!)
        
    }


}

