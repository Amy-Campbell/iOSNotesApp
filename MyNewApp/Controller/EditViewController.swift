//
//  ViewController.swift
//  MyNewApp
//
//  Created by Amy Campbell on 2021-06-24.
//

import UIKit
import RealmSwift

class EditViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    let realm = try! Realm()
    var senderVC : NoteViewController?
    var selectedNote : Note?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleTextField.delegate = self
        titleTextField.text = selectedNote?.title
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func deletePressed(_ sender: UIButton) {
        do {
            try realm.write {
                if let noteToDelete = selectedNote {
                    realm.delete(noteToDelete)
                }
            }
        } catch {
            print("error deleting note : \(error)")
        }
        navigationController?.popToRootViewController(animated: true)
    }
}
//MARK: - textfield delegate methods
extension EditViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text != "" {
            print("updating title to: \(textField.text!)")
            do {
                try realm.write{
                     selectedNote?.title = textField.text!
                }
            } catch {
                print("error updating title")
            }
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("begin editing")
            //highlights all text
        textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
    }
    

}
