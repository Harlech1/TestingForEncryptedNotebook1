//
//  TableViewController.swift
//  Test1
//
//  Created by Turker Kizilcik on 14.08.2023.
//

import UIKit

class TableViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
  
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = "test"
        cell.contentConfiguration = content
        return cell
    }


}
