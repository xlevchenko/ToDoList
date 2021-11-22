//
//  CategoryViewController.swift
//  To Do List
//
//  Created by Olexsii Levchenko on 11/15/21.
//

import UIKit
import CoreData

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
        
        loadCategory()
        
    }

    //MARK: - TableView DataSource Methods
    
    //Number Of Rows In Section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemCategory.count
    }
    
    
    //The method is responsible for what should be displayed in our cells.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoryTableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryTableViewCell
        
        cell.categoryLabel.text = itemCategory[indexPath.row].name
        
        return cell
    }
    

    @IBAction func addButtonPresed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            //What will happen once the user clicks the Add Item button on our UIAlert."
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            self.itemCategory.append(newCategory)
            self.saveCategory()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create category"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - Save and load data methods
    func saveCategory() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadCategory(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            itemCategory = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }



    //MARK: - TableView Delegate Method
    
    //Tells the delegate a row is selected
    override  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
