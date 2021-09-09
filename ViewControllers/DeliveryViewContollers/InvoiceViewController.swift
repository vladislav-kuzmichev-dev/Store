//
//  InvoiceViewController.swift
//  StoreManagment
//
//  Created by Владислав Кузьмичёв on 06.05.2021.
//

import UIKit
import RealmSwift

class InvoiceViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var invoiceIdLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var supplierLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var invoice = Invoice()
    var shipments = [Shipment]()
  
    var shipmentIdLabels = [UILabel]()
    var amountLabels = [UILabel]()
    var purchasePriceLabels = [UILabel]()
    var productNameLabels = [UILabel]()
    var sizeLabels = [UILabel]()
    var priceLabels = [UILabel]()
    var colorLabels = [UILabel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        
        shipments = Array(invoice.shipments)

        invoiceIdLabel.text! += "\n\(invoice._id.stringValue)"
        let index = invoice.dateOfDelivery.description(with: Locale.current).range(of: "Moscow")
        let date = String(invoice.dateOfDelivery.description(with: Locale.current)[..<index!.lowerBound])
        dateLabel.text! += "\n\(date)"
        supplierLabel.text! += "\n\(invoice.supplier!.name)"
        
        
        
        for i in 0..<shipments.count {
            let labelShipmentId = UILabel()
            labelShipmentId.frame = CGRect(x: 0, y: 5*i*40 + i*60, width: 388, height: 40)
            labelShipmentId.text = "Поставка \(i+1)"
            labelShipmentId.font = UIFont.boldSystemFont(ofSize: 17)
            shipmentIdLabels.append(labelShipmentId)
            
            let labelAmount = UILabel()
            labelAmount.frame = CGRect(x: 0, y: 5*i*40 + i*60 + 40, width: 388, height: 40)
            labelAmount.text = "Количество: \(String(shipments[i].amount))"
            labelAmount.font = UIFont.systemFont(ofSize: 17)
            amountLabels.append(labelAmount)
            
            let purchasePriceLabel = UILabel()
            purchasePriceLabel.frame = CGRect(x: 0, y: 5*i*40 + i*60 + 40*2, width: 388, height: 40)
            purchasePriceLabel.text = "Стоимость закупки: \(String(shipments[i].purchasePrice)) руб."
            purchasePriceLabel.font = UIFont.systemFont(ofSize: 17)
            purchasePriceLabels.append(purchasePriceLabel)
            
            let prodNameLabel = UILabel()
            prodNameLabel.frame = CGRect(x: 0, y: 5*i*40 + i*60 + 40*3, width: 388, height: 60)
            prodNameLabel.numberOfLines = 2
            prodNameLabel.text = "Наименования товара: \(String(shipments[i].product!.name))"
            prodNameLabel.font = UIFont.systemFont(ofSize: 17)
            productNameLabels.append(prodNameLabel)
            
            let sizeLabel = UILabel()
            sizeLabel.frame = CGRect(x: 0, y: 5*i*40 + i*60 + 40*3 + 60, width: 388, height: 40)
            sizeLabel.text = "Размер товара: \(String(shipments[i].product!.size))"
            sizeLabel.font = UIFont.systemFont(ofSize: 17)
            sizeLabels.append(sizeLabel)
            
            let colorLabel = UILabel()
            colorLabel.frame = CGRect(x: 0, y: 5*i*40 + i*60 + 40*4 + 60, width: 388, height: 40)
            colorLabel.text = "Цвет товара: \(shipments[i].product!.color)"
            colorLabel.font = UIFont.systemFont(ofSize: 17)
            colorLabels.append(colorLabel)
            
        }
        
        scrollView.contentSize = CGSize(width: 388, height: shipments.count*40*5 + shipments.count*60)
        
        for i in 0..<shipments.count {
            self.scrollView.addSubview(shipmentIdLabels[i])
            self.scrollView.addSubview(amountLabels[i])
            self.scrollView.addSubview(purchasePriceLabels[i])
            self.scrollView.addSubview(productNameLabels[i])
            self.scrollView.addSubview(sizeLabels[i])
            self.scrollView.addSubview(colorLabels[i])
        }
    }
    

}
