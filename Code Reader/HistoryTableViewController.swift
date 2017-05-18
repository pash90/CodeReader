//
//  FirstViewController.swift
//  Code Reader
//
//  Created by Parth on 16/5/17.
//  Copyright © 2017 Parth. All rights reserved.
//

import UIKit
import RealmSwift

class HistoryTableViewController: UITableViewController {

    // Properties
    let realm = try! Realm()
    var notificationToken: NotificationToken?
    let codes = try! Realm().objects(Code.self).sorted(byKeyPath: "date")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        notificationToken = codes.addNotificationBlock({ (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                self.tableView.reloadData()
                break
                
            case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                // Query results have changed. Apply them to tableView
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.tableView.endUpdates()
                break
                
            case .error(let error):
                // An error occured while opening the Realm file on the background worker thread
                fatalError("\(error)")
                break
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return codes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scannedCode", for: indexPath)
        
        let code = codes[indexPath.row]
        cell.textLabel?.text = code.message
        cell.detailTextLabel?.text = code.date.description
        
        return cell
    }
}

