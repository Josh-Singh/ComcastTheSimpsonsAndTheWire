//
//  UIViewController + Helper.swift
//  ComcastCodingTest
//
//  Created by Yash Singh on 1/20/19.
//  Copyright © 2019 Yash Singh. All rights reserved.
//

import UIKit

extension UIViewController{
    
    func showAlert(errorMessage: String){
    let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
}

