//
//  CartTableViewCell.swift
//  StoreManagment
//
//  Created by Владислав Кузьмичёв on 13.05.2021.
//

import UIKit

protocol CartTableViewCellDelegate: AnyObject {
    func didAddTapButton(product: Product)
    func didRemoveTapButton(product: Product)
}

class CartTableViewCell: UITableViewCell {
    
    weak var delegate: CartTableViewCellDelegate?
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var sizeLabel: UILabel!
    @IBOutlet var colorLabel: UILabel!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var removeButton: UIButton!
    
    static let identifier = "CartTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "CartTableViewCell", bundle: nil)
    }
    
    private var product = Product()
    private var amount = Int()
    
    func configure(product: Product, amount: Int) {
        self.product = product
        self.amount = amount
        nameLabel.text! = product.name
        sizeLabel.text! = product.size
        priceLabel.text! = "Цена: \(String(product.price))"
        colorLabel.text! = product.color
        amountLabel.text = "Количество: \(String(amount)) "
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func didAddTapButton() {
        delegate?.didAddTapButton(product: product)
    }
    
    @IBAction func didRemoveTapButton() {
        delegate?.didRemoveTapButton(product: product)
    }

    
}
