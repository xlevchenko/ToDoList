//
//  Category.swift
//  To Do List
//
//  Created by Olexsii Levchenko on 12/2/21.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name = ""
    let items = List<Item>()
}
