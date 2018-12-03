//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Nived Pradeep on 27/11/18.
//  Copyright © 2018 Nived Pradeep. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    let realm = try! Realm()
    var category : Results<Category>!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCategoryCell", for : indexPath)
        
        cell.textLabel?.text = category?[indexPath.row].name ?? "No category added"
        return cell
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = category?[indexPath.row]
        }
    }
   
    
    
    func save(category : Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }
        catch{
            print("Error saving\(error)")
        }
        tableView.reloadData()
    }
    //Mark: - Load items
    
    func loadCategory() {
        category = realm.objects(Category.self)
        tableView.reloadData()
    }

    
    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Category" , message: "", preferredStyle:.alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            self.save(category: newCategory)
        
        }
        
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "add category"
            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)
        
    }
    
    
}
