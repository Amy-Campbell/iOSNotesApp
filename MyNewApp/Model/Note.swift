//
//  Note.swift
//  MyNewApp
//
//  Created by Amy Campbell on 2021-06-26.
//

import Foundation
import RealmSwift

class Note : Object {
    @objc dynamic var title : String = "New Note"
    @objc dynamic var text: String = ""
}
