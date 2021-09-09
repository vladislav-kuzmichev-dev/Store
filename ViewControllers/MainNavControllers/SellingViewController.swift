//
//  SellingViewController.swift
//  StoreManagment
//
//  Created by Владислав Кузьмичёв on 20.04.2021.
//

import UIKit
import RealmSwift

class SellingViewController: UIViewController {
// MARK: - Properties
        let realm: Realm
        var notificationToken: NotificationToken?
        
        var sellingTableView = UITableView()
        let cellIdentifier = "Cell"
        
        let bills: Results<Bill>
    
// MARK: - Initialization
        init(realm: Realm) {
            self.realm = realm
            self.bills = realm.objects(Bill.self).sorted(byKeyPath: "date")
            
            super.init(nibName: nil, bundle: nil)
            
            notificationToken = bills.observe { [weak self] (changes) in
                guard let tableView = self?.sellingTableView else { return }
                switch changes {
                case .initial:
                    tableView.reloadData()
                case .update(_, let deletions, let insertions, let modifications):
                    tableView.performBatchUpdates({
                        tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0) }),
                            with: .automatic)
                        tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                            with: .automatic)
                        tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                            with: .automatic)
                    })
                case .error(let error):
                    fatalError("\(error)")
                }
            }
                
        }
            
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        deinit {
            // Always invalidate any notification tokens when you are done with them.
            notificationToken?.invalidate()
        }
      

// MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Продажи"
        view.backgroundColor = UIColor.white
        
        createTable()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(performAdd(param: )))
        
    }
    
    private func createTable() {
        self.sellingTableView = UITableView(frame: self.view.bounds, style: .plain)
        self.sellingTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        self.sellingTableView.delegate = self
        self.sellingTableView.dataSource = self
        
        self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.view.addSubview(sellingTableView)
    }
    
    @objc private func performAdd(param: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let cartVC = storyboard.instantiateViewController(identifier: "cartVC") as! CartViewController
        
        self.navigationController?.pushViewController(cartVC, animated: true)
    }

}

extension SellingViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bills.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let bill = bills[indexPath.row]
        let index = bill.date.description(with: Locale.current).range(of: "Moscow")
        let date = String(bill.date.description(with: Locale.current)[..<index!.lowerBound])
        var fio = String()
        if let customerCard = bill.customer_card {
            fio = customerCard.fio
        } else {
            fio = "Карта покупателя отсутствует"
        }
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = "Чек от\n\(date)\nПокупатель \(fio)"
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true )

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let billVC = storyboard.instantiateViewController(identifier: "billVC") as! BillViewController
        billVC.bill = bills[indexPath.row]

        self.navigationController?.pushViewController(billVC, animated: true)
    }
    
    
}
