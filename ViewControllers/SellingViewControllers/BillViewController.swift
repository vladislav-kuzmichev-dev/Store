//
//  BillViewController.swift
//  StoreManagment
//
//  Created by Владислав Кузьмичёв on 08.05.2021.
//

import UIKit
import RealmSwift

class BillViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var billIdLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var customerLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var bill = Bill()
    var bill_strings = [Bill_string]()
    
    var billStringsIdLabels = [UILabel]()
    var amountLabels = [UILabel]()
    var priceLabels = [UILabel]()
    var productNameLabels = [UILabel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        
        bill_strings = Array(bill.bill_strings)
        
        billIdLabel.text! += "\n\(bill._id.stringValue)"
        let index = bill.date.description(with: Locale.current).range(of: "Moscow")
        let date = String(bill.date.description(with: Locale.current)[..<index!.lowerBound])
        dateLabel.text! += "\n\(date)"
        if bill.customer_card == nil {
            customerLabel.text! += "\nКарта покупателя отсутвует"
        } else {
            customerLabel.text! += "\n\(bill.customer_card!.fio)"
        }
        
        for i in 0..<bill_strings.count {
            let labelBillStringsId = UILabel()
            labelBillStringsId.frame = CGRect(x: 0, y: 3*i*40 + i*60, width: 388, height: 40)
            labelBillStringsId.text = "Позиция \(i+1)"
            labelBillStringsId.font = UIFont.boldSystemFont(ofSize: 17)
            billStringsIdLabels.append(labelBillStringsId)
            
            let labelAmount = UILabel()
            labelAmount.frame = CGRect(x: 0, y: 3*i*40 + i*60 + 40, width: 388, height: 40)
            labelAmount.text = "Количество: \(bill_strings[i].amount)"
            labelAmount.font = UIFont.systemFont(ofSize: 17)
            amountLabels.append(labelAmount)
            
            let priceLabel = UILabel()
            priceLabel.frame = CGRect(x: 0, y: 3*i*40 + i*60 + 40*2, width: 388, height: 40)
            priceLabel.text = "Стоимость: \(String(bill_strings[i].price)) руб."
            priceLabel.font = UIFont.systemFont(ofSize: 17)
            priceLabels.append(priceLabel)
            
            let prodNameLabel = UILabel()
            prodNameLabel.frame = CGRect(x: 0, y: 3*i*40 + i*60 + 40*3, width: 388, height: 60)
            prodNameLabel.numberOfLines = 2
            prodNameLabel.text = "Наименования товара: \(String(bill_strings[i].product!.name))"
            prodNameLabel.font = UIFont.systemFont(ofSize: 17)
            productNameLabels.append(prodNameLabel)
        }
        
        scrollView.contentSize = CGSize(width: 388, height: bill_strings.count*40*4 + bill_strings.count*60)
        
        for i in 0..<bill_strings.count {
            self.scrollView.addSubview(billStringsIdLabels[i])
            self.scrollView.addSubview(amountLabels[i])
            self.scrollView.addSubview(priceLabels[i])
            self.scrollView.addSubview(productNameLabels[i])
        }
        
    }
    

}
