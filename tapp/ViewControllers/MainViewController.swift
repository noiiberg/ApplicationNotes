//
//  MainViewController.swift
//  tapp
//
//  Created by Noi Berg on 22.04.2023.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
    
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    static var tableView = UITableView()
    let refreshControl = UIRefreshControl()
    let cellReuseIdentifier = "cell"
    let valueError = "Value didn't come"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
}


// MARK: - Setting Views
extension MainViewController {
    fileprivate func setUpViews() {
        overrideUserInterfaceStyle = .dark
        createNavigationBar()
        createTableView()
        tableRefresh()
        didTapNewNote()
        DataManager.getAllItems()
    }
}


// MARK: - Navigation Bar
extension MainViewController {
    fileprivate func createNavigationBar() {
        title = "Notes"
        navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
}


// MARK: - Table View
extension MainViewController {
    fileprivate func createTableView() {
        MainViewController.tableView = UITableView(frame: view.bounds, style: .plain)
        MainViewController.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        MainViewController.tableView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        MainViewController.tableView.delegate = self
        MainViewController.tableView.dataSource = self
        view.addSubview(MainViewController.tableView)
     }
}


// MARK: - Table Refresh
extension MainViewController {
    func tableRefresh() {
        self.refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        MainViewController.tableView.addSubview(refreshControl)
        refreshControl.tintColor = .systemGray
    }
    
    @objc func refresh() {
        refreshControl.endRefreshing()
        DispatchQueue.main.async {
            MainViewController.tableView.reloadData()
        }
     }
}


// MARK: - New Note Button
extension MainViewController {
    fileprivate func didTapNewNote() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tapAction))
    }
    
    @objc func tapAction() {
        EntryViewController.saveHandler = { titleNotes, notes in
            DataManager.createItems(title: titleNotes, notes: notes)
            MainViewController.tableView.isHidden = false
            MainViewController.tableView.reloadData()
        }
        navigationController?.pushViewController(EntryViewController(), animated: true)
    }
}


// MARK: - Delegate, DataSource
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Model.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        let title = Model.items[indexPath.row].title
        let notes = Model.items[indexPath.row].notes
        var content = cell.defaultContentConfiguration()
        content.text = "\(title ?? valueError)"
        content.secondaryText = "\(notes ?? valueError)"
        cell.contentConfiguration = content
        
        return cell
    }
    
    // Show note controller
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let noteViewController = NoteViewController()
        let noteItems = Model.items[indexPath.row]
        noteViewController.note = noteItems.notes ?? valueError
        
        noteViewController.navigationItem.largeTitleDisplayMode = .automatic
        noteViewController.title = "\(Model.items[indexPath.row].title ?? valueError)"
        noteViewController.view.backgroundColor = .black
        
        noteViewController.editHandler = { notes in
            Model.items[indexPath.row].notes = notes
            DataManager.updateItems(item: noteItems, newNotes: notes)
            MainViewController.tableView.reloadData()
        }
        navigationController?.pushViewController(noteViewController, animated: true)
    }
    
    // Remove Cell
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let item = Model.items[indexPath.row]
        
        guard editingStyle == .delete else { return }
        tableView.beginUpdates()
        Model.items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        DataManager.deleteItems(item: item)
        tableView.endUpdates()
    }
    
}
