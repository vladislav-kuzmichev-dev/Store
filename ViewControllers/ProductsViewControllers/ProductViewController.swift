//
//  ProductViewController.swift
//  StoreManagment
//
//  Created by Владислав Кузьмичёв on 22.04.2021.
//

import UIKit
import RealmSwift

class ProductViewController: UIViewController {
    
    var productTableView = UITableView()
    let cellIdentifier = "Cell"
    
    var products = [Product]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createTable()
        
    }
    
    private func createTable() {
        self.productTableView = UITableView(frame: self.view.bounds, style: .plain)
        self.productTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        self.productTableView.delegate = self
        self.productTableView.dataSource = self
        
        self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.view.addSubview(productTableView)
    }


}

extension ProductViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        let product = products[indexPath.row]
        cell.textLabel?.text = product.name
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true )
        let product = products[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let infoProductVC = storyboard.instantiateViewController(identifier: "infoProductVC") as! InfoProductViewController
        infoProductVC.product = product
        
        
        self.navigationController?.pushViewController(infoProductVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60.0
    }
}
