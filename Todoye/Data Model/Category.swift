//
//  Category.swift
//  Todoye
//
//  Created by Zabeehullah Qayumi on 9/5/18.
//  Copyright © 2018 Zabeehullah Qayumi. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object{
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
