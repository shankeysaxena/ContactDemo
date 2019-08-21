//
//  ContactDetailController.swift
//  ContactDemo
//
//  Created by apple on 8/18/19.
//  Copyright © 2019 Shivam Saxena. All rights reserved.
//

import UIKit
import MessageUI

enum ContactDetailMode {
    case newContact
    case contactDetail
}

class ContactDetailController: UITableViewController {

    fileprivate var contactMode: ContactDetailMode!
    fileprivate var networkManager: NetworkManager!
    private var tapGesture: UITapGestureRecognizer!
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
        configureBottomButtons()
        if contactMode == .contactDetail {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonClicked))
        }
        configureTableView()
        fetchDetailData()
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    deinit {
        view.removeGestureRecognizer(tapGesture)
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

//Private Methods
private extension ContactDetailController {
    
    @objc func handleTapGesture() {
        view.endEditing(true)
    }
    
    func configureTableView() {
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        tableView.register(UINib.init(nibName: "ContactBasicProfileCell", bundle: Bundle.main), forCellReuseIdentifier: CellIdentifiers.contactBasicProfileCellIdentifier)
        tableView.register(UINib.init(nibName: "ContactDetailInfoCell", bundle: Bundle.main), forCellReuseIdentifier: CellIdentifiers.contactDetailInfoCellIdentifier)
    }
    
    func configureBottomButtons() {
        view.addSubview(doneButton)
        doneButton.anchor(top: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .zero, viewSize: CGSize(width: 0, height: 50))
    }
    
    @objc func doneButtonTapped() {
        view.endEditing(true)
        guard let contactModel = contactModel, let _ = contactModel.firstName, let _ = contactModel.lastName else {
            self.showAlert("Please enter atleast first and last name to add contact")
            return
        }
        networkManager.addNewContactWith(contactModel: contactModel) { [weak self] responseString in
            self?.showAlertView(nil, message: responseString, cancelButtonTitle: "OK", handler: { (handler) in
                self?.navigationController?.popViewController(animated: true)
            })
        }
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
            strongSelf.viewModel?.userInteractiveButtonCallback = { [weak strongSelf] buttonType in
                strongSelf?.handleUserInteractionFor(buttonType: buttonType)
            }
        }
    }
    
    func handleUserInteractionFor(buttonType: AppConstants.ProfileButtonTags) {
        switch buttonType {
        case .callButtonTag:
            guard let mobileNumber = contactModel?.mobileNumber else { return }
            dialNumber(number: mobileNumber)
        case .messageButtonTag:
            handleMessageTap()
        case .emailButtonTag:
            handleMailButtonTapped()
        case .favouriteButtonTag:
            break
        }
    }
    
    //MARK:- User Interaction button action
    func handleMessageTap() {
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = "Message Body"
            controller.messageComposeDelegate = self
            present(controller, animated: true, completion: nil)
        } else {
            showAlert("Can't send message")
        }
    }
    
    func dialNumber(number : String) {
        if let url = URL(string: "tel://\(number)"),
            UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            showAlert("Can't dial a number")
        }
    }
    
    func handleMailButtonTapped() {
        let mailComposerController = configureMailComposer()
        if MFMailComposeViewController.canSendMail() {
            present(mailComposerController, animated: true, completion: nil)
        } else {
            showAlert("Can't send mail")
        }
    }
    
    func configureMailComposer() -> MFMailComposeViewController{
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setSubject("Greeting of the day")
        return mailComposeVC
    }
}

extension ContactDetailController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
}

extension ContactDetailController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        dismiss(animated: true, completion: nil)
    }
}
