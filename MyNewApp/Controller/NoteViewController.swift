//
//  ViewController.swift
//  MyNewApp
//
//  Created by Amy Campbell on 2021-06-21.
//

import UIKit
import RealmSwift


class NoteViewController: UIViewController {

    
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var noteTextView: UITextView!
    
    var selectedNote : Note? {
        didSet{
            //loadNote()
        }
    }
    let realm = try! Realm()
    var isDeleted : Bool = false
    var position : Int?
    var senderVC : NoteListViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("load note")
        
        noteTextView.delegate = self
        
        
        noteTextView.text = selectedNote?.text
        navigationBar.title = selectedNote?.title
        
        
    }
    
    func saveData(){
    }
    override func viewWillDisappear(_ animated: Bool) {
        //saveData()
    }
    //MARK: - segue management
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "noteToEdit" {
            let destinationVC = segue.destination as! EditViewController //downcasting
            destinationVC.senderVC = self
            destinationVC.selectedNote = self.selectedNote
        }
    }
}

//MARK: - text field delegate methods

extension NoteViewController : UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        print("End editing")
        
        if let newText = noteTextView.text{
            do {
                try realm.write{
                    selectedNote?.text = newText
                }
            }catch {
                print("Error saving done status: \(error)")
            }
        }
    }
    
}

