//
//  AddShipmentViewController.swift
//  StoreManagment
//
//  Created by Владислав Кузьмичёв on 07.05.2021.
//

import UIKit
import RealmSwift

class AddShipmentViewController: UIViewController {

    var invoice = Invoice()
    var categories = [Classification]()
    
    @IBOutlet weak var nameProductTF: UITextField!
    @IBOutlet weak var amountTF: UITextField!
    @IBOutlet weak var purchasePriceTF: UITextField!
    @IBOutlet weak var sizeTF: UITextField!
    @IBOutlet weak var colorTF: UITextField!
    @IBOutlet weak var sellPriceTF: UITextField!
    @IBOutlet weak var categoryPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        categoryPickerView.dataSource = self
        categoryPickerView.delegate = self
        
    }
    
    
    @IBAction func addShipmentButton(_ sender: Any) {
        let product = Product()
        product.name = nameProductTF.text!
        product.price = Double(sellPriceTF.text!)!
        product.size = sizeTF.text!
        product.color = colorTF.text!
        product.inStock = Int(amountTF.text!)!
        product.classification = categories[categoryPickerView.selectedRow(inComponent: 0)]
    
        let user = app.currentUser
        let configuration = user!.configuration(partitionValue: partitionValue)

        Realm.asyncOpen(configuration: configuration) { result in
            switch result {
            case .failure(let error):
                print("Failed to open realm: \(error.localizedDescription)")
            case .success(let realm):
                try! realm.write {
                    realm.add(product)
                }
            }
        }
        
        let shipment = Shipment()
        shipment.amount = Int(amountTF.text!)!
        shipment.purchasePrice = Double(purchasePriceTF.text!)!
        shipment.product = product
        shipment.invoice = invoice
        Realm.asyncOpen(configuration: configuration) { result in
            switch result {
            case .failure(let error):
                print("Failed to open realm: \(error.localizedDescription)")
            case .success(let realm):
                try! realm.write {
                    realm.add(shipment)
                }
            }
        }
        
        
        self.alert(title: "Поставка успешно добавлена", message: "Выберите действие", style: .alert)
    }
    
    private func alert(title: String, message: String,style: UIAlertController.Style){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: "Закончить оформление накладной", style: .default) { (action) in
            self.navigationController?.popViewController(animated: true)
            self.navigationController?.popViewController(animated: true)
        }
        let action2 = UIAlertAction(title: "Добавить еще поставку", style: .default) { (action) in
            self.nameProductTF.text = nil
            self.sellPriceTF.text = nil
            self.sizeTF.text = nil
            self.colorTF.text = nil
            self.amountTF.text = nil
            self.purchasePriceTF.text = nil
        }
        alertController.addAction(action)
        alertController.addAction(action2)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension AddShipmentViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let category = categories[row].name
        
        return category
    }
    
}
