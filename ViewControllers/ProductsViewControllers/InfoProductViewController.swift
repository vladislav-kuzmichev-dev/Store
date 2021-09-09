//
//  InfoProductViewController.swift
//  StoreManagment
//
//  Created by Владислав Кузьмичёв on 22.04.2021.
//

import UIKit
import RealmSwift

class InfoProductViewController: UIViewController {
    
    
    @IBOutlet weak var nameField: UILabel!
    @IBOutlet weak var sizeField: UILabel!
    @IBOutlet weak var colorField: UILabel!
    @IBOutlet weak var priceField: UILabel!
    @IBOutlet weak var inStockField: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var image: UIImageView!
    
    var product = Product()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = product.name
        view.backgroundColor = UIColor.white
        
        idLabel.text! += "\(product._id)"
        nameField.lineBreakMode = .byWordWrapping
        nameField.text! += "\(product.name)"
        sizeField.text! += " \(product.size)"
        colorField.text! += " \(product.color)"
        priceField.text! += " \(product.price) руб."
        inStockField.text! += "\(product.inStock) шт."
        
        image.image = #imageLiteral(resourceName: "polo")
        image.layer.borderWidth = 1
        image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.black.cgColor
//        image.layer.cornerRadius = image.frame.height/2
        image.clipsToBounds = true

    }
    
    
    @IBAction func addToCart(_ sender: Any) {
        
        for prod in Cart.shared.basic.keys {
            if prod._id == product._id {
                showAlertDidNotAddToCart()
                return
            }
        }
        
        Cart.shared.create(product: product)
        showAlertAddToCart()
    }
    
    
    func showAlertAddToCart() {
        let alert = UIAlertController(title: "Товар добавлен в чек", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .cancel, handler: { action in
            
        }))
        present(alert, animated: true)
    }
    
    func showAlertDidNotAddToCart() {
        let alert = UIAlertController(title: "Товар уже находиться в чеке", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .cancel, handler: { action in
            
        }))
        present(alert, animated: true)
    }
    

}
