//
//  ContactDetailViewModel.swift
//  ContactDemo
//
//  Created by apple on 8/18/19.
//  Copyright © 2019 Shivam Saxena. All rights reserved.
//

import Foundation
import UIKit

final class ContactDetailViewModel {
    
    private var contactModel: Contact?
    
    private var updateUI: (() -> ())
    
    private(set) var isInEditMode: Bool = false {
        didSet {
            if contactViewModeType == .newContact { return }
            if isInEditMode == false {
                if self.profileItems.count == 5 {
                    //Both items are removed from 1st index as the position
                    //will get change after removing first item
                    self.profileItems.remove(at: 1)
                    self.profileItems.remove(at: 1)
                    self.updateUI()
                }
            } else {
                let firstNameItem = ProfileFirstNameItem(firstName: contactModel?.firstName)
                let lastNameItem = ProfileLastNameItem(lastName: contactModel?.lastName)
                self.profileItems.insert(firstNameItem, at: 1)
                self.profileItems.insert(lastNameItem, at: 2)
                self.updateUI()
            }
        }
    }
    private(set) var contactViewModeType: ContactDetailMode
    private var profileItems = [ProfileViewModelItem]()
    
    required init(model: Contact?, contactViewModeType: ContactDetailMode, updationBlock: @escaping (() -> ())) {
        self.contactModel = model
        self.contactViewModeType = contactViewModeType
        self.updateUI = updationBlock
        if self.contactViewModeType == .newContact {
            //Initializing Profile items with default value
            profileItems = [ProfileNameAndPictureItem(), ProfileFirstNameItem(), ProfileLastNameItem(), ProfileMobileNumberItem(), ProfileEmailAddressItem()]
            return
        }
        configureProfileItemsForDetailMode()
    }
    
    func editOptionChanged() {
        self.isInEditMode = !self.isInEditMode
    }
}

private extension ContactDetailViewModel {
    
    func configureProfileItemsForDetailMode() {
        let name = (contactModel?.firstName ?? "") + " " + (contactModel?.lastName ?? "")
        let profileNameAndPictureItem = ProfileNameAndPictureItem(name: name, profileImageURL: contactModel?.profilePicUrl)
        profileItems.append(profileNameAndPictureItem)
        if isInEditMode == true {
            let firstNameItem = ProfileFirstNameItem(firstName: contactModel?.firstName)
            let lastNameItem = ProfileLastNameItem(lastName: contactModel?.lastName)
            profileItems += [firstNameItem, lastNameItem]
        }
        let phoneNumberItem = ProfileMobileNumberItem(mobileNumber: contactModel?.mobileNumber ?? "")
        let emailAddressItem = ProfileEmailAddressItem(emailAddress: contactModel?.emailAddress ?? "")
        profileItems += [phoneNumberItem, emailAddressItem]
    }
}

extension ContactDetailViewModel {
    
    func numberOfRows() -> Int {
        return profileItems.count
    }
    
    func itemAtIndexPath(_ indexPath: IndexPath) -> ProfileViewModelItem? {
        if indexPath.row <= (profileItems.count - 1) {
            return profileItems[indexPath.row]
        } else { return nil }
    }

    func cellForRowAt(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.contactBasicProfileCellIdentifier, for: indexPath) as? ContactBasicProfileCell {
                cell.configureCellFor(item: itemAtIndexPath(indexPath), contactMode: contactViewModeType)
                return cell
            }
        default:
            if let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.contactDetailInfoCellIdentifier, for: indexPath) as? ContactDetailInfoCell {
                cell.configureCellWith(item: itemAtIndexPath(indexPath), isInEditMode: isInEditMode)
                return cell
            }
        }
        return UITableViewCell()
    }
}
