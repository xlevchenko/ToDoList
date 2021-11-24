//
//  ViewController.swift
//  To Do List
//
//  Created by Olexsii Levchenko on 10/22/21.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    @IBOutlet var toDoListTableView: UITableView!
    
    var ithemArray = [Item]()
    var selectCategory: Category? {
        didSet {
            loadItem()
        }
    }
    
    //Initialize CoreData (configure your code to use Core Data)
    let context = (UIApplication.shared.delegate as! AppDelegate) .persistentContainer.viewContext
    
    
    
    //let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        //Mark: - Registering a Table View Cell
        toDoListTableView.delegate = self
        toDoListTableView.dataSource = self
    }
    
    
    //MARK: - TableView DataSource Methods
    
    //Number Of Rows In Section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ithemArray.count
    }
    
    
    //The method is responsible for what should be displayed in our cells.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = toDoListTableView.dequeueReusableCell(withIdentifier: "ToDoIthemCell", for: indexPath) as! TableViewCell
        
        let item = ithemArray[indexPath.row]
        cell.taskLabel.text = item.title
        
        cell.checkMark.checkState = item.done == true ? .checked : .unchecked
        
        return cell
    }
    
    
    //MARK: - TableView Delegate Method
    
    //Tells the delegate a row is selected
    override  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
//        context.delete(ithemArray[indexPath.row])
//        ithemArray.remove(at: indexPath.row)
        
        ithemArray[indexPath.row].done = !ithemArray[indexPath.row].done
        saveItem()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
   
    //MARK: - Add New Items
    
    @IBAction func addNewItems(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //What will happen once the user clicks the Add Item button on our UIAlert."
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectCategory
            self.ithemArray.append(newItem)
            self.saveItem()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
   
    
    //MARK: - Save and load data methods
   func saveItem() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
    
    func loadItem(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        //Created our predicate which responsible for loading data that belongs to the selected category.
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectCategory!.name!)
        
        //using optional binding to make sure not nil and combining our predictors
        if let aditionPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, aditionPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            ithemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
}

//MARK: - Search Bar Methods

extension ToDoListViewController: UISearchBarDelegate {
    
    //Method executes a query to search for data by criteria and sorts them
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        //Created our predicate which specifies how we want to query our database
        let searchPredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItem(with: request, predicate: searchPredicate)
    }
    
    //If search bar did text change to zero symbol, back to original items state.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItem()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
