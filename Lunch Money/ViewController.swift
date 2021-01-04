//
//  ViewController.swift
//  Lunch Money
//
//  Created by Matthew Mallimo on 12/29/20.
//

import LocalAuthentication
import UIKit

class ViewController: UIViewController {

    var categoriesManager = CategoriesManager()
    var transactionsManager = TransactionsManager()
    
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Verify Identity to view Finanical Information"
            print("ALmost")
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { (success, authenticationError) in
                DispatchQueue.main.async {
                    if success {
                        self.performSegue(withIdentifier: "authenticationSuccessSeque", sender: self)
                    }
                }
            }
        } else {
            print("Cant use this")
        }
    }
}

