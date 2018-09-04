//
//  ViewController.swift
//  Todoye
//
//  Created by Zabeehullah Qayumi on 9/2/18.
//  Copyright © 2018 Zabeehullah Qayumi. All rights reserved.
//

import UIKit

class ToDoListViewViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    // firs set user defaults
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
        
       
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        // Ternary operator
        
        cell.accessoryType = item.done == true ? .checkmark: .none
//        change the below code to above Ternary operator
//        if item.done == true{
//            cell.accessoryType = .checkmark
//        } else{
//            cell.accessoryType = .none
//        }
//
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        savedItems()

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK - Add new items buttons :
    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var texField = UITextField()
        
        let alert = UIAlertController(title: "Add New Items", message: "Please add your new items", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what happens when user clicks the add button
            let newItem = Item()
            newItem.title = texField.text!
           self.itemArray.append(newItem)
            
      
            //Calling the mothod
            self.savedItems()
            
           
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new items"
            texField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // Encoding data
    
    func savedItems(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }
        catch{
            print("Error encoding item array, \(error)")
            
        }
        
        self.tableView.reloadData()
        
    }
    // Decoding data
    
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
            itemArray = try decoder.decode([Item].self, from: data)
            }catch{
                print("Error encoding item array, \(error)")
            }
        }
        
    }
    
    
}

