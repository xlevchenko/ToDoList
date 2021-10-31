//
//  TableViewCell.swift
//  To Do List
//
//  Created by Olexsii Levchenko on 10/31/21.
//

import UIKit
import M13Checkbox

class TableViewCell: UITableViewCell {

    @IBOutlet weak var checkMark: M13Checkbox!
    @IBOutlet weak var taskLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
