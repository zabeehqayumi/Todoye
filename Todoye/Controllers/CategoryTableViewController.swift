//
//  CategoryTableViewController.swift
//  Todoye
//
//  Created by Zabeehullah Qayumi on 9/4/18.
//  Copyright © 2018 Zabeehullah Qayumi. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework




class CategoryTableViewController: SwipeTableTableViewController {
    
    let realm = try! Realm()
    
    var categories : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//                print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist"))
//
//          
        
       loadCategories()
    

    }
    
    
    //MARK: - table view datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Nil Coaliscing Operator.
        return categories?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let category = categories?[indexPath.row]{
            
            cell.textLabel?.text = category.name
            
            guard let categoryColour = UIColor(hexString: category.colour) else {fatalError()}
            cell.backgroundColor = categoryColour
            cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)


        }
   
        return cell
    }
    
    
    //MARK: - table view delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewViewController
        
       if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories?[indexPath.row]
        
    }
    }

    //MARK: - Data maniputaion method
    func save(category: Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print(error)
        }
        tableView.reloadData()
        
    }
    
    func   loadCategories(){
        
        categories = realm.objects(Category.self)

        tableView.reloadData()
    }
    
    //MARK: - Delete data from swipe
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            }
                catch{
                    print("Error")
                
            }
        }
    }
 
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    var textField = UITextField()
    let alert = UIAlertController(title: "Add New Category", message: "PLEASE!!", preferredStyle: .alert)
        
        
    let action = UIAlertAction(title: "Add", style: .default) { (action) in
        
        let newCategory = Category()
        newCategory.name = textField.text!
        newCategory.colour = UIColor.randomFlat.hexValue()
        
        self.save(category: newCategory)
        
    }
    alert.addAction(action)
        alert.addTextField { (field) in
        textField = field
        textField.placeholder = "Add a new category"
        }
        present(alert, animated: true, completion: nil)
        
        
    }
    
}

