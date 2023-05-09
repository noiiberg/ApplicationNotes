//
//  NoteViewController.swift
//  tapp
//
//  Created by Noi Berg on 25.04.2023.
//

import UIKit

class NoteViewController: UIViewController {

    var noteLable = UITextView()
    
    public var note = String()
    public var editHandler: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        
    }

}

// MARK: - Setting Views
extension NoteViewController {
    fileprivate func setUpViews() {
        overrideUserInterfaceStyle = .dark
        createNoteLable()
        editButton()
        createNoteLableConstraints()
    }
}

// MARK: - Tap Cell
extension NoteViewController {
    fileprivate func createNoteLable() {
        noteLable.translatesAutoresizingMaskIntoConstraints = false
        noteLable.text = self.note
        noteLable.font = .systemFont(ofSize: 20)
        noteLable.isEditable = false
        view.addSubview(noteLable)
    }
}

// MARK: - Edit Note
extension NoteViewController {
    fileprivate func editButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(selectorEdit))
        
    }
    
    @objc func selectorEdit() {
        noteLable.isEditable = true
        noteLable.becomeFirstResponder()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(selectorSave))
    }
    @objc func selectorSave() {
        guard let text = noteLable.text, !text.isEmpty else { return }
        editHandler?(noteLable.text!)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(selectorEdit))
        noteLable.isEditable = false
        
    }
}

// MARK: - Constraints
extension NoteViewController {
    func createNoteLableConstraints() {
        noteLable.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        noteLable.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        noteLable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        noteLable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
    }
    
}
