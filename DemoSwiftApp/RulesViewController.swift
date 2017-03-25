//
//  RulesViewController.swift
//  DemoSwiftApp
//
//  Created by Ricardo on 25/03/17.
//  Copyright © 2017 Mobile First. All rights reserved.
//

import UIKit

class RulesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var clientName = ""
    var rules: [(name: String, script: String)] = []
    var clientRules: [(name: String, script: String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Rules"
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        for rule in rules {
            if clientName.characters.count == 0 || rule.script.contains(clientName) {
                clientRules.append(rule)
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clientRules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RuleIdentifier", for: indexPath)
        
        let rule = clientRules[indexPath.row]
        
        if let textLabel = cell.textLabel {
            textLabel.text = rule.name
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let storyboard = self.storyboard {
            let viewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            
            viewController.detailRule = clientRules[indexPath.row]
            
            self.show(viewController, sender: self)
        }
    }
    
}
