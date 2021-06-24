//
//  ViewController.swift
//  MyNewApp
//
//  Created by Amy Campbell on 2021-06-21.
//

import UIKit
import CoreData


class NoteViewController: UIViewController {

    
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var noteTextView: UITextView!
    
    var isDeleted : Bool = false
    var noteTitle : String?
    var noteText : String?
    var position : Int?
    var senderVC : NoteListViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noteTextView.delegate = self
        
        
        noteTextView.text = noteText
        navigationBar.title = noteTitle
        
        
    }
    
    //MARK: - edit title
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Edit Title", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Confirm", style: .default) { (action) in
            self.navigationBar.title = textField.text!
            self.saveData()
        }
        alert.addTextField { (alertTextField) in
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }

    
    @IBAction func trashButtonPressed(_ sender: UIBarButtonItem) {
        senderVC?.deleteNote(position: position!)
        isDeleted = true
        
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func saveData(){
        if !isDeleted{
            senderVC?.updateNote(position: position!, newTitle: navigationBar.title!, newText: noteTextView.text!)
        }

    }
    override func viewWillDisappear(_ animated: Bool) {
        saveData()
    }
}

//MARK: - text field delegate methods

extension NoteViewController : UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        saveData()
    }
    
}

