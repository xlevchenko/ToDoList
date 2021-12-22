//
//  ViewController.swift
//  To Do List
//
//  Created by Olexsii Levchenko on 10/22/21.
//

import UIKit
import RealmSwift
import M13Checkbox
import SwipeCellKit

class ToDoListViewController: UITableViewController, SwipeTableViewCellDelegate {
    
//    class ListCell: UITableViewCell {
//        @IBOutlet weak var checkMark: M13Checkbox!
//        @IBOutlet weak var taskLabel: UILabel!
//    }
    
    let realm = try! Realm()
        
    var itemList: Results<Item>?
    
    var selectCategory: Category? {
        didSet {
            loadItem()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "ItemCell", bundle: nil), forCellReuseIdentifier: "ItemCell")
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        //Mark: - Registering a Table View Cell
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = 65.0
    }
    
    
    //MARK: - TableView DataSource Methods
    
    //Number Of Rows In Section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList?.count ?? 0
    }
    
    
    //The method is responsible for what should be displayed in our cells.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        //To make the cell Swipeable via SwipeCellKit
        cell.delegate = self
        
        if let item = itemList?[indexPath.row] {
            cell.itemLabel?.text = item.title
            cell.checkMark.checkState = item.done == true ? .checked : .unchecked
        } else {
            cell.itemLabel.text = "No Item Added"
        }
        return cell
    }
   
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            self.updateModel(at: indexPath)
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "Trash")

        return [deleteAction]
    }
    
    //MARK: - TableView Delegate Method
    
    //Tells the delegate a row is selected
    override  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        if let item = itemList?[indexPath.row] {
            do {
                try realm.write{
                    item.done = !item.done
                }
            } catch {
                print("Error saving \(error)")
            }
        }
        
        tableView.reloadData()
    }
    
   
    //MARK: - Add New Items
    
    @IBAction func addNewItems(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //What will happen once the user clicks the Add Item button on our UIAlert."
            if let currentCategory = self.selectCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.personData = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving \(error)")
                }
                self.tableView.reloadData()
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - Save and load data methods
    
    func loadItem() {
        
        itemList = selectCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }

//MARK: - Delete Data from Swipe
     func updateModel(at indexPath: IndexPath) {
        if let itemForDelition = itemList?[indexPath.row]
        {
            do {
                try realm.write {
                    realm.delete(itemForDelition)
                }
            } catch {
                print("eror deleting object \(error)")
            }
        }
    }
}
//MARK: - Search Bar Methods

extension ToDoListViewController: UISearchBarDelegate {
    
    //Method executes a query to search for data by criteria and sorts them
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        itemList = itemList?.filter("title CONTAINS[cd] %@", searchBar.text!)//.sorted(by: "personID", ascending: true)
        tableView.reloadData()
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
