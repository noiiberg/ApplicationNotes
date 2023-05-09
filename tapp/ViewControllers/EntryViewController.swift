//
//  EntryViewController.swift
//  tapp
//
//  Created by Noi Berg on 23.04.2023.
//

import UIKit

class EntryViewController: UIViewController {

    var titleField = UITextField()
    var noteField = UITextView()
    let noteFieldText = "Enter text"
    
    static var saveHandler: ((String, String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
}

// MARK: - Setting Views
extension EntryViewController {
    fileprivate func setUpViews() {
        overrideUserInterfaceStyle = .dark
        view.backgroundColor = .black
        createTitleField()
        createTextView()
        saveButton()
        constraintTitleField()
        constraintTextView()
        keyboardNotificationCenter()
    }
}


// MARK: - Text Field
extension EntryViewController {
    fileprivate func createTitleField() {
        titleField.becomeFirstResponder()
        titleField.placeholder = "Enter title"
        titleField.backgroundColor = .black
        titleField.font = .boldSystemFont(ofSize: 22)
        titleField.translatesAutoresizingMaskIntoConstraints = false
        titleField.delegate = self
        view.addSubview(titleField)
    }
}

// MARK: - Text View
extension EntryViewController {
    fileprivate func createTextView() {
        noteField.text = noteFieldText
        noteField.textColor = #colorLiteral(red: 0.1921568627, green: 0.1921568627, blue: 0.1921568627, alpha: 1)
        noteField.font = .systemFont(ofSize: 17)
        noteField.translatesAutoresizingMaskIntoConstraints = false
        noteField.delegate = self
        view.addSubview(noteField)
    }
}

// MARK: - Save Button
extension EntryViewController {
    fileprivate func saveButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(save))
    }
    @objc func save() {
        guard let text = titleField.text, !text.isEmpty, !noteField.text.isEmpty else { return }
        EntryViewController.saveHandler?(titleField.text!, noteField.text)
        
        navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: - noteField Placeholder Delegate
extension EntryViewController: UITextViewDelegate, UITextFieldDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard noteField.textColor == #colorLiteral(red: 0.1921568627, green: 0.1921568627, blue: 0.1921568627, alpha: 1) else { return }
            noteField.text = nil
            noteField.textColor = UIColor.white
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        guard noteField.text.isEmpty else { return }
            noteField.text = noteFieldText
            noteField.textColor = #colorLiteral(red: 0.1921568627, green: 0.1921568627, blue: 0.1921568627, alpha: 1)
        }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()

            return true
        }

}

// MARK: - Constraints
extension EntryViewController {
    func constraintTitleField() {
        titleField.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        titleField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        titleField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        titleField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    
    func constraintTextView() {
        noteField.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        noteField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        noteField.topAnchor.constraint(equalTo: titleField.bottomAnchor).isActive = true
        noteField.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
    }
    
}

// MARK: - Keyboard Notification
extension EntryViewController {
    fileprivate func keyboardNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView(param:)), name: UIResponder.keyboardDidShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView(param:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func updateTextView(param: Notification) {
          let userInfo = param.userInfo
          let getKeyboardRect = (userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
          let keyboardFrame = self.view.convert(getKeyboardRect, to: view.window)

          if param.name == UIResponder.keyboardWillHideNotification {
              noteField.contentInset = UIEdgeInsets.zero
          } else {
              noteField.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
              noteField.scrollIndicatorInsets = noteField.contentInset
          }
          noteField.scrollRangeToVisible(noteField.selectedRange)

      }

}
