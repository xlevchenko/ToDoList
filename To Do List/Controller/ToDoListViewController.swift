//
//  ViewController.swift
//  To Do List
//
//  Created by Olexsii Levchenko on 10/22/21.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    let realm = try! Realm()
    
    @IBOutlet var toDoListTableView: UITableView!
    
    var ithemArray: Results<Item>?
    
    var selectCategory: Category? {
        didSet {
            loadItem()
        }
    }
    
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
        return ithemArray?.count ?? 0
    }
    
    
    //The method is responsible for what should be displayed in our cells.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = toDoListTableView.dequeueReusableCell(withIdentifier: "ToDoIthemCell", for: indexPath) as! TableViewCell
        
        if let item = ithemArray?[indexPath.row] {
        cell.taskLabel.text = item.title
        
        cell.checkMark.checkState = item.done == true ? .checked : .unchecked
        } else {
            cell.taskLabel.text = "No Item Added"
        }
        return cell
    }
    
    
    //MARK: - TableView Delegate Method
    
    //Tells the delegate a row is selected
    override  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
//        context.delete(ithemArray[indexPath.row])
//        ithemArray.remove(at: indexPath.row)
        
        //ithemArray?[indexPath.row].done = !ithemArray?[indexPath.row].done
        //save(item: <#T##Item#>)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
   
    //MARK: - Add New Items
    
    @IBAction func addNewItems(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in

            //What will happen once the user clicks the Add Item button on our UIAlert."
            let newItem = Item()
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory //= self.selectCategory
            self.save(item: newItem)
        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)

        present(alert, animated: true, completion: nil)
    }
   
    
    //MARK: - Save and load data methods
    func save(item: Item) {
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
    
    func loadItem() {
        
        ithemArray = selectCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
}

//MARK: - Search Bar Methods

//extension ToDoListViewController: UISearchBarDelegate {
//
//    //Method executes a query to search for data by criteria and sorts them
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//
//        //Created our predicate which specifies how we want to query our database
//        let searchPredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        loadItem(with: request, predicate: searchPredicate)
//    }
//
//    //If search bar did text change to zero symbol, back to original items state.
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//            loadItem()
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//        }
//    }
//}
