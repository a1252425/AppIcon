//
//  UIViewController+Extension.swift
//  AppIcon
//
//  Created by DDS on 2020/5/14.
//  Copyright © 2020 zerosportsai. All rights reserved.
//

import UIKit

extension UIViewController {
  func alert(_ title: String = "提示", _ message: String, _ button: String = "确定") {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let sureAction = UIAlertAction(title: button, style: .default, handler: nil)
    alertController.addAction(sureAction)
    present(alertController, animated: true, completion: nil)
  }
}

extension String {
  var docPath: String {
    return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/" + self
  }
}
