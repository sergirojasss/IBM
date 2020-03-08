//
//  ViewController.swift
//  IBM
//
//  Created by Sergi Rojas on 27/02/2020.
//  Copyright © 2020 Sergi Rojas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
   
    var conversionList: [Conversion]!
    var transactionList: [Transaction]!
    var products: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // tableView Stuff
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // tableView Stuff
        
        self.loadData()
    }
    
    func loadData() {
        
        var conversionsReady: Bool = false
        var transactionsReady: Bool = false
        
        DispatchQueue.global(qos: .userInteractive).async {
            //The threads stuff: Checkd and the response of Alamofire, it's on the main thread, so this callback, its executed on the main thread
            TransactionController.getConversions { (conversionList) in
                Conversion.list = conversionList
                conversionsReady = true
                if conversionsReady && transactionsReady {
                    self.tableView.reloadData()
                }
            }
            TransactionController.getTransactions { (transactionList) in
                self.transactionList = transactionList
                for transaction in transactionList {
                    if !self.products.contains(transaction.sku) {
                        self.products.append(transaction.sku)
                    }
                }
                transactionsReady = true
                if conversionsReady && transactionsReady {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func showTotal(product: String, amount: Float) {
        let alertController = UIAlertController(title: product, message: "total sum for the product is: \(amount)", preferredStyle: .alert)
                
        let action1 = UIAlertAction(title: "Default", style: .default) { (action:UIAlertAction) in
        }

        alertController.addAction(action1)
        self.present(alertController, animated: true, completion: nil)

    }
}

// - MARK: Tableview methods
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = products[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let total = TransactionController.totalAmount(forSku: self.products[indexPath.row], inTransactions: transactionList)
        print(total)
        self.showTotal(product: self.products[indexPath.row], amount: total)
    }
    
}

