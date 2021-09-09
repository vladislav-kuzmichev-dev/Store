//
//  CartViewController.swift
//  StoreManagment
//
//  Created by Владислав Кузьмичёв on 10.05.2021.
//

import UIKit
import RealmSwift

class CartViewController: UIViewController {
    
    @IBOutlet var cartTableView: UITableView!
    
    var products = [Product]()

    override func viewDidLoad() {
        super.viewDidLoad()

        reloadProducts()
        
        createTable()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cartTableView.reloadData()
    }
    
    
    private func createTable() {
        self.cartTableView.register(CartTableViewCell.nib(), forCellReuseIdentifier: CartTableViewCell.identifier)
        self.cartTableView.delegate = self
        self.cartTableView.dataSource = self
        
        self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.view.addSubview(cartTableView)
    }
    
    private func reloadProducts() {
        products.removeAll()
        for product in Cart.shared.basic.keys {
            products.append(product)
        }
    }
    
    @IBAction func didRemoveAllTapButton() {
        Cart.shared.deleteAll()
        reloadProducts()
        self.cartTableView.reloadData()
    }

    @IBAction func didAddBillTapButton(_ sender: Any) {
        if Cart.shared.basic.isEmpty {
            showCartIsEmpty()
        }
        else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let addBillVC = storyboard.instantiateViewController(identifier: "addBillVC") as! AddBillViewController
        
            let user = app.currentUser
            let configuration = user!.configuration(partitionValue: partitionValue)

            Realm.asyncOpen(configuration: configuration) { result in
                switch result {
                case .failure(let error):
                    print("Failed to open realm: \(error.localizedDescription)")
                case .success(let realm):
                    addBillVC.customers = Array(realm.objects(Customer_card.self).sorted(byKeyPath: "fio"))
 
                }
                self.navigationController?.pushViewController(addBillVC, animated: true)
            }
        }
    }
    
    func showCartIsEmpty() {
        let alert = UIAlertController(title: "Чек пуст", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .cancel, handler: { action in
            
        }))
        present(alert, animated: true)
    }
}

extension CartViewController : UITableViewDelegate, UITableViewDataSource, CartTableViewCellDelegate {
    func didAddTapButton(product: Product) {
        
        Cart.shared.addOne(product: product)
        cartTableView.reloadData()
    }

    func didRemoveTapButton(product: Product) {
        Cart.shared.removeOne(product: product)
        reloadProducts()
        cartTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Cart.shared.basic.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.identifier, for: indexPath) as! CartTableViewCell
        
        reloadProducts()
        guard let amount = Cart.shared.basic[products[indexPath.row]]
        else {
            return cell
        }
        
        cell.configure(product: products[indexPath.row], amount: amount)
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 235.0
    }
    
    
}
