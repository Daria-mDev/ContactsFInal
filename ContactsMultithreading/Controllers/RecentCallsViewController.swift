//
//  RecentCallsViewController.swift
//  ContactsMultithreading
//
//  Created by user on 03.04.2021.
//
import UIKit
import Foundation

class RecentCallsViewController: UIViewController {
    @IBOutlet var recentCallsTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recentCallsTableView.delegate = self
        recentCallsTableView.dataSource = self
        recentCallsTableView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        recentCallsTableView.reloadData()
    }
    
}

extension RecentCallsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RecentCallsList.recentCalls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "callsCell", for: indexPath)
        let call = RecentCallsList.recentCalls[indexPath.row]
        
        if call.firstName != nil {
            cell.textLabel?.text = call.firstName
        }
        else {
            cell.textLabel?.text = call.phone
        }
        cell.detailTextLabel?.text = call.time
        return cell
    }
}
