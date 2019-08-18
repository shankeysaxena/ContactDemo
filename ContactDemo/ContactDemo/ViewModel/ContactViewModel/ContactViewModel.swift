//
//  ContactViewModel.swift
//  ContactDemo
//
//  Created by apple on 8/16/19.
//  Copyright © 2019 Shivam Saxena. All rights reserved.
//

import Foundation
import UIKit

struct Section {
    let letter: String
    let contactNames: [Contact]?
}

final class ContactViewModel: NSObject {
    
    //private(set) var contactList: [Contact] = [Contact]()
    private var sections: [Section]?
    
    required init(contactList: [Contact]?) {
        guard let contactList = contactList else {return}
        let groupedDictionary = Dictionary(grouping: contactList) { String($0.firstName?.prefix(1) ?? "No Value")}
        // get the keys and sort them
        let keys = groupedDictionary.keys.sorted()
        // map the sorted keys to a struct
        sections = keys.map({ (keyName) -> Section in
            Section(letter: keyName, contactNames: groupedDictionary[keyName]?.sorted{ (initial, next) -> Bool in
                    return initial.firstName?.compare(next.firstName ?? "") == .orderedAscending
                })
        })
    }
}

//TableView Support
extension ContactViewModel {
    
    func sectionIndexTitle() -> [String]? {
        return sections?.map{ $0.letter }
    }
    
    func titleForHeader(section: Int) -> String? {
        return sections?[section].letter
    }
    
    func numberOfSections() -> Int {
        return sections?.count ?? 0
    }
    
    func numberOfRowsAt(section: Int) -> Int {
        return sections?[section].contactNames?.count ?? 0
    }
    
    func itemAtIndexPath(_ indexPath: IndexPath) -> Contact? {
        return sections?[indexPath.section].contactNames?[indexPath.row]
    }
}
