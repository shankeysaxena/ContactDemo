//
//  ContactDetailController.swift
//  ContactDemo
//
//  Created by apple on 8/18/19.
//  Copyright © 2019 Shivam Saxena. All rights reserved.
//

import UIKit

class ContactDetailController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
         self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
}

//Tableview datasource methods
extension ContactDetailController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
}

//Tableview delegate methods
extension ContactDetailController {
    
}

//Private Methods
private extension ContactDetailController {
    
}
