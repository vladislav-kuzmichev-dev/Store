//
//  Cart.swift
//  StoreManagment
//
//  Created by Владислав Кузьмичёв on 13.05.2021.
//

import Foundation

class Cart {
    
    var basic = [Product:Int]()
    
    static var shared: Cart = {
            let instance = Cart()
            
            return instance
        }()
    
    private init() {}
    
    func create(product: Product) {
        basic[product] = 1
    }
    
    func delete(product: Product) {
        basic[product] = nil
    }
    
    func deleteAll() {
        for prod in basic.keys {
            delete(product: prod)
        }
    }
    
    func addOne(product: Product) {
        basic.updateValue(basic[product]!+1, forKey: product)
    }
    
    func removeOne(product: Product) {
        guard let amount = basic[product] else {
            return
        }
        
        if (amount == 1) {
            delete(product: product)
        }
        
        if (amount >= 2) {
            basic.updateValue(basic[product]!-1, forKey: product)
        }
    }
}

class RealmUser {
    
    static var shared: RealmUser = {
            let instance = RealmUser()
            
            return instance
        }()
    
    private init() {}
    
    var email = String()
}
