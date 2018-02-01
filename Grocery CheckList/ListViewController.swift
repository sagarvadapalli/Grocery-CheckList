//
//  ListViewController.swift
//  Grocery CheckList
//
//  Created by sagar vadapalli on 6/8/17.
//  Copyright © 2017 sagar vadapalli. All rights reserved.
//
import UIKit

class ListViewController: UITableViewController, AddItemViewControllerDelegate{
    
    let CellIdentifier = "Cell Identifier"
    
    var items = [Item]()
    var selection: Item?
 
    // MARK: -
    // MARK: Initialization
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        
        // Load Items
        loadItems()
    }
    
    // MARK: -
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: items)
        // Set Title
        title = "Grocery Items"
        
        
    loadItems()
        // Register Class
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: CellIdentifier)
        
        // Create Add Button
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        
        // Create Edit Button
    /*    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editItems))
        */
        self.tableView.reloadData()
    }
   func loadList(notification: NSNotification){
        //load data here
        
        print("came")
        self.tableView.reloadData()
    }
    // MARK: -
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItemViewController" {
            if let navigationController = segue.destination as? UINavigationController,
                let addItemViewController = navigationController.viewControllers.first as? AddItemViewController {
                    addItemViewController.delegate = self
            }
            
        }    }
    
    // MARK: -
    // MARK: Table View Data Source Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue Reusable Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath)
        
        // Fetch Item
        let item = items[indexPath.row]
        
        // Configure Table View Cell
        cell.textLabel?.text = item.name
     //   cell.accessoryType = .detailDisclosureButton
        
        if item.inShoppingList {
            cell.imageView?.image = UIImage(named: "checkmark")
        } else {
            cell.imageView?.image = nil
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete Item from Items
           items.remove(at: indexPath.row)
            
            // Update Table View
           tableView.deleteRows(at: [indexPath], with: .right)
            
            // Save Changes
            saveItems()
        }
    }
    
    // MARK: -
    // MARK: Table View Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Fetch Item
        let item = items[indexPath.row]
        
        // Update Item
        item.inShoppingList = !item.inShoppingList
        
        // Update Cell
        let cell = tableView.cellForRow(at: indexPath)
        
        if item.inShoppingList {
            cell?.imageView?.image = UIImage(named: "checkmark")
            cell?.separatorInset.left = 20
           // cell?.textLabel?.textColor = UIColor.green
        } else {
            cell?.imageView?.image = nil
            cell?.separatorInset.left = 20
            
          //  cell?.layoutMargins = UIEdgeInsets.zero
        }
        
        // Save Items
        saveItems()
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        // Fetch Item
        let item = items[indexPath.row]
        
        // Update Selection
        selection = item
        
        // Perform Segue
        performSegue(withIdentifier: "EditItemViewController", sender: self)
    }
    
    // MARK: -
    // MARK: Add Item View Controller Delegate Methods
    func controller(_ controller: AddItemViewController, didSaveItemWithName name: String, andPrice price: Float) {
        // Create Item
        let item = Item(name: name, price: price)
        
        // Add Item to Items
        items.append(item)
        
        // Add Row to Table View
        tableView.insertRows(at: [IndexPath(row: (items.count - 1), section: 0)], with: .none)
        
        // Save Items
        saveItems()
    }
    
  
    
    // MARK: -
    // MARK: Actions
    func addItem(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "AddItemViewController", sender: self)
    }
    
/*    func editItems(_ sender: UIBarButtonItem) {
        tableView.setEditing(!tableView.isEditing, animated: true)
    }*/
    
    // MARK: -
    // MARK: Helper Methods
    fileprivate func loadItems() {
        if let filePath = pathForItems(), FileManager.default.fileExists(atPath: filePath) {
            if let archivedItems = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [Item] {
                items = archivedItems
            }
        }
    }
    
    fileprivate func saveItems() {
        if let filePath = pathForItems() {
            NSKeyedArchiver.archiveRootObject(items, toFile: filePath)
            
            // Post Notification
            NotificationCenter.default.post(name: Notification.Name(rawValue: "ShoppingListDidChangeNotification"), object: self)
        }
    }
    
    fileprivate func pathForItems() -> String? {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        
        if let documents = paths.first, let documentsURL = URL(string: documents) {
            return documentsURL.appendingPathComponent("items").path
        }
        
        return nil
    }

}
