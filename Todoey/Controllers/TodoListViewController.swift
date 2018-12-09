//
//  ViewController.swift
//  Todoey
//
//  Created by Nived Pradeep on 22/11/18.
//  Copyright © 2018 Nived Pradeep. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: CellSwipeTableViewController{
   let realm = try! Realm()
    var todoItems: Results<Item>?
    
    @IBOutlet weak var searchBar: UISearchBar!
    var selectedCategory : Category?{
        didSet{
            loadItems()
        }
    }

   
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 70.0
        tableView.separatorStyle = .none
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist")}
        
        guard let colorHex =  selectedCategory?.cellColour else{ fatalError()}
            
            guard let navColour = UIColor(hexString: colorHex) else{fatalError()}
                navBar.barTintColor = navColour
                navBar.tintColor = ContrastColorOf(navColour, returnFlat: true)
                title = selectedCategory!.name
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navColour, returnFlat: true)]
                searchBar.barTintColor = navColour
            }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let originalColour = UIColor(hexString: "1D9BF6") else{fatalError()}
        navigationController?.navigationBar.barTintColor = originalColour
        navigationController?.navigationBar.tintColor = FlatMint()
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : FlatWhite()]
    }
            
        
    

    //MARK: - table view datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = todoItems?[indexPath.row]{
            if let colour = UIColor(hexString: selectedCategory!.cellColour)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat((todoItems?.count)!)){
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done == true ? .checkmark : .none
      
        }
        else{
            cell.textLabel?.text = "No Items Added"
        }
        return cell
    }
    
    
    //MARK: - Table view Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let items = todoItems?[indexPath.row]{
            do {
           try realm.write {
                items.done = !items.done
            }
            }
            catch{
                print("Error")
            }
        }
        
          tableView.reloadData()

        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //MARK: - Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var  textField = UITextField()
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            // what will happen when user presses uialert button
           print("Success")
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        currentCategory.item.append(newItem)
                    }
                   }
                catch{
                    print(error)
                }
            }
            

            self.tableView.reloadData()



        }
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "add item"
            textField = alertTextField

        }
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
//
    func loadItems(){
        todoItems = selectedCategory?.item.sorted(byKeyPath: "title", ascending: true)
      
        tableView.reloadData()
    }
    
    override func updateModel(at indexpath: IndexPath) {
        if let item = todoItems?[indexpath.row]{
            do{
              try realm.write {
                    realm.delete(item)
                }
                
            }
            catch{
                print("error")
            }
            
        }
    }
    
}
//MARK: - searchbar functionality
extension TodoListViewController : UISearchBarDelegate{

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        print("success")
        tableView.reloadData()



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
