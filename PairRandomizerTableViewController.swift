//
//  PairRandomizerTableViewController.swift
//  PairRandomizer
//
//  Created by Nate Dukatz on 8/29/17.
//  Copyright © 2017 NateDukatz. All rights reserved.
//

import UIKit

class PairRandomizerTableViewController: UITableViewController {
    
    let pairListController = PairListController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func addItemButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Add New Item", message: "Type your item here", preferredStyle: .alert)
        
        alertController.addTextField { (newTextField: UITextField) in
            newTextField.placeholder = "Item Name"
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alertController.addAction(UIAlertAction(title: "Save", style: .default, handler: { (_ : UIAlertAction) in
            
            if let nameTextField = alertController.textFields?.first {
                let name = nameTextField.text ?? ""

                let _ = self.pairListController.create(PairListItemWithName: name)
                
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        guard let numberOfObjects = pairListController.fetchedResultsController.fetchedObjects?.count else { return 0 }
        
        if numberOfObjects % 2 == 0 {
            return numberOfObjects/2
        } else {
            return numberOfObjects/2 + 1
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
