//
//  DataManager.swift
//  tapp
//
//  Created by Noi Berg on 27.04.2023.
//

import UIKit

class DataManager: UIViewController {}


// MARK: - Core Data Manager
extension DataManager {
    static func getAllItems() {
        do {
            Model.items = try MainViewController.context.fetch(NotesItem.fetchRequest())
            DispatchQueue.main.async {
                MainViewController.tableView.reloadData()
            }
        }
        catch {
            fatalError(error.localizedDescription)
        }
    }
    
   static func createItems(title: String, notes: String) {
        let newItem = NotesItem(context: MainViewController.context)
        newItem.title = title
        newItem.notes = notes
        do {
            try? MainViewController.context.save()
            DataManager.getAllItems()
        }
    }
    
    static func deleteItems(item: NotesItem) {
       MainViewController.context.delete(item)
        do {
            try? MainViewController.context.save()
            DataManager.getAllItems()
        }
    }
    
   static func updateItems(item: NotesItem, newNotes: String) {
        item.notes = newNotes
        do {
            try? MainViewController.context.save()
            DataManager.getAllItems()
        }
    }
    
}
