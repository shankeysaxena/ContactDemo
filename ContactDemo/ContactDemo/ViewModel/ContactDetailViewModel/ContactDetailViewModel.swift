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
    
    private(set) var contactModel: Contact?
    //Handler for updating UI
    private var updateUI: (() -> ())
    var userInteractiveButtonCallback: ((AppConstants.ProfileButtonTags) -> ())?
    private(set) var isInEditMode: Bool = false {
        didSet {
            if contactViewModeType == .newContact { return }
            //If view is not in edit mode then don't show
            //first name and last name
            if isInEditMode == false {
                if self.profileItems.count == 5 {
                    //Both items are removed from 1st index as the position
                    //will get change after removing first item
                    self.profileItems.remove(at: 1)
                    self.profileItems.remove(at: 1)
                    self.updateUI()
                }
            } else {
                //Add firstname and last name cell if view is in edit mode
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
    
    /// Required initializer for initializing view model
    ///
    /// - Parameters:
    ///   - model: Contact Model
    ///   - contactViewModeType: contactViewModeType
    ///   - updationBlock: updation handler for handling UI updates
    required init(model: Contact?, contactViewModeType: ContactDetailMode, updationBlock: @escaping (() -> ())){
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
    
    
    /// Method for changing edit options
    func editOptionChanged() {
        self.isInEditMode = !self.isInEditMode
    }
}

//MARK:- Private methods
private extension ContactDetailViewModel {
    /// Method for configuring model items for detail mode
    /// NOTE:- This method will only gets called during initialization process
    func configureProfileItemsForDetailMode() {
        let name = (contactModel?.firstName ?? "") + " " + (contactModel?.lastName ?? "")
        let profileNameAndPictureItem = ProfileNameAndPictureItem(name: name, profileImageURL: contactModel?.profilePicUrl, isFavorite: contactModel?.favorite)
        profileItems.append(profileNameAndPictureItem)
        //If view is in edit mode then add first name and last name items
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

//MARK:- TableView Datasource support methods
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
                //Initializing cell with handler for handling events change
                //if there are any, in cells
                cell.configureCellFor(item: itemAtIndexPath(indexPath), contactMode: contactViewModeType) { [weak self] (isButtonTapped, buttonType) in
                    switch buttonType {
                    case .favouriteButtonTag:
                        self?.contactModel?.favorite = isButtonTapped
                        fallthrough
                    default:
                        self?.userInteractiveButtonCallback?(buttonType)
                    }
                }
                return cell
            }
        default:
            if let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.contactDetailInfoCellIdentifier, for: indexPath) as? ContactDetailInfoCell {
                //Initializing cell with handler for handling events change
                //if there are any, in cells
                cell.configureCellWith(item: itemAtIndexPath(indexPath), isInEditMode: isInEditMode) { [weak self] (changedValue, itemType) in
                    switch itemType {
                    case .emailAddress:
                        self?.contactModel?.emailAddress = changedValue
                    case .lastName:
                        self?.contactModel?.lastName = changedValue
                    case .firstName:
                        self?.contactModel?.firstName = changedValue
                    case .mobileNumber:
                        self?.contactModel?.mobileNumber = changedValue
                    case .nameAndPicture:
                        return
                    }
                }
                return cell
            }
        }
        return UITableViewCell()
    }
}
