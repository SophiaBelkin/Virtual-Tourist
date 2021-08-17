//
//  UIViewController+Extension.swift
//  VirtualTourist
//
//  Created by Sophia Lu on 8/17/21.
//

import UIKit

extension UIViewController {
    func showFailedMessage(title: String, message: String) {
        let alertVC = UIAlertController(title:title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alertVC, animated: true)
    }
    
}
