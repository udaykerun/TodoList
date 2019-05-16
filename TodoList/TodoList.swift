//
//  TodoList.swift
//  TodoList
//
//  Created by Uday Kiran Veginati on 5/16/19.
//  Copyright © 2019 Uday Kiran Veginati. All rights reserved.
//

import Foundation

struct TodoList {
    var title: String = ""
    var detail: String?
    
    init(title: String, detail: String?) {
        self.title = title
        self.detail = detail
    }
}
