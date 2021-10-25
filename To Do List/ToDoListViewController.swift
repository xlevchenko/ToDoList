//
//  ViewController.swift
//  To Do List
//
//  Created by Olexsii Levchenko on 10/22/21.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    let ithemArray = ["Olexsii Levchenko", "Sabina Babaeva", "Olga Levchenko"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Mark: - Registering a Table View Cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ToDoIthemCell")
        
    }
    
    // Mark: number Of Rows In Section
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
}
