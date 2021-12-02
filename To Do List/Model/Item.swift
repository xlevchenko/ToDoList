//
//  Item.swift
//  To Do List
//
//  Created by Olexsii Levchenko on 12/2/21.
//

import Foundation
import RealmSwift


class Item: Object {
    @objc dynamic var title = ""
    @objc dynamic var done = false
    
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
