//
//  Item.swift
//  Todoye
//
//  Created by Zabeehullah Qayumi on 9/5/18.
//  Copyright © 2018 Zabeehullah Qayumi. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object{
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
