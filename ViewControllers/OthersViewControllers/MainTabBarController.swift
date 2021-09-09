//
//  MainTabBarController.swift
//  StoreManagment
//
//  Created by Владислав Кузьмичёв on 20.04.2021.
//

import UIKit
import RealmSwift

class MainTabBarController: UITabBarController {
// MARK: - Properties
    let realm: Realm
    
// MARK: - Initialization
    init(realm: Realm) {
        self.realm = realm

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        addData(realm: realm)
        let categoryNavController = self.generateNavController(vc: CategoryViewController(realm: realm), title: "Товары", image:#imageLiteral(resourceName: "icons8-товар-33"))
        let deliviryNavController = self.generateNavController(vc: DeliviryViewController(realm: realm), title: "Поставки", image: #imageLiteral(resourceName: "icons8-доставка-еды-33"))
        let sellingNavController = self.generateNavController(vc: SellingViewController(realm: realm), title: "Продажи", image:#imageLiteral(resourceName: "icons8-счет-фактура-33"))

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let settingsNavController = storyboard.instantiateViewController(identifier: "settingsVC") as! SettingsViewController
        settingsNavController.title = "Настройки"
        settingsNavController.tabBarItem.image = #imageLiteral(resourceName: "icons8-настройки-33")
        
        
        self.viewControllers = [categoryNavController, deliviryNavController, sellingNavController, settingsNavController]
        

    }
    
    fileprivate func generateNavController(vc: UIViewController, title: String, image: UIImage) -> UINavigationController{
        let navController = UINavigationController(rootViewController: vc)
        navController.title = title
        navController.tabBarItem.image = image
        return navController
    }
    
    fileprivate func addData(realm: Realm) {
        try! realm.write {
            realm.deleteAll()
        }
        
        let category1 = Classification(name: "Куртки и пальто")
        try! realm.write {
            realm.add(category1)
        }
        let category2 = Classification(name: "Футболки и майки")
        try! realm.write {
            realm.add(category2)
        }
        let category3 = Classification(name: "Кроссовки")
        try! realm.write {
            realm.add(category3)
        }
        
        let category4 = Classification(name: "Рубашки")
        try! realm.write {
            realm.add(category4)
        }
        
        let category5 = Classification(name: "Худи и свитшоты")
        try! realm.write {
            realm.add(category5)
        }
        
        let product1 = Product(name: "Черная выбеленная джинсовая куртка свободного кроя с 2 карманами Levi's", size: "L", price: 9510.0, color: "Черный цвет", inStock: 9, classification: category1)
        try! realm.write {
            realm.add(product1)
        }
        let product2 = Product(name: "Светло-бежевая джинсовая куртка винтажного силуэта с принтом тропических листьев Levi's", size: "M", price: 7680.0, color: "Бежевый", inStock: 7, classification: category1)
        try! realm.write {
            realm.add(product2)
        }
        let product3 = Product(name: "Темно-синяя футболка с ярусным логотипом-флагом Tommy Hilfiger", size: "XL", price: 6490.0, color: "Синий", inStock: 8, classification: category2)
        try! realm.write {
            realm.add(product3)
        }
        
        let product4 = Product(name: "Белая футболка с полоской и логотипом на груди Tommy Hilfiger", size: "L", price: 4990.0, color: "Белый", inStock: 9, classification: category2)
        try! realm.write {
            realm.add(product4)
        }
        let product5 = Product(name: "Белые кроссовки с брызгами красок Nike Air Force 1 '07 LV8 BB", size: "EU 44", price: 9499.0, color: "Белый", inStock: 9, classification: category3)
        try! realm.write {
            realm.add(product5)
        }
        let product6 = Product(name: "Черно-белые кроссовки Nike Blazer Mid '77", size: "EU 43", price: 8199.0, color: "WHITE/BLACK", inStock: 10, classification: category3)
        try! realm.write {
            realm.add(product6)
        }
        let product7 = Product(name: "Светло-бежевые кроссовки Nike Air Vapormax 2020 Flyknit", size: "EU 45", price: 19799.0, color: "Серо-бежевый", inStock: 10, classification: category3)
        try! realm.write {
            realm.add(product7)
        }
        
        let product8 = Product(name: "Белая приталенная рубашка из поплина Polo Ralph Lauren", size: "M", price: 7610.0, color: "Белый", inStock: 10, classification: category4)
        try! realm.write {
            realm.add(product8)
        }
        
        let product9 = Product(name: "Эксклюзивная темно-синяя рубашка навыпуск в утилитарном стиле с короткими рукавами и принтом игрока в поло на спине Polo Ralph Lauren", size: "S", price: 9320.0, color: "Темно-синий", inStock: 10, classification: category4)
        try! realm.write {
            realm.add(product9)
        }
        
        let product10 = Product(name: "Кремовая льняная рубашка навыпуск классического кроя с накладными карманами Polo Ralph Lauren", size: "L", price: 13590.0, color: "Светло-коричневый", inStock: 10, classification: category4)
        try! realm.write {
            realm.add(product10)
        }
        
        let product11 = Product(name: "Красный свитшот с крупным логотипом в университетском стиле Champion", size: "L", price: 6290.0, color: "Красный", inStock: 10, classification: category5)
        try! realm.write {
            realm.add(product11)
        }
        
        let product12 = Product(name: "Свитшот светло-коричневого цвета с эффектом кислотной стирки Champion Reverse Weave", size: "XL", price: 7690.0, color: "Серо-бежевый", inStock: 10, classification: category5)
        try! realm.write {
            realm.add(product12)
        }
        
        let provider1 = Supplier(name: "Levi's")
        try! realm.write {
            realm.add(provider1)
        }
        
        let provider2 = Supplier(name: "Tommy Hilfiger")
        try! realm.write {
            realm.add(provider2)
        }
        
        let provider3 = Supplier(name: "Nike")
        try! realm.write {
            realm.add(provider3)
        }
        
        let provider4 = Supplier(name: "Polo Ralph Lauren")
        try! realm.write {
            realm.add(provider4)
        }
        
        let provider5 = Supplier(name: "Champion")
        try! realm.write {
            realm.add(provider5)
        }
        
        let invoice1 = Invoice(supplier: provider1)
        try! realm.write {
            realm.add(invoice1)
        }
        
        let invoice2 = Invoice(supplier: provider2)
        try! realm.write {
            realm.add(invoice2)
        }
        
        let invoice3 = Invoice(supplier: provider3)
        try! realm.write {
            realm.add(invoice3)
        }
        
        let invoice4 = Invoice(supplier: provider4)
        try! realm.write {
            realm.add(invoice4)
        }
        
        let invoice5 = Invoice(supplier: provider5)
        try! realm.write {
            realm.add(invoice5)
        }
        
        let shipment1 = Shipment(amount: 10, purchasePrice: 8510.0, product: product1, invoice: invoice1)
        try! realm.write {
            realm.add(shipment1)
        }
        
        let shipment2 = Shipment(amount: 10, purchasePrice: 6980.0, product: product2, invoice: invoice1)
        try! realm.write {
            realm.add(shipment2)
        }
        
        let shipment3 = Shipment(amount: 10, purchasePrice: 5290.0, product: product3, invoice: invoice2)
        try! realm.write {
            realm.add(shipment3)
        }
        
        let shipment4 = Shipment(amount: 10, purchasePrice: 4490.0, product: product4, invoice: invoice2)
        try! realm.write {
            realm.add(shipment4)
        }
        
        let shipment5 = Shipment(amount: 10, purchasePrice: 8399.0, product: product5, invoice: invoice3)
        try! realm.write {
            realm.add(shipment5)
        }
        
        let shipment6 = Shipment(amount: 10, purchasePrice: 7099.0, product: product6, invoice: invoice3)
        try! realm.write {
            realm.add(shipment6)
        }
        
        let shipment7 = Shipment(amount: 10, purchasePrice: 17599.0, product: product7, invoice: invoice3)
        try! realm.write {
            realm.add(shipment7)
        }
        
        let shipment8 = Shipment(amount: 10, purchasePrice: 6410.0, product: product8, invoice: invoice4)
        try! realm.write {
            realm.add(shipment8)
        }
        
        let shipment9 = Shipment(amount: 10, purchasePrice: 7890.0, product: product9, invoice: invoice4)
        try! realm.write {
            realm.add(shipment9)
        }
        
        let shipment10 = Shipment(amount: 10, purchasePrice: 1190.0, product: product10, invoice: invoice4)
        try! realm.write {
            realm.add(shipment10)
        }
        
        let shipment11 = Shipment(amount: 10, purchasePrice: 5190.0, product: product11, invoice: invoice5)
        try! realm.write {
            realm.add(shipment11)
        }
        
        let shipment12 = Shipment(amount: 10, purchasePrice: 6390.0, product: product12, invoice: invoice5)
        try! realm.write {
            realm.add(shipment12)
        }
        
        let customer1 = Customer_card(fio: "Warren Edward Buffett", discount: 0)
        try! realm.write {
            realm.add(customer1)
        }
        
        let customer2 = Customer_card(fio: "Elon Reeve Musk", discount: 200)
        try! realm.write {
            realm.add(customer2)
        }
        
        let customer3 = Customer_card(fio: "Satoshi Nakamoto", discount: 300)
        try! realm.write {
            realm.add(customer3)
        }
        
        let bill1 = Bill(customer: customer1)
        try! realm.write {
            realm.add(bill1)
        }
        
        let bill2 = Bill(customer: customer2)
        try! realm.write {
            realm.add(bill2)
        }
        
        let bill3 = Bill(customer: customer3)
        try! realm.write {
            realm.add(bill3)
        }
        
        let bill_string1 = Bill_string(amount: 1, price: product1.price, product: product1, bill: bill1)
        try! realm.write {
            realm.add(bill_string1)
        }
        
        let bill_string2 = Bill_string(amount: 3, price: product2.price, product: product2, bill: bill2)
        try! realm.write {
            realm.add(bill_string2)
        }
        
        let bill_string3 = Bill_string(amount: 2, price: product3.price, product: product3, bill: bill3)
        try! realm.write {
            realm.add(bill_string3)
        }
        
        let bill_string4 = Bill_string(amount: 1, price: product4.price, product: product4, bill: bill3)
        try! realm.write {
            realm.add(bill_string4)
        }
        
        let bill_string5 = Bill_string(amount: 1, price: product5.price, product: product5, bill: bill3)
        try! realm.write {
            realm.add(bill_string5)
        }
        
    }

    

}
