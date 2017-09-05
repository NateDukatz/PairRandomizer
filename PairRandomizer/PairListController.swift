//
//  PairListController.swift
//  PairRandomizer
//
//  Created by Nate Dukatz on 8/29/17.
//  Copyright © 2017 NateDukatz. All rights reserved.
//

import Foundation
import CoreData

struct PairListController {
    
    static let shared = PairListController()
    
    let fetchedResultsController: NSFetchedResultsController<PairListItem>
    
    
    
    init() {
        
        let fetchRequest: NSFetchRequest<PairListItem> = PairListItem.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "group", ascending: true)]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: "group", cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            NSLog("Error fetching Pair list items")
        }
    }
    
    func create(PairListItemWithName name: String, group: Int16) {
        let _ = PairListItem(name: name, group: group)
        
        saveToPersistentStorage()
    }
    
    func delete(pcItemList: PairListItem) {
        
        if let moc = pcItemList.managedObjectContext {
            moc.delete(pcItemList)
        }
        
        saveToPersistentStorage()
    }
    
    func saveToPersistentStorage() {
        let moc = CoreDataStack.context
        
        do {
            try moc.save()
        } catch let error {
            print("Couldn't save to persistent Store \(error)")
        }
    }
}

