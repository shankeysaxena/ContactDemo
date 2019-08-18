//
//  ContactListController.swift
//  ContactDemo
//
//  Created by apple on 8/15/19.
//  Copyright © 2019 Shivam Saxena. All rights reserved.
//

import UIKit

class ContactListController: UITableViewController {

    private var networkManager: NetworkManager!
    private var viewModel: ContactViewModel? {
        didSet {
            DispatchQueue.main.async {self.tableView.reloadData()}
        }
    }
    
    init(networkManager: NetworkManager) {
        super.init(nibName: nil, bundle: nil)
        self.networkManager = networkManager
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.cellBackgroundColor
        configureNavigationItem()
        configureTableView()
        fetchContactList()
    }

    @objc func addButtonClicked() {
       print("Add button Clicked")
    }

}

//MARK:- Tableview datasource methods
extension ContactListController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.numberOfSections() ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRowsAt(section: section) ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.contactListCellIdentifier, for: indexPath) as? ContactListingTableViewCell {
            let contactItem = viewModel?.itemAtIndexPath(indexPath)
            cell.configureCellWith(contactItem)
            return cell
        }
        return UITableViewCell()
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return viewModel?.sectionIndexTitle()
    }
}

//MARK:- Tableview delegate methods
extension ContactListController {
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(AppConstants.CustomiseUIHeights.contactListingHeaderHeight)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(AppConstants.CustomiseUIHeights.contactListingCellHeight)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.backgroundColor = UIColor.listingHeaderColor
        label.text = viewModel?.titleForHeader(section: section)
        return label
    }
}

//MARK:- Private Methods
private extension ContactListController {
    func configureNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonClicked))
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.standardAppSemiboldFont, NSAttributedString.Key.foregroundColor: UIColor.contactListingTitleColor]
        navigationItem.title = "Contact"
    }
    
    func configureTableView() {
        tableView.register(ContactListingTableViewCell.self, forCellReuseIdentifier: CellIdentifiers.contactListCellIdentifier)
        tableView.separatorStyle = .none
        tableView.sectionIndexColor = .lightGray
    }
    
    func fetchContactList() {
        Loader.addLoaderOn(view)
        networkManager.getContactListWith { [weak self] (contactList, errorString) in
            Loader.removeLoaderFrom(self?.view)
            if let errorString = errorString {
                self?.showAlert(errorString)
                return
            } else {
                self?.viewModel = ContactViewModel(contactList: contactList)
            }
        }
    }
}
