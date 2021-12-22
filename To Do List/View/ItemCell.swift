//
//  ItemCell.swift
//  To Do List
//
//  Created by Olexsii Levchenko on 12/22/21.
//

import UIKit
import M13Checkbox
import SwipeCellKit
class ItemCell: SwipeTableViewCell {

    @IBOutlet weak var checkMark: M13Checkbox!
    @IBOutlet weak var itemLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
