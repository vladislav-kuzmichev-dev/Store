//
//  CategoryViewController.swift
//  StoreManagment
//
//  Created by Владислав Кузьмичёв on 19.04.2021.
//

import UIKit
import RealmSwift

class CategoryViewController: UIViewController {
// MARK: - Properties
    var realm: Realm
    var notificationToken: NotificationToken?
    
    var categoryTableView = UITableView()
    let cellIdentifier = "Cell"
    
    let categories: Results<Classification>

// MARK: - Initialization
    init(realm: Realm) {
        self.realm = realm
        self.categories = realm.objects(Classification.self).sorted(byKeyPath: "name")
            
        super.init(nibName: nil, bundle: nil)
            
        notificationToken = categories.observe { [weak self] (changes) in
            guard let tableView = self?.categoryTableView else { return }
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
        
        title = "Товары"
        
        createTable()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        categoryTableView.reloadData()
    }
    
    private func createTable() {
        self.categoryTableView = UITableView(frame: self.view.bounds, style: .plain)
        self.categoryTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        self.categoryTableView.delegate = self
        self.categoryTableView.dataSource = self
        
        self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.view.addSubview(categoryTableView)
    }

}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        let category = categories[indexPath.row]
        cell.textLabel?.text = category.name
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.font = UIFont.systemFont(ofSize: 19)

        return cell
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true )

        let category = categories[indexPath.row]


        let productVC = ProductViewController()
        productVC.title = category.name
        productVC.products = Array(categories[indexPath.row].products)
        self.navigationController?.pushViewController(productVC, animated: true)

        
    }
    
}
