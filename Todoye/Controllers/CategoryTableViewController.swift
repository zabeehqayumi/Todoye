//
//  CategoryTableViewController.swift
//  Todoye
//
//  Created by Zabeehullah Qayumi on 9/4/18.
//  Copyright © 2018 Zabeehullah Qayumi. All rights reserved.
//

import UIKit
import RealmSwift


class CategoryTableViewController: UITableViewController {
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet!"
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
 
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    var textField = UITextField()
    let alert = UIAlertController(title: "Add New Category", message: "PLEASE!!", preferredStyle: .alert)
        
        
    let action = UIAlertAction(title: "Add", style: .default) { (action) in
        
        let newCategory = Category()
        newCategory.name = textField.text!
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
