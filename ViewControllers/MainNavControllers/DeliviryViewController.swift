//
//  DeliviryViewController.swift
//  StoreManagment
//
//  Created by Владислав Кузьмичёв on 19.04.2021.
//

import UIKit
import RealmSwift

class DeliviryViewController: UIViewController {
// MARK: - Properties
    let realm: Realm
    var notificationToken: NotificationToken?
    
    var invoicesTableView = UITableView()
    let cellIdentifier = "Cell"
    
    let invoices: Results<Invoice>

// MARK: - Initialization
    init(realm: Realm) {
        self.realm = realm
        self.invoices = realm.objects(Invoice.self).sorted(byKeyPath: "dateOfDelivery")
        
        super.init(nibName: nil, bundle: nil)
        
        notificationToken = invoices.observe { [weak self] (changes) in
            guard let tableView = self?.invoicesTableView else { return }
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

        title = "Поставки"
        
        createTable()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(performAdd(param: )))
    }
    
    private func createTable() {
        self.invoicesTableView = UITableView(frame: self.view.bounds, style: .plain)
        self.invoicesTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        self.invoicesTableView.delegate = self
        self.invoicesTableView.dataSource = self
        
        self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.view.addSubview(invoicesTableView)
    }
    
    @objc private func performAdd(param: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addInvoiceVC = storyboard.instantiateViewController(identifier: "addInvoiceVC") as! AddInvoiceViewController
        addInvoiceVC.suppliers = Array(realm.objects(Supplier.self).sorted(byKeyPath: "name"))
        
        self.navigationController?.pushViewController(addInvoiceVC, animated: true)
    }

}

extension DeliviryViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invoices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let invoice = invoices[indexPath.row]
        let index = invoice.dateOfDelivery.description(with: Locale.current).range(of: "Moscow")
        let date = String(invoice.dateOfDelivery.description(with: Locale.current)[..<index!.lowerBound])
        var nameSupplier = String()
        if let supplier = invoice.supplier {
            nameSupplier = supplier.name
        }
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = "Накладная от \n\(date)\nПоставщик \(nameSupplier)"
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
        let invoiceVC = storyboard.instantiateViewController(identifier: "invoiceVC") as! InvoiceViewController
        invoiceVC.invoice = invoices[indexPath.row]

        self.navigationController?.pushViewController(invoiceVC, animated: true)
    }
    
    
}
