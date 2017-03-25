//
//  MainViewController.swift
//  DemoSwiftApp
//
//  Created by Ricardo on 24/03/17.
//  Copyright © 2017 Mobile First. All rights reserved.
//

import UIKit
import Alamofire

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var clientAppNames = [String]()
    var rules: [(name: String, script: String)] = []
    
    var domain = ""
    var cliendId = ""
    var clientSecret = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // load the domain, client id and client secret from the plist
        if let path = Bundle.main.path(forResource: "Auth0", ofType: "plist") {
            if let dictionary = NSDictionary(contentsOfFile: path) {
                domain = dictionary.value(forKey: "Domain") as! String
                cliendId = dictionary.value(forKey: "CLIClientId") as! String
                clientSecret = dictionary.value(forKey: "CLIClientSecret") as! String
            }
        }
        
        requestToken()
    }
    
    // request the access token
    // https://auth0.com/docs/api/management/v2/tokens
    func requestToken() {
        let url = "https://\(domain)/oauth/token"
        let parameters: Parameters = [
            "grant_type": "client_credentials",
            "client_id": cliendId,
            "client_secret": clientSecret,
            "audience": "https://\(domain)/api/v2/"
        ]
        
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { response in
            print(response)
            
            switch response.result {
            case .success(let data):
                guard let dataDictionary = data as? NSDictionary else { return }
                
                if let accessToken = dataDictionary["access_token"] as? String {
                    self.requestAllClients(accessToken)
                    self.requestAllRules(accessToken)
                }
                
            case .failure(let error):
                print("Failed with \(error)")
            }
            
        }
    }
    
    // request the list of clients
    // https://auth0.com/docs/api/management/v2#!/Clients/get_clients
    func requestAllClients(_ accessToken: String) {
        let url = "https://\(domain)/api/v2/clients?fields=name"
        let headers = ["Authorization" : "Bearer \(accessToken)"]
        let parameters: Parameters = [ : ]
        Alamofire.request(url, method: .get, parameters: parameters, headers: headers).responseJSON { response in
            print(response)
            
            switch response.result {
            case .success(let data):
                
                guard let dataArray = data as? [[String: Any]] else {
                    print("Failed to get data")
                    return
                }
                
                for dataItem in dataArray {
                    self.clientAppNames.append(dataItem["name"] as! String)
                }
                
                self.tableView.reloadData()
                
            case .failure(let error):
                print("Failed with \(error)")
            }
        
        }
    }
    
    // request the list of rules
    // https://auth0.com/docs/api/management/v2#!/Rules/get_rules
    func requestAllRules(_ accessToken: String) {
        let url = "https://\(domain)/api/v2/rules?fields=name,script"
        let headers = ["Authorization" : "Bearer \(accessToken)"]
        let parameters: Parameters = [ : ]
        Alamofire.request(url, method: .get, parameters: parameters, headers: headers).responseJSON { response in
            print(response)
            
            switch response.result {
            case .success(let data):
                
                guard let dataArray = data as? [[String: Any]] else {
                    print("Failed to get data")
                    return
                }
                
                for dataItem in dataArray {
                    let rule = (dataItem["name"] as! String, dataItem["script"] as! String)
                    self.rules.append(rule)
                }
                
                self.tableView.reloadData()
                
            case .failure(let error):
                print("Failed with \(error)")
            }

        }
    }
    
    @IBAction func refreshAction(_ sender: UIBarButtonItem) {
        clientAppNames.removeAll()
        rules.removeAll()
        requestToken()
    }
    
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clientAppNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClientIdentifier", for: indexPath)
        
        if let textLabel = cell.textLabel {
            textLabel.text = clientAppNames[indexPath.row]
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let storyboard = self.storyboard {
            let viewController = storyboard.instantiateViewController(withIdentifier: "RulesViewController") as! RulesViewController
            
            let clientName = clientAppNames[indexPath.row]
            if clientName != "All Applications" {
                viewController.clientName = clientName
            }
            viewController.rules = rules
            
            self.show(viewController, sender: self)
        }
    }
    
}
