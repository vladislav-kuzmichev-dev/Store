//
//  SettingsViewController.swift
//  StoreManagment
//
//  Created by Владислав Кузьмичёв on 02.05.2021.
//

import UIKit
import RealmSwift

class SettingsViewController: UIViewController {

    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Настройки"
        view.backgroundColor = .white
        
        nameLabel.text! += " \(RealmUser.shared.email)"

    }
    
    @IBAction func logOutDIdTapButton(_ sender: Any) {
        logOutButtonDidClick()
    }
    
    
    func logOutButtonDidClick() {
        let alertController = UIAlertController(title: "Вы действительно хотите выйти?", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Да, Выйти", style: .destructive, handler: {
            _ -> Void in
            print("Logging out...")
            app.currentUser?.logOut { (_) in
                DispatchQueue.main.async {
                    print("Logged out!")
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(WelcomeViewController())
                    RealmUser.shared.email = ""
                }
            }
        }))
        alertController.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    


}
