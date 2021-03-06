//
//  PairRandomizerTableViewController.swift
//  PairRandomizer
//
//  Created by Nate Dukatz on 8/29/17.
//  Copyright © 2017 NateDukatz. All rights reserved.
//

import UIKit
import CoreData

class PairRandomizerTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PairListController.shared.fetchedResultsController.delegate = self
    }
    
    // MARK: - Randomize button
    
    @IBAction func randomizeButtonTapped(_ sender: Any) {
        randomizer()
    }
    
    // MARK: - Add Item function
    
    @IBAction func addItemButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Add New Item", message: "Type your item here", preferredStyle: .alert)
        
        alertController.addTextField { (newTextField: UITextField) in
            newTextField.placeholder = "Item Name"
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alertController.addAction(UIAlertAction(title: "Save", style: .default, handler: { (_ : UIAlertAction) in
            
            if let nameTextField = alertController.textFields?.first {
                let name = nameTextField.text ?? ""
                
                guard let count = PairListController.shared.fetchedResultsController.fetchedObjects?.count else { return }
                var group = 0
                
                if count > 1 {
                    
                    guard let lastObjectGroup = PairListController.shared.fetchedResultsController.fetchedObjects?[count - 1] else { return }
                    guard let twoAgoObjectGroup = PairListController.shared.fetchedResultsController.fetchedObjects?[count - 2] else { return }
                    //guard let currentGroup = PairListController.shared.fetchedResultsController.fetchedObjects?[count] else { return }
                    if lastObjectGroup.group == twoAgoObjectGroup.group {
                        group = Int(lastObjectGroup.group + Int16(1))
                    } else {
                        group = Int(lastObjectGroup.group)
                    }
                } else {
                    
                    group = 1
                }
                
                PairListController.shared.create(PairListItemWithName: name, group: Int16(group))
                
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: - Table view data source/delegate methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        //guard let numberOfObjects = PairListController.shared.fetchedResultsController.fetchedObjects?.count else { return 0 }
        
        //        if numberOfObjects == 0 {
        //            return 1
        //        } else if numberOfObjects % 2 == 0 {
        //            return numberOfObjects/2
        //        } else {
        //
        //            return numberOfObjects/2 + 1
        //        }
        
        let frc = PairListController.shared.fetchedResultsController
        if let sections = frc.sections {
            return sections.count
            
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //        guard let numberOfObjects = PairListController.shared.fetchedResultsController.fetchedObjects?.count else { return 0 }
        //
        //        if numberOfObjects/2 == section {
        //            return numberOfObjects % 2
        //        } else {
        //            return 2
        //        }
        
        guard let sections = PairListController.shared.fetchedResultsController.sections else { fatalError("No sections in fetchedResultsController") }
        
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PairListItemCell", for: indexPath) as? PairListItemTableViewCell else { return PairListItemTableViewCell() }
        
        //        let index = indexPath.section * 2 + indexPath.row
        //
        //        guard let pairList = PairListController.shared.fetchedResultsController.fetchedObjects else { return cell }
        //
        //        let pairListItem = pairList[index]
        //
        //        cell.update(pairListItem: pairListItem)
        
        let pairListItem = PairListController.shared.fetchedResultsController.object(at: indexPath)
        
        //pairListItem.group = Int64(indexPath.section * 2 + indexPath.row)
        
        cell.update(pairListItem: pairListItem)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Group \(section + 1)"
    }
    
    // MARK: - Randomizer Function
    
    func randomizer() {
        
        guard let currentArray = PairListController.shared.fetchedResultsController.fetchedObjects else { return }
        var currentOrder = currentArray
        
        var newOrder = [Int16]()
        
        for _ in currentOrder {
            
            let randomIndex = Int16(arc4random_uniform(UInt32(currentOrder.count)))
            
            let randomObject = currentOrder[Int(randomIndex)]
            
            currentOrder.remove(at: Int(randomIndex))
            
            newOrder.append(randomObject.group)
            
        }
        
        for (index, item) in newOrder.enumerated() {
            
            guard let pairListItem = PairListController.shared.fetchedResultsController.fetchedObjects?[index] else { return }
            pairListItem.group = item
            
            
        }
        
        PairListController.shared.saveToPersistentStorage()
        tableView.reloadData()
    }
    
    
    // MARK: - Fetched Results controller methods
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
            
        }
    }
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    
}
