//
//  NotesItem+CoreDataProperties.swift
//  tapp
//
//  Created by Noi Berg on 26.04.2023.
//
//

import Foundation
import CoreData


extension NotesItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NotesItem> {
        return NSFetchRequest<NotesItem>(entityName: "NotesItem")
    }

    @NSManaged public var title: String?
    @NSManaged public var notes: String?

}

extension NotesItem : Identifiable {

}
