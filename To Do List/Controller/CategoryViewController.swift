//
//  CategoryViewController.swift
//  To Do List
//
//  Created by Olexsii Levchenko on 11/15/21.
//

import UIKit

class CategoryViewController: UITableViewController {
    
    @IBOutlet var categoryTableView: UITableView!
    
    var itemCategory = [Category]()
    
    //Initialize CoreData (configure your code to use Core Data)
    let context = (UIApplication.shared.delegate as! AppDelegate) .persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Mark: - Registering a Table View Cell
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
    }

    //MARK: - TableView DataSource Methods
    
    //Number Of Rows In Section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemCategory.count
    }
    
    
    //The method is responsible for what should be displayed in our cells.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoryTableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! TableViewCell
        
        let item = itemCategory[indexPath.row]
        cell.taskLabel.text = item.name
        
        //cell.checkMark.checkState = item.done == true ? .checked : .unchecked
        
        return cell
    }
    

    @IBAction func addButtonPresed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            //What will happen once the user clicks the Add Item button on our UIAlert."
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            self.itemCategory.append(newCategory)
            //self.saveItem()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}

