//
//  ContactDetailController.swift
//  ContactDemo
//
//  Created by apple on 8/18/19.
//  Copyright © 2019 Shivam Saxena. All rights reserved.
//

import UIKit

enum ContactDetailMode {
    case newContact
    case contactDetail
}

class ContactDetailController: UITableViewController {

    private var contactMode: ContactDetailMode!
    fileprivate var networkManager: NetworkManager!
    private var contactModel: Contact?
    private var viewModel: ContactDetailViewModel? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    lazy var doneButton: UIButton = {
       let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.backgroundColor = UIColor.themeColor
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        return button
    }()

    init(contactMode: ContactDetailMode, contactModel: Contact?, networkManager: NetworkManager) {
        super.init(nibName: nil, bundle: nil)
        self.contactMode = contactMode
        self.contactModel = contactModel
        self.networkManager = networkManager
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.defaultBackgroundColor
        configureDoneButton()
        if contactMode == .contactDetail {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonClicked))
        }
        configureTableView()
        fetchDetailData()
    }
}

//MARK:- Tableview datasource methods
extension ContactDetailController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return viewModel?.numberOfRows() ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel?.cellForRowAt(tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
    }
}

//MARK:- Tableview delegate methods
extension ContactDetailController {
    
}

//Private Methods
private extension ContactDetailController {
    
    func configureDoneButton() {
        view.addSubview(doneButton)
        doneButton.anchor(top: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .zero, viewSize: CGSize(width: 0, height: 50))
    }
    
    @objc func doneButtonTapped() {
        print("Done button tapped")
    }
    
    @objc func editButtonClicked() {
        viewModel?.editOptionChanged()
        navigationItem.rightBarButtonItem?.title = (viewModel?.isInEditMode ?? false) ? "Cancel" : "Edit"
    }
    
    func fetchDetailData() {
        if contactMode == .newContact {
            viewModel = ContactDetailViewModel(model: nil, contactViewModeType: .newContact, updationBlock: { [weak self] in
                self?.tableView.reloadData()
            })
            viewModel?.editOptionChanged()
            return
        }
        //If Email Address and MobileNumber are already fetched then don't fetch it again
//        if contactModel?.emailAddress != nil && contactModel?.mobileNumber != nil {
//            viewModel = ContactDetailViewModel(model: contactModel, contactViewModeType: contactMode)
//            return
//        }
        Loader.addLoaderOn(view)
        networkManager.getContactListWith(type: .contactDetail(id: contactModel?.profileId ?? 0)) { [weak self] (contactList, errorString) in
            guard let strongSelf = self else {
                return
            }
            Loader.removeLoaderFrom(strongSelf.view)
            if let errorString = errorString {
                strongSelf.showAlert(errorString)
            } else {
                if let contact = contactList?.first {
                    strongSelf.contactModel = contact
                }
            }
            
            strongSelf.viewModel = ContactDetailViewModel(model: strongSelf.contactModel, contactViewModeType: strongSelf.contactMode, updationBlock: { [weak strongSelf] in
                strongSelf?.tableView.reloadData()
            })
        }
    }
    
    func configureTableView() {
        tableView.separatorStyle = .none
        tableView.register(UINib.init(nibName: "ContactBasicProfileCell", bundle: Bundle.main), forCellReuseIdentifier: CellIdentifiers.contactBasicProfileCellIdentifier)
        tableView.register(UINib.init(nibName: "ContactDetailInfoCell", bundle: Bundle.main), forCellReuseIdentifier: CellIdentifiers.contactDetailInfoCellIdentifier)
    }
}
