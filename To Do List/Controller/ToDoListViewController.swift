//
//  ViewController.swift
//  To Do List
//
//  Created by Olexsii Levchenko on 10/22/21.
//

import UIKit
import M13Checkbox
import CoreData

class ToDoListViewController: UITableViewController {
    
    @IBOutlet var toDoListTableView: UITableView!
    
    var ithemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    
    //Initialize CoreData (configure your code to use Core Data)
    let context = (UIApplication.shared.delegate as! AppDelegate) .persistentContainer.viewContext
    
    
    
    //let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Mark: - Registering a Table View Cell
        toDoListTableView.delegate = self
        toDoListTableView.dataSource = self
        
//        loadItem()
    }
    
    
    // Mark: - Number Of Rows In Section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ithemArray.count
    }
    
    
    // Mark: - Tells the delegate a row is selected
    override  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        ithemArray[indexPath.row].done = !ithemArray[indexPath.row].done
        
        saveItem()
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
    // Mark: The method is responsible for what should be displayed in our cells.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = toDoListTableView.dequeueReusableCell(withIdentifier: "ToDoIthemCell", for: indexPath) as! TableViewCell
        
        let item = ithemArray[indexPath.row]
        cell.taskLabel.text = item.title
        
        cell.checkMark.checkState = item.done == true ? .checked : .unchecked
        
        return cell
    }
    
    
    @IBAction func addNewItems(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //What will happen once the user clicks the Add Item button on our UIAlert."
            
            
            let newItem = Item(context: self.context)
            
            newItem.title = textField.text!
            newItem.done = false
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
    
    //Save our new items in database(using Core Data)
    func saveItem() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
//    func loadItem() {
//        if let data = try? Data(contentsOf: dataFilePath!) {
//            let decode = PropertyListDecoder()
//            do {
//                ithemArray = try decode.decode([Item].self, from: data)
//            } catch {
//                print("Error \(error)")
//            }
//        }
//    }
}



