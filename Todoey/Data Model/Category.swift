//
//  Category.swift
//  Todoey
//
//  Created by Nived Pradeep on 29/11/18.
//  Copyright © 2018 Nived Pradeep. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let item = List<Item>()
    @objc dynamic var cellColour : String = ""
}
