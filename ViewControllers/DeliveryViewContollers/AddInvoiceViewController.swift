//
//  AddInvoiceViewController.swift
//  StoreManagment
//
//  Created by Владислав Кузьмичёв on 06.05.2021.
//

import UIKit
import RealmSwift

class AddInvoiceViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var supplierPickerView: UIPickerView!
    
    var suppliers = [Supplier]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        supplierPickerView.dataSource = self
        supplierPickerView.delegate = self
        
    }
    
    @IBAction func nextStepButton(_ sender: Any) {
        
        let invoice = Invoice()
        invoice.dateOfDelivery = datePicker.date
        invoice.supplier = suppliers[supplierPickerView.selectedRow(inComponent: 0)]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addShipmentVC = storyboard.instantiateViewController(identifier: "addShipmentVC") as! AddShipmentViewController
        
        let user = app.currentUser
        let configuration = user!.configuration(partitionValue: partitionValue)

        Realm.asyncOpen(configuration: configuration) { result in
            switch result {
            case .failure(let error):
                print("Failed to open realm: \(error.localizedDescription)")
            case .success(let realm):
                try! realm.write {
                    realm.add(invoice)
                }
                
                addShipmentVC.invoice = invoice
                addShipmentVC.categories = Array(realm.objects(Classification.self).sorted(byKeyPath: "name"))
            }
            
            self.navigationController?.pushViewController(addShipmentVC, animated: true)
        }
        
        
    }
    
    }

extension AddInvoiceViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        suppliers.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let supplier = suppliers[row].name
        
        return supplier
    }
}

