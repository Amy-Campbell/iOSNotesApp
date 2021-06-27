//
//  TableViewController.swift
//  MyNewApp
//
//  Created by Amy Campbell on 2021-06-21.
//

import UIKit
import RealmSwift


class NoteListViewController: UITableViewController {

    let realm = try! Realm()
    var noteList : Results<Note>?
    
    var selectedNote : Note?
    var selectedNoteIndex : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadNotes()
        
        tableView.reloadData()
    }
    
    //MARK: - segue management
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tableToNote" {
            let destinationVC = segue.destination as! NoteViewController //downcasting
            if let indexPath = tableView.indexPathForSelectedRow{
                destinationVC.selectedNote = noteList?[indexPath.row]
                destinationVC.senderVC = self
            }
        }
    }

    // MARK: - Table view data source

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteList?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell",for: indexPath)
        
        cell.textLabel?.text = noteList?[indexPath.row].title ?? "No Existing Notes"


        return cell
        
        
    }
    //MARK: - Data Management
    
    
    func saveNotes(note: Note){
        
        do {
            try realm.write{
                realm.add(note)
            }
        } catch {
            print("Error saving note!")
        }
        
        tableView.reloadData()
    }
    
    
    func loadNotes(){
        noteList = realm.objects(Note.self)
        tableView.reloadData()
    }
    //MARK: - Add New Note
    
    @IBAction func addNewNote(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Note", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Create", style: .default) { (action) in
            
            //what will happen once the user clicks the add button
            let newNote = Note()
            if textField.text! != ""{
                newNote.title = textField.text!
            } else {
                newNote.title = "New Note"
            }
            
            self.saveNotes(note: newNote)
            
            self.tableView.reloadData()
            
            self.selectedNote = newNote
            //self.selectedNoteIndex = self.noteList.count - 1
            
            self.performSegue(withIdentifier: "tableToNote", sender: self)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            
        
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New Note Title"
            alertTextField.text = "New Note"
            alertTextField.autocapitalizationType = .words
            alertTextField.delegate = self
            textField = alertTextField
        }
        alert.addAction(cancelAction)
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - called by destination view controller
    
    func updateNote(position : Int, newTitle : String, newText : String){
        //noteList[position].title = newTitle
        //noteList[position].text = newText
        
        tableView.reloadData()
    }
    
    
    
    //MARK: - delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "tableToNote", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension NoteListViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
    }
}

