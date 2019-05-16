//
//  ViewController.swift
//  TodoList
//
//  Created by Uday Kiran Veginati on 5/16/19.
//  Copyright © 2019 Uday Kiran Veginati. All rights reserved.
//

import UIKit

var list = [TodoList]()

class ViewController: UIViewController {

    @IBOutlet weak var taskTableView: UITableView!
    let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: nil, action: #selector(editButtonTap))
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneButtonTap))

    @objc func doneButtonTap() {
        self.navigationItem.leftBarButtonItem = editButton
        taskTableView.setEditing(false, animated: true)
    }
    
    @objc func editButtonTap() {
        guard !list.isEmpty else {
            return
        }
        self.navigationItem.leftBarButtonItem = doneButton
        taskTableView.setEditing(true, animated: true)
    }
    
    @IBAction func addTask(_ sender: Any) {
        self.openAddTaskVC(taskType: .Add, at: nil)
    }
    
    // Open detail page to add or edit task
    func openAddTaskVC(taskType: TaskMode, at indexpath: IndexPath?) {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        if let addVC = mainStoryBoard.instantiateViewController(withIdentifier: "AddTaskViewController") as? AddTaskViewController {
            addVC.taskType = taskType
            addVC.selectedIndexPath = indexpath
            self.navigationController?.pushViewController(addVC, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        loadAllData()
        self.navigationItem.leftBarButtonItem = editButton
        doneButton.target = self
        editButton.target = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
//        saveAllData()
        taskTableView.reloadData()
    }
    
    // Save tasks into user defaults
    func saveAllData() {
        let data = list.map {
            [
                "title": $0.title,
                "detail": $0.detail!,
            ]
        }
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "items")
        userDefaults.synchronize()
    }
    
    // Retrive tasks from user defaults
    func loadAllData() {
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "items") as? [[String: AnyObject]] else {
            return
        }
        list = data.map {
            let title = $0["title"] as? String
            let detail = $0["detail"] as? String
            return TodoList(title: title!, detail: detail)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
        cell.textLabel?.text = list[indexPath.row].title
        cell.detailTextLabel?.text = list[indexPath.row].detail
        return cell
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedItem = list[sourceIndexPath.row]
        list.remove(at: sourceIndexPath.row)
        list.insert(movedItem, at: destinationIndexPath.row)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        list.remove(at: indexPath.row)
        taskTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.openAddTaskVC(taskType: .Edit, at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = list[indexPath.row]
        let subTitleHeight: CGFloat = (item.detail != nil) ? self.estimatedHeightOfLabel(text: item.detail!) : 0.0
        return subTitleHeight + 35.0
    }
    
    func estimatedHeightOfLabel(text: String) -> CGFloat {
        let size = CGSize(width: view.frame.width - 20, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]
        let rectangleHeight = String(text).boundingRect(with: size, options: options, attributes: attributes, context: nil).height
        return rectangleHeight
    }
}
