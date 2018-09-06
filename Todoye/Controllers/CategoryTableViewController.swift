//
//  CategoryTableViewController.swift
//  Todoye
//
//  Created by Zabeehullah Qayumi on 9/4/18.
//  Copyright © 2018 Zabeehullah Qayumi. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    var categories = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()

    }
    
    
    //MARK: - table view datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
    
    
    //MARK: - table view delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewViewController
        
       if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories[indexPath.row]
        
    }
    }

    //MARK: - Data maniputaion method
    func saveCategories(){
        do{
            try context.save()
        }catch{
            print(error)
        }
        tableView.reloadData()
        
    }
    
    func   loadCategories(){
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do{
          categories =  try context.fetch(request)
        }
        catch{
            print(error)
        }
        tableView.reloadData()
    }
 
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    var textField = UITextField()
    let alert = UIAlertController(title: "Add New Category", message: "PLEASE!!", preferredStyle: .alert)
    let action = UIAlertAction(title: "Add", style: .default) { (action) in
        
        let newCategory = Category(context: self.context)
        newCategory.name = textField.text!
        self.categories.append(newCategory)
        
        self.saveCategories()
        
    }
    alert.addAction(action)
        alert.addTextField { (field) in
        textField = field
        textField.placeholder = "Add a new category"
        }
        present(alert, animated: true, completion: nil)
        
        
    }
    
}
