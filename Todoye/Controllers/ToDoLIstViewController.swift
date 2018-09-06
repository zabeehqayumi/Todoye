//
//  ViewController.swift
//  Todoye
//
//  Created by Zabeehullah Qayumi on 9/2/18.
//  Copyright © 2018 Zabeehullah Qayumi. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewViewController: UITableViewController {
    
    var itemArray = [Item]()
    var selectedCategory : Category?{
        didSet{
            loadItems()
        }
    }
    
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist"))

        
       
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
        
//        changed the below code to above Ternary operator
//        if item.done == true{
//            cell.accessoryType = .checkmark
//        } else{
//            cell.accessoryType = .none
//        }
//
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //UPdating our database :
        
      //  itemArray[indexPath.row].setValue("Completed", forKey: "title")
        
        //removing NSObject from SQLite or persitent manager/context 
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
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
            
            let newItem = Item(context: self.context)
            newItem.title = texField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
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
    
    // save data
    
    func savedItems(){
       
        do{
            try context.save()
        }
        catch{
            print("Error saving data, \(error)")
        }
        self.tableView.reloadData()
        
    }
    
    // load data again
  
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        
        if let addtionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addtionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }
        
        
        do{
          itemArray = try context.fetch(request)
        }catch{
            print(error)
        }
        tableView.reloadData()

    }
}

extension ToDoListViewViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
 
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            
            DispatchQueue.main.async {
            searchBar.resignFirstResponder()
            }
            
        }
    }
    
}






