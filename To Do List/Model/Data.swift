//
//  Data.swift
//  To Do List
//
//  Created by Olexsii Levchenko on 11/25/21.
//

import Foundation
import RealmSwift


class Data: Object {
    @Persisted var name: String = ""
    @Persisted var age: Int = 0
}
