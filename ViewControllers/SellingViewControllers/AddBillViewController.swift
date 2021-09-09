//
//  AddBillViewController.swift
//  StoreManagment
//
//  Created by Владислав Кузьмичёв on 14.05.2021.
//

import UIKit
import RealmSwift

class AddBillViewController: UIViewController {
    
    @IBOutlet weak var providerTextBox: UITextField!
    @IBOutlet weak var dropDown: UIPickerView!
    
    @IBOutlet weak var cardSwitch: UISwitch!
    @IBOutlet weak var customerLabel: UILabel!
    @IBOutlet weak var bonusLabel: UILabel!
    @IBOutlet weak var switchBonusLabel: UILabel!
    @IBOutlet weak var bonusSwitch: UISwitch!
    
    
    var customers = [Customer_card]()
    var customer = Customer_card()
    
    var isBonus = true
    var isCustomerCard = false
    var newBonus = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        providerTextBox.delegate = self
        dropDown.dataSource = self
        dropDown.delegate = self
        
        self.cardSwitch.setOn(false, animated: true)
        self.cardSwitch.addTarget(self, action: #selector(cardSwithcChange(paramTarget:)), for: .valueChanged)
        
        self.bonusSwitch.setOn(true, animated: true)
        self.bonusSwitch.addTarget(self, action: #selector(bonusSwitchChange(paramTarget:)), for: .valueChanged)
    }
    
    
    @IBAction func sellDidTapButton(_ sender: Any) {
        
        let bill = Bill()
        if (isCustomerCard) {
            bill.customer_card = customer
        }
        
        let user = app.currentUser
        let configuration = user!.configuration(partitionValue: partitionValue)

        Realm.asyncOpen(configuration: configuration) { result in
            switch result {
            case .failure(let error):
                print("Failed to open realm: \(error.localizedDescription)")
            case .success(let realm):
                try! realm.write {
                    realm.add(bill)
                }
            }
        }
        
        for (product, amount) in Cart.shared.basic {
            let bill_string = Bill_string()
            bill_string.amount = amount
            bill_string.product = product
            bill_string.bill = bill
            if isCustomerCard {
                if isBonus {
                    bill_string.price = product.price - customer.discount
                } else {
                    bill_string.price = product.price
                }
            } else {
                bill_string.price = product.price
            }

            Realm.asyncOpen(configuration: configuration) { result in
                switch result {
                case .failure(let error):
                    print("Failed to open realm: \(error.localizedDescription)")
                case .success(let realm):
                    try! realm.write {
                        realm.add(bill_string)
                        product.inStock -= amount
                        if self.isCustomerCard && self.isBonus {
                            bill.customer_card?.discount = 0
                        }
                        bill.customer_card?.discount += product.price * 0.05 * Double(amount)
                    }
                }
            }
            self.newBonus += product.price * 0.05 * Double(amount)
        }  
        
        Cart.shared.deleteAll()
        
        showAlertSell()
    }
    
    func showAlertSell() {
        let alert = UIAlertController(title: "Продажа оформлена", message: "Начислено баллов: \(Int(newBonus))", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .cancel, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true)
    }
    
    @objc func cardSwithcChange(paramTarget: UISwitch) {
        
        if (paramTarget.isOn) {
            isCustomerCard = true
            providerTextBox.isHidden = false
            customerLabel.isHidden = false
            bonusLabel.isHidden = false
            switchBonusLabel.isHidden = false
            bonusSwitch.isHidden = false
            } else {
                isCustomerCard = false
                providerTextBox.isHidden = true
                customerLabel.isHidden = true
                bonusLabel.isHidden = true
                switchBonusLabel.isHidden = true
                bonusSwitch.isHidden = true
            }
    }
    
    @objc func bonusSwitchChange(paramTarget: UISwitch) {
        if (paramTarget.isOn) {
            self.isBonus = true
        } else {
            self.isBonus = false
        }
    }

}

extension AddBillViewController: UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return customers.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.view.endEditing(true)
        let fio = customers[row].fio
        
        return fio
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.providerTextBox.text = self.customers[row].fio
        self.customer = customers[row]
        self.bonusLabel.text! = "Доступно баллов: \(Int(customer.discount))"
        self.dropDown.isHidden = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.providerTextBox {
            self.dropDown.isHidden = false
            textField.endEditing(true)
        }
    }
    
}
