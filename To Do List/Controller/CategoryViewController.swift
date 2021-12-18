//
//  CategoryViewController.swift
//  To Do List
//
//  Created by Olexsii Levchenko on 11/15/21.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    @IBOutlet var categoryTableView: UITableView!
    
    var itemCategory: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Mark: - Registering a Table View Cell
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        
        loadCategory()
        
        tableView.rowHeight = 65.0
        
    }

    //MARK: - TableView DataSource Methods
    
    //Number Of Rows In Section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemCategory?.count ?? 1
    }
    
    
    //The method is responsible for what should be displayed in our cells.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoryTableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        
        cell.textLabel?.text = itemCategory?[indexPath.row].name ?? "No Categories Added yet"
        cell.delegate = self
        return cell
    }
    

    @IBAction func addButtonPresed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            //What will happen once the user clicks the Add Item button on our UIAlert."
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.save(category: newCategory)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create category"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Save and load data methods
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadCategory() {
        itemCategory = realm.objects(Category.self)
        tableView.reloadData()
    }

    



    //MARK: - TableView Delegate Method
    
    //Tells the delegate a row is selected
    override  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectCategory = itemCategory?[indexPath.row]
        }
    }
}

//MARK: - SwipeTableViewCellDelegate Method

extension CategoryViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            if let categoryForDelition = self.itemCategory?[indexPath.row]
            {
                do {
                    try self.realm.write {
                        self.realm.delete(categoryForDelition)
                    }
                } catch {
                    print("eror deleting object \(error)")
                }
            }
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "Trash")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
}
