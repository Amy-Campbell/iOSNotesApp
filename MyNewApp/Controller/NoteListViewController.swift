//
//  TableViewController.swift
//  MyNewApp
//
//  Created by Amy Campbell on 2021-06-21.
//

import UIKit
import CoreData


class NoteListViewController: UITableViewController {

    var noteArray = [Note]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedNote : Note?
    var selectedNoteIndex : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
//        let entity = NSEntityDescription.entity(forEntityName: "Note", in: context)
//        let newNote = NSManagedObject(entity: entity!, insertInto: context)
//        newNote.setValue("My Second Note", forKey: "title")
//        newNote.setValue("Text Content", forKey: "text")
        
        saveNotes()
        
        
        
        loadNotes()
        
        tableView.reloadData()
    }
    
    //MARK: - segue management
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tableToNote" {
            let destinationVC = segue.destination as! NoteViewController //downcasting
            destinationVC.noteTitle = selectedNote?.title
            destinationVC.noteText = selectedNote?.text
            destinationVC.position = selectedNoteIndex
            destinationVC.senderVC = self
        }
    }

    // MARK: - Table view data source

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell",for: indexPath)
        
        let note = noteArray[indexPath.row]
        
        if note.title! != ""{
            cell.textLabel?.text = "\(note.title!)"
        } else {
            cell.textLabel?.text = "Untitled Note"
        }

        return cell
    }
    //MARK: - Data Management
    
    
    func saveNotes(){
        
        do {
            try context.save()
            
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    func loadNotes(){
        let request = NSFetchRequest<Note>(entityName: "Note")
                //request.predicate = NSPredicate(format: "age = %@", "12")
                request.returnsObjectsAsFaults = false
                do {
                    let result = try context.fetch(request)
                    noteArray = result
                    
                } catch {
                    
                    print("Failed")
                }
    }
    //MARK: - Add New Note
    
    @IBAction func addNewNote(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Note", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Create", style: .default) { (action) in
            
            //what will happen once the user clicks the add button
            let newNote = Note(context: self.context)
            newNote.title = textField.text!
            self.noteArray.append(newNote)
            
            self.saveNotes()
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New Note Title"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - called by destination view controller
    
    func updateNote(position : Int, newTitle : String, newText : String){
        noteArray[position].title = newTitle
        noteArray[position].text = newText
        
        saveNotes()
        tableView.reloadData()
    }
    
    func deleteNote(position : Int){
        context.delete(noteArray[position]) //remove data from permanent stores
        noteArray.remove(at: position) //remove from item array
        
        saveNotes()
        tableView.reloadData()
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    //MARK: - delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedNote = noteArray[indexPath.row]
        selectedNoteIndex = indexPath.row
        
        performSegue(withIdentifier: "tableToNote", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
