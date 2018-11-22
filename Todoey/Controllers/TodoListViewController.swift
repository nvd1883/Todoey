//
//  ViewController.swift
//  Todoey
//
//  Created by Nived Pradeep on 22/11/18.
//  Copyright © 2018 Nived Pradeep. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController{
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loadData()
//        if let items  = defaults.array(forKey: "TodoListArray") as? [Item]{
//            itemArray = items
//        }
    }

//MARK - table view datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        //Ternary Operator
        // value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        return cell
    }
    // Table view Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItem()
       //MARK - print("you have selected\(itemArray[indexPath.row])")
         
//        if  tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }
//        else{
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }

        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //MARK - Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var  textField = UITextField()
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            // what will happen when user presses uialert button
           print("Success")
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
            self.saveItem()
            
//            do{
//           let data = try encoder.encode(self.itemArray)
//                try data.write(to: self.dataFilePath!)
//            }
//            catch{
//                print(error)
//            }
//            self.tableView.reloadData()
            
        }
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "add item"
            textField = alertTextField
           
        }
        self.present(alert, animated: true, completion: nil)
    }
    func saveItem(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }
        catch{
            print(error)
        }
        tableView.reloadData()
    }
    
    func loadData(){
        
        do{
            if let data = try? Data(contentsOf: dataFilePath!){
                let decoder = PropertyListDecoder()
                do{
                    itemArray = try decoder.decode([Item].self, from: data)
                }
                catch{
                    print(error)
                }
                
            }
            
        }
       
    }
}

