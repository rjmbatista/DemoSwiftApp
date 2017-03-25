//
//  DetailViewController.swift
//  DemoSwiftApp
//
//  Created by Ricardo on 25/03/17.
//  Copyright © 2017 Mobile First. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var detailRule: (name: String, script: String)?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let rule = detailRule {
            titleLabel.text = rule.name
            detailTextView.text = rule.script
        }
    }
}
