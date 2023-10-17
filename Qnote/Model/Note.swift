//
//  Note.swift
//  Qnote
//
//  Created by Jose Antonio on 15/10/23.
//

import Foundation
import RealmSwift

class Note: Object{
    
    @objc dynamic var title: String = "Nueva nota"
    @objc dynamic var text: String = ""
    
}
