//
//  Contact+CoreDataProperties.swift
//  AddressBook
//
//  Created by Gary Shirk on 2/9/17.
//  Copyright © 2017 Gary Shirk. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact");
    }

    @NSManaged public var name: String?

}
