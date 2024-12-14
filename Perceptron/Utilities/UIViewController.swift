//
//  UIViewController.swift
//  Perceptron
//
//  Created by Denis Svichkarev on 12.05.2020.
//  Copyright © 2020 Denis Svichkarev. All rights reserved.
//

import Foundation

extension UIViewController {
    func popupAlert(title: String?, message: String?, actionTitles:[String?], actions:[((UIAlertAction) -> Void)?]) {
         let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
         for (index, title) in actionTitles.enumerated() {
             let action = UIAlertAction(title: title, style: .default, handler: actions[index])
             alert.addAction(action)
         }
         self.present(alert, animated: true, completion: nil)
     }
}
