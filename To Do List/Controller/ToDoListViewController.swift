//
//  ViewController.swift
//  To Do List
//
//  Created by Olexsii Levchenko on 10/22/21.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var ithemArray = ["Olexsii Levchenko", "Sabina Babaeva", "Olga Levchenko"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Mark: - Registering a Table View Cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ToDoIthemCell")
        
    }
    
    // Mark: - Number Of Rows In Section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return ithemArray.count
    }
    
    // Mark: The method is responsible for what should be displayed in our cells.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoIthemCell", for: indexPath)
        cell.textLabel?.text = ithemArray[indexPath.row]
        return cell
    }
    
    //Mark: - Added TableView Delegate Method and Accessories for selecting a cell when clicked
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        print(ithemArray[indexPath.row])
        
        let cell = tableView.cellForRow(at: indexPath)
        if  cell?.accessoryType == .checkmark {
            cell!.accessoryType = .none
        } else {
            cell!.accessoryType = .checkmark
        }
    }
    
    @IBAction func addNewItems(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //What will happen once the user clicks the Add Item button on our UIAlert."
            self.ithemArray.append(textField.text!)
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

