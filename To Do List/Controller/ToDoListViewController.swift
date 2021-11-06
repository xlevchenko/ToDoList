//
//  ViewController.swift
//  To Do List
//
//  Created by Olexsii Levchenko on 10/22/21.
//

import UIKit
import M13Checkbox

class ToDoListViewController: UITableViewController {
    
    @IBOutlet var toDoListTableView: UITableView!
    
    var ithemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Mark: - Registering a Table View Cell
        toDoListTableView.delegate = self
        toDoListTableView.dataSource = self
        
        //Mark: - Get data from UserDefaults
//        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
//            ithemArray = items
//        }
        
        let newItem = Item()
        newItem.title = "drink wather"
        newItem.done = false
        ithemArray.append(newItem)
        let newItem2 = Item()
        newItem2.title = "drink alcogol"
        newItem2.done = false
        ithemArray.append(newItem2)
    }
    
    
    // Mark: - Number Of Rows In Section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ithemArray.count
    }
    
    
    // Mark: - Tells the delegate a row is selected
    override  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        ithemArray[indexPath.row].done = !ithemArray[indexPath.row].done
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: false)
        
    }


    // Mark: The method is responsible for what should be displayed in our cells.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = toDoListTableView.dequeueReusableCell(withIdentifier: "ToDoIthemCell", for: indexPath) as! TableViewCell
        
        let item = ithemArray[indexPath.row]
        cell.taskLabel.text = item.title
        
        
        if item.done == true {
            cell.checkMark.setCheckState(.checked, animated: true)
        } else {
            cell.checkMark.setCheckState(.unchecked, animated: true)
        }
        
        return cell
    }
    

    @IBAction func addNewItems(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //What will happen once the user clicks the Add Item button on our UIAlert."
            let newItem = Item()
            newItem.title = textField.text!
            
            self.ithemArray.append(newItem)
            self.defaults.set(self.ithemArray, forKey: "ToDoListArray")
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}

