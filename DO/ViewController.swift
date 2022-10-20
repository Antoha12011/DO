//
//  ViewController.swift
//  DO
//
//  Created by Антон Павлов on 15.09.2022.
//

import UIKit




class ViewController: UIViewController, UITableViewDataSource {
    
    private let table: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    var items = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.items = UserDefaults.standard.stringArray(forKey: "items") ?? []
        title = "Список дел"
        view.addSubview(table)
        table.dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
    }
    
    @objc private func didTapAdd() {
        let alert = UIAlertController(title: "Новая кнопка", message: "Создай новую задачу",
                                      preferredStyle: .alert)
        alert.addTextField { field in
            field.placeholder = "Нажми кнопку..."
        }
        alert.addAction(UIAlertAction(title: "Назад", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Выполнить", style: .default, handler: { [weak self](_) in
            if let field = alert.textFields?.first {
                if let text = field.text, !text.isEmpty {
                    
                    DispatchQueue.main.async {
                        var currentItem = UserDefaults.standard.stringArray(forKey: "items") ?? []
                        currentItem.append(text)
                        UserDefaults.standard.set(currentItem, forKey: "items")
                        self?.items.append(text)
                        self?.table.reloadData()
                    }
                    
                }
            }
        }))
        
        present(alert, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        table.frame = view.bounds
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
}

