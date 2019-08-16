//
//  ContactListController.swift
//  ContactDemo
//
//  Created by apple on 8/15/19.
//  Copyright © 2019 Shivam Saxena. All rights reserved.
//

import UIKit

class ContactListController: UITableViewController {

    var networkManager: NetworkManager!
    
    init(networkManager: NetworkManager) {
        super.init(nibName: nil, bundle: nil)
        self.networkManager = networkManager
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonClicked))
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.standardAppSemiboldFont, NSAttributedString.Key.foregroundColor: UIColor.contactListingTitleColor]
        navigationItem.title = "Contact"
        tableView.register(ContactListingTableViewCell.self, forCellReuseIdentifier: CellIdentifiers.contactListCellIdentifier)
        
        networkManager.getContactList()
    }

    @objc func addButtonClicked() {
       print("Add button Clicked")
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.contactListCellIdentifier, for: indexPath) as? ContactListingTableViewCell {
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(AppConstants.contactListingCellHeight)
    }

}
