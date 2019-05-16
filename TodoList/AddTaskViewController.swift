//
//  AddTaskViewController.swift
//  TodoList
//
//  Created by Uday Kiran Veginati on 5/16/19.
//  Copyright © 2019 Uday Kiran Veginati. All rights reserved.
//

import UIKit

enum TaskMode {
    case Add
    case Edit
}

class AddTaskViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!

    var taskType: TaskMode = .Add
    var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Configure left & right bar buttons
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                                target: self,
                                                                action: #selector(cancelButtonAction))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                                 target: self,
                                                                 action: #selector(addListItemAction))
        contentTextView.layer.borderColor = UIColor.gray.cgColor
        contentTextView.layer.borderWidth = 0.3
        contentTextView.layer.cornerRadius = 2.0
        contentTextView.clipsToBounds = true
        switch taskType {
        case .Add:
            self.navigationItem.title = "Add Task"
        case .Edit:
            self.navigationItem.title = "Edit Task"
            // Load task if in editing mode
            if let index = selectedIndexPath?.row {
                let item = list[index]
                titleTextField.text = item.title
                contentTextView.text = item.detail
            }
        }
    }
    
    // Done after Adding or editing task
    @IBAction func addListItemAction(_ sender: Any) {
        guard let title = titleTextField.text, title.count > 0 else {
            return
        }
        let detail = contentTextView.text ?? ""
        let item = TodoList(title: title, detail: detail)
        if taskType == .Edit, let index = selectedIndexPath?.row {
            list.remove(at: index)
            list.insert(item, at: index)
        } else {
            list.append(item)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
