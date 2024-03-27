//
//  UIViewController.swift
//  Internship-at-Youla
//
//  Created by Vladimir Lesnykh on 27.03.2024.
//

import UIKit

extension UIViewController {
    
    public func alert(title: String, message: String, actionTitle: String, handler: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: actionTitle, style: .default) { _ in
            handler?()
        }
        alertController.addAction(confirmAction)
        present(alertController, animated: true)
    }
}
