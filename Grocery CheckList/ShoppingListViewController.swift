//
//  ShoppingListViewController.swift
//  Grocery CheckList
//
//  Created by sagar vadapalli on 6/8/17.
//  Copyright © 2017 sagar vadapalli. All rights reserved.
//

import UIKit

class ShoppingListViewController: UITableViewController {
 
 

   var quantity = [String]()
    
    var itemName = [String]()
    
    
    let CellIdentifier = "Cell"
  
    var items = [Item]() {
        didSet {
            buildShoppingList()
        }
    }
    
    var shoppingList = [Item]() {
        didSet {
            tableView.reloadData()
        }
    }
 
    // MARK: -
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Title
        title = "Shopping List"
        
        // Load Items
        loadItems()
        
        // Register Class
    //    tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier)
        
        // Add Observer
        NotificationCenter.default.addObserver(self, selector: #selector(updateShoppingList), name: NSNotification.Name(rawValue: "ShoppingListDidChangeNotification"), object: nil)
    }
    
    // MARK: -
    // MARK: Table View Data Source Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue Reusable Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath) as! ViewControllerTableViewCell
        // Fetch Item
        let item = shoppingList[indexPath.row]
        print(item.name)
        // Configure Table View Cell
      //  cell.textLabel?.text = item.name
        cell.Items.text = item.name
       // quantity.append(cell.txt)
      //  cell.txt.text = "1"
       
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {

    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

    }


    
    
    @IBAction func Share(_ sender: Any) {
        var string1 = ""
      
        let cells = self.tableView.visibleCells as! Array<ViewControllerTableViewCell>
        
        for cell in cells {
            // look at data
            quantity.append(String(cell.txt.text!))
            
            itemName.append(String(cell.Items.text!))
            
            
        }
        
    
  

    for (i,k) in zip(itemName, quantity){
     
        print("\(i):\t\(k)")
            string1.append("\(i):  \(k)\n")
        }
       
        let activityVC = UIActivityViewController(activityItems: [string1], applicationActivities: nil)
       
        activityVC.popoverPresentationController?.sourceView = self.view
        
        self.present(activityVC, animated: true, completion: nil)
        
        quantity.removeAll()
        itemName.removeAll()
      
        
    }
    
    // MARK: -
    // MARK: Notification Handling
    func updateShoppingList(_ notification: Notification) {
        loadItems()
    }
    
    // MARK: -
    // MARK: Helper Methods
    func buildShoppingList() {
        shoppingList = items.filter({ (item) -> Bool in
            return item.inShoppingList
        })
    }

    fileprivate func loadItems() {
        if let filePath = pathForItems(), FileManager.default.fileExists(atPath: filePath) {
            if let archivedItems = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [Item] {
                items = archivedItems
            }
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
