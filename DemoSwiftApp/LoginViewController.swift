//
//  LoginViewController.swift
//  DemoSwiftApp
//
//  Created by Ricardo on 25/03/17.
//  Copyright © 2017 Mobile First. All rights reserved.
//

import UIKit
import Lock

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signInAction(_ sender: UIButton) {
        Lock
            .classic()
            .onAuth { credentials in
                guard let _ = credentials.accessToken else { return }
                
                if let storyboard = self.storyboard {
                    let viewController = storyboard.instantiateViewController(withIdentifier: "MainNavigationViewController")
                    self.dismiss(animated: false, completion: nil)
                    self.present(viewController, animated: true, completion: nil)
                }
                
            }
            .present(from: self)
    }
}
