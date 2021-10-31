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
    
    
    
    var ithemArray = ["Olexsii Levchenko", "Sabina Babaeva", "Olga Levchenko"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Mark: - Registering a Table View Cell
        toDoListTableView.delegate = self
        toDoListTableView.dataSource = self
        
       
    }
    
    // Mark: - Number Of Rows In Section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ithemArray.count
    }

    // Mark: The method is responsible for what should be displayed in our cells.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = toDoListTableView.dequeueReusableCell(withIdentifier: "ToDoIthemCell", for: indexPath) as! TableViewCell
        
        let checkbox = M13Checkbox(frame: CGRect(x: 4.0, y: 8.0, width: 30.0, height: 30.0))
        cell.taskLabel.text = ithemArray[indexPath.row]
        cell.checkMark.addSubview(checkbox)
        return cell
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

